import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cache/media_cache_repository.dart';
import '../../../core/cache/models/cached_episode.dart';
import '../../../core/cache/models/cached_media.dart';
import '../../../core/cache/models/cached_season.dart';
import '../../watch_entries/data/models/media_type.dart';
import 'models/movie_detail_model.dart';
import 'models/season_detail_model.dart';
import 'models/tv_detail_model.dart';
import 'tmdb_repository.dart';

class MediaRepository {
  MediaRepository(this._tmdbRepository, this._mediaCacheRepository);

  final TmdbRepository _tmdbRepository;
  final MediaCacheRepository _mediaCacheRepository;

  Future<CachedMedia> getMediaDetail({
    required int tmdbId,
    required MediaType mediaType,
    bool forceRefresh = false,
  }) async {
    final cached = await _mediaCacheRepository.getMedia(
      tmdbId: tmdbId,
      mediaType: mediaType,
    );

    // Diziler için "status" alanı Kütüphane'deki sekme/grup sınıflandırması
    // (bkz. tv_entry_classification.dart) için KRİTİKTİR. Eski bir cache
    // kaydında bu alan boş kalmışsa (örn. bu alan eklenmeden önce
    // önbelleğe alınmış bir kayıt), cache hâlâ "taze" (7 gün) olsa bile
    // TMDB'den yeniden çekilir; aksi halde dizi "bitmemiş" (unknown)
    // kabul edilip yanlış gruba (örn. Devamı Gelecek yerine Tamamlandı
    // olması gerekirken) düşebilir.
    final missingStatus =
        mediaType == MediaType.tv &&
        cached != null &&
        (cached.status == null || cached.status!.isEmpty);

    final shouldUseCache =
        !forceRefresh &&
        !missingStatus &&
        cached != null &&
        !_mediaCacheRepository.isStale(cached.cachedAt);

    if (shouldUseCache) return cached;

    try {
      final fresh = await _fetchMediaFromTmdb(tmdbId, mediaType);
      await _mediaCacheRepository.upsertMedia(fresh);
      return fresh;
    } catch (e) {
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<CachedSeason> getSeasonDetail({
    required int tvId,
    required int seasonNumber,
    bool forceRefresh = false,
  }) async {
    final cached = await _mediaCacheRepository.getSeason(
      tvId: tvId,
      seasonNumber: seasonNumber,
    );

    final shouldUseCache =
        !forceRefresh &&
        cached != null &&
        !_mediaCacheRepository.isStale(cached.cachedAt);

    if (shouldUseCache) return cached;

    try {
      final detail = await _tmdbRepository.getSeasonDetail(tvId, seasonNumber);
      final fresh = _seasonDetailToCachedSeason(tvId, detail);
      await _mediaCacheRepository.upsertSeason(fresh);
      return fresh;
    } catch (e) {
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<CachedMedia> _fetchMediaFromTmdb(
    int tmdbId,
    MediaType mediaType,
  ) async {
    if (mediaType == MediaType.movie) {
      final detail = await _tmdbRepository.getMovieDetail(tmdbId);
      return _movieDetailToCachedMedia(detail);
    }
    final detail = await _tmdbRepository.getTvDetail(tmdbId);
    return _tvDetailToCachedMedia(detail);
  }

  CachedMedia _movieDetailToCachedMedia(MovieDetailModel model) {
    return CachedMedia()
      ..tmdbId = model.id
      ..mediaType = MediaType.movie
      ..title = model.title
      ..posterPath = model.posterPath
      ..backdropPath = model.backdropPath
      ..overview = model.overview
      ..releaseDate = _parseDate(model.releaseDate)
      ..voteAverage = model.voteAverage
      ..runtimeMinutes = model.runtime
      ..genres = model.genres.map((genre) => genre.name).toList()
      ..cachedAt = DateTime.now();
  }

  CachedMedia _tvDetailToCachedMedia(TvDetailModel model) {
    return CachedMedia()
      ..tmdbId = model.id
      ..mediaType = MediaType.tv
      ..title = model.name
      ..posterPath = model.posterPath
      ..backdropPath = model.backdropPath
      ..overview = model.overview
      ..firstAirDate = _parseDate(model.firstAirDate)
      ..voteAverage = model.voteAverage
      ..numberOfSeasons = model.numberOfSeasons
      ..numberOfEpisodes = model.numberOfEpisodes
      ..status = model.status.isEmpty ? null : model.status
      ..genres = model.genres.map((genre) => genre.name).toList()
      ..cachedAt = DateTime.now();
  }

  CachedSeason _seasonDetailToCachedSeason(int tvId, SeasonDetailModel model) {
    return CachedSeason()
      ..tvId = tvId
      ..seasonNumber = model.seasonNumber
      ..episodes = model.episodes
          .map(
            (episode) => CachedEpisode()
              ..episodeNumber = episode.episodeNumber
              ..name = episode.name
              ..overview = episode.overview
              ..stillPath = episode.stillPath
              ..airDate = _parseDate(episode.airDate),
          )
          .toList()
      ..cachedAt = DateTime.now();
  }

  DateTime? _parseDate(String? date) {
    if (date == null || date.isEmpty) return null;
    return DateTime.tryParse(date);
  }
}

final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  return MediaRepository(
    ref.watch(tmdbRepositoryProvider),
    ref.watch(mediaCacheRepositoryProvider),
  );
});