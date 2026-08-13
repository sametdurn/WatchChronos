import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../media/data/models/tv_detail_model.dart';
import '../../media/data/tmdb_repository.dart';
import '../../watch_entries/data/models/media_type.dart';
import '../../watch_entries/data/models/watch_status.dart';
import '../../watch_entries/data/watch_entries_repository.dart';
import 'models/tv_time_import_models.dart';
import 'tv_time_match_engine.dart';

/// TV Time aktarımının anlık ilerlemesi (UI'da progress bar + mesaj için).
///
/// [messageKey] bir çeviri anahtarıdır (bkz. core/localization);
/// [messageParams] o anahtardaki `{param}` yer tutucularını doldurur. UI
/// katmanı `context.l10n.tp(messageKey, messageParams)` ile gösterir.
class TvTimeImportProgress {
  const TvTimeImportProgress({
    required this.current,
    required this.total,
    required this.messageKey,
    this.messageParams = const {},
  });

  final int current;
  final int total;
  final String messageKey;
  final Map<String, String> messageParams;
}

/// Eşleştirme motoru birden fazla güçlü aday bulup otomatik seçim
/// yapmadığında, kullanıcının manuel seçim yapması için bekleyen bir dizi
/// kaydı. [candidates] en fazla 3 adaydır, en yüksek puanlıdan başlar.
class TvTimePendingShowMatch {
  const TvTimePendingShowMatch({required this.show, required this.candidates});

  final TvTimeShowRecord show;
  final List<TvTimeMatchCandidate> candidates;
}

/// [TvTimePendingShowMatch] ile aynı, film kayıtları için.
class TvTimePendingMovieMatch {
  const TvTimePendingMovieMatch({
    required this.movie,
    required this.candidates,
  });

  final TvTimeMovieRecord movie;
  final List<TvTimeMatchCandidate> candidates;
}

/// Aktarım tamamlandığında kullanıcıya gösterilecek özet sonuç.
class TvTimeImportResult {
  /// TV Time export'unda toplam kaç dizi kaydı bulundu (takip edilsin
  /// edilmesin). 0 ise sorun parse aşamasındadır.
  int totalShowsFound = 0;

  /// Bunlardan kaçı gerçekten işlenmeye aday (takip/arşiv/favori/izlenmiş
  /// bölüm sinyallerinden en az biri olan). Sadece `is_followed` yerine bu
  /// daha geniş küme kullanılır; TV Time'da bitirilen bir diziyi takipten
  /// çıkarmak (unfollow) yaygındır ve bu diziler yine de aktarılmalıdır.
  int followedShowsFound = 0;

  /// TV Time export'unda toplam kaç film kaydı bulundu (watchlist + izlenen).
  int totalMoviesFound = 0;

  int matchedShows = 0;
  int matchedMovies = 0;
  int exactEpisodeShows = 0;
  int approximatedEpisodeShows = 0;
  final List<String> unmatchedShows = [];
  final List<String> unmatchedMovies = [];

  /// Birden fazla güçlü aday bulunup otomatik seçim yapılamayan kayıtlar.
  /// UI bu listeyi kullanıcıya sunup seçim yaptırmalı
  /// ([TvTimeImportService.resolveShowMatch] / `resolveMovieMatch`).
  final List<TvTimePendingShowMatch> pendingShowMatches = [];
  final List<TvTimePendingMovieMatch> pendingMovieMatches = [];
}

/// Ayrıştırılmış TV Time verisini alıp TMDB'de karşılık gelen dizi/filmi
/// çok alanlı bir güven puanlamasıyla ([TvTimeMatchEngine]) bulur ve
/// WatchChronos'un `watch_entries` / `episode_logs` tablolarına yazar.
///
/// Eşleştirme yalnızca isme bakmaz: başlık + orijinal başlık + yayın yılı
/// (TV Time başlığındaki "(YYYY)" ekinden) + (belirsiz durumlarda) TMDB'den
/// çekilen sezon/bölüm sayısı tutarlılığı birlikte değerlendirilir. İki en
/// güçlü aday birbirine çok yakın puanlıysa hiçbir otomatik seçim yapılmaz;
/// kayıt [TvTimeImportResult.pendingShowMatches]/`pendingMovieMatches`'e
/// alınır ve kullanıcıdan seçim istenir.
///
/// Not: TV Time'da yıldızlı bir puanlama sistemi yoktu (sadece bölüm/film
/// başına beğeni-tepki veriliyordu), bu yüzden puan aktarımı yapılmaz.
///
/// Bölüm geçmişi notu: TV Time export'u her dizi için bölüm bölüm tarihçe
/// vermez; sadece bazı (genelde yakın tarihli) izlemeler için bu düzeyde
/// veri bulunur, geri kalanı için sadece toplam izlenen bölüm sayısı
/// mevcuttur. Böyle dizilerde TMDB'den alınan sezon/bölüm sırasına göre
/// ilk N bölüm "izlendi" olarak işaretlenir (yaklaşık aktarım).
class TvTimeImportService {
  TvTimeImportService(this._tmdbRepository, this._watchEntriesRepository)
    : _matchEngine = TvTimeMatchEngine(_tmdbRepository);

  final TmdbRepository _tmdbRepository;
  final WatchEntriesRepository _watchEntriesRepository;
  final TvTimeMatchEngine _matchEngine;

  /// `import()` sırasında bir kez oluşturulup, sonradan (manuel eşleştirme
  /// çözümlerinde) bölüm geçmişine tekrar erişebilmek için saklanır.
  Map<String, List<TvTimeEpisodeWatch>> _episodesBySeries = {};

  /// Art arda kaç TMDB isteğinin *istisna fırlatarak* (ağ/kimlik doğrulama
  /// hatası vb.) başarısız olduğunu sayar. "Sonuç bulunamadı" (geçerli bir
  /// arama ama eşleşme yok) bu sayaca dahil edilmez, sadece gerçek hatalar
  /// sayılır. Belirli bir eşiğe ulaşılırsa aktarım tamamen durdurulup gerçek
  /// hata kullanıcıya gösterilir; aksi halde yüzlerce isteğin tek tek
  /// sessizce başarısız olduğu, sebebi anlaşılmayan bir "0 eşleşme" sonucu
  /// ortaya çıkardı.
  int _consecutiveMatchFailures = 0;
  static const _maxConsecutiveFailures = 5;

  Future<TvTimeImportResult> import(
    TvTimeImportData data, {
    required void Function(TvTimeImportProgress progress) onProgress,
  }) async {
    final result = TvTimeImportResult();
    _consecutiveMatchFailures = 0;

    result.totalShowsFound = data.shows.length;
    result.totalMoviesFound = data.movies.length;

    _episodesBySeries = <String, List<TvTimeEpisodeWatch>>{};
    for (final watch in data.episodeWatches) {
      _episodesBySeries
          .putIfAbsent(_seriesKey(watch.seriesName), () => [])
          .add(watch);
    }

    // "Takip ediliyor" tek başına yeterli bir sinyal değil: TV Time'da
    // bir diziyi bitirip takipten çıkarmak (unfollow) yaygındır. Bu yüzden
    // takip/arşiv/favori/izlenmiş bölüm sinyallerinden EN AZ BİRİ varsa
    // işlenmeye aday sayılır; hiçbiri yoksa (sadece listede görünüp hiç
    // dokunulmamış) atlanır.
    final candidateShows = data.shows
        .where(
          (s) =>
              s.isFollowed ||
              s.isArchived ||
              s.isFavorited ||
              s.episodesSeen > 0,
        )
        .toList();
    result.followedShowsFound = candidateShows.length;

    final total = candidateShows.length + data.movies.length;
    var current = 0;

    for (final show in candidateShows) {
      current++;
      onProgress(
        TvTimeImportProgress(
          current: current,
          total: total,
          messageKey: 'tv_time_progress_matching_show',
          messageParams: {'name': show.name},
        ),
      );

      final outcome = await _matchShow(show);
      if (!outcome.hasMatch && !outcome.isAmbiguous) {
        result.unmatchedShows.add(show.name);
        continue;
      }
      if (outcome.isAmbiguous) {
        result.pendingShowMatches.add(
          TvTimePendingShowMatch(show: show, candidates: outcome.candidates),
        );
        continue;
      }

      await _applyShowMatch(show, outcome.best!.tmdbId, result);
    }

    for (final movie in data.movies) {
      current++;
      onProgress(
        TvTimeImportProgress(
          current: current,
          total: total,
          messageKey: 'tv_time_progress_matching_movie',
          messageParams: {'name': movie.name},
        ),
      );

      final outcome = await _matchMovie(movie);
      if (!outcome.hasMatch && !outcome.isAmbiguous) {
        result.unmatchedMovies.add(movie.name);
        continue;
      }
      if (outcome.isAmbiguous) {
        result.pendingMovieMatches.add(
          TvTimePendingMovieMatch(movie: movie, candidates: outcome.candidates),
        );
        continue;
      }

      await _applyMovieMatch(movie, outcome.best!.tmdbId, result);
    }

    return result;
  }

  // ---------------------------------------------------------------------
  // Manuel eşleştirme çözümü (kullanıcı belirsiz bir adayı seçtiğinde)
  // ---------------------------------------------------------------------

  /// Kullanıcı, [TvTimeImportResult.pendingShowMatches] listesindeki bir
  /// öğe için adaylardan birini seçtiğinde çağrılır; seçilen `tmdbId` ile
  /// aynı veri aktarım işlemini (durum, favori, bölüm geçmişi vb.) uygular.
  Future<void> resolveShowMatch(
    TvTimeShowRecord show,
    int tmdbId,
    TvTimeImportResult result,
  ) => _applyShowMatch(show, tmdbId, result);

  /// Film karşılığı; bkz. [resolveShowMatch].
  Future<void> resolveMovieMatch(
    TvTimeMovieRecord movie,
    int tmdbId,
    TvTimeImportResult result,
  ) => _applyMovieMatch(movie, tmdbId, result);

  // ---------------------------------------------------------------------
  // Veri uygulama (TMDB eşleşmesi kesinleştikten sonra)
  // ---------------------------------------------------------------------

  Future<void> _applyShowMatch(
    TvTimeShowRecord show,
    int tmdbId,
    TvTimeImportResult result,
  ) async {
    TvDetailModel? detail;
    try {
      detail = await _tmdbRepository.getTvDetail(tmdbId);
    } catch (_) {
      detail = null;
    }

    var status = show.episodesSeen <= 0
        ? WatchStatus.planned
        : (detail != null &&
              detail.numberOfEpisodes > 0 &&
              show.episodesSeen >= detail.numberOfEpisodes)
        ? WatchStatus.completed
        : WatchStatus.watching;

    // TV Time'da bir diziyi arşivlemek genelde "artık aktif takip etmiyorum"
    // anlamına gelir. WatchChronos'ta ayrı bir "Bırakıldı" durumu
    // bulunmadığından (kaldırıldı — hiçbir yerden seçilemiyordu), arşivlenip
    // henüz bitirilmemiş bir dizi de en yakın karşılığı olan "İzliyorum"a
    // düşer; zaten bitirilmiş bir dizi arşivlenmişse "Tamamlandı" durumu
    // korunur.
    if (show.isArchived && status != WatchStatus.completed) {
      status = WatchStatus.watching;
    }
    // "Sonra izle" (is_for_later) işaretli ama hiç bölüm izlenmemişse zaten
    // `planned` düşer; ekstra bir işlem gerekmez.

    final explicitEpisodes = _episodesBySeries[_seriesKey(show.name)];
    // TV Time'ın bölüm bazlı geçmişi genelde en yakın tarihli izlemeler
    // için tutulur — bu da genelde tam da dizinin FİNALİNE denk gelir.
    // Böyle bir tarih varsa, "bitirme tarihi" olarak aktarım anı (`now()`)
    // yerine bu gerçek tarih kullanılır; böylece "Tamamlandı" sekmesinde en
    // son bitirilen gerçekten en üstte çıkar.
    final lastWatchedAt = _latestWatchDate(explicitEpisodes);

    // TV Time'da ayrı bir "yeniden izleme sayısı" alanı olmasına rağmen
    // WatchChronos şemasında karşılığı yok; kaybolmasın diye not olarak
    // ekleniyor.
    final rewatchNote = show.rewatchCount > 0
        ? 'TV Time\'dan aktarıldı: en az ${show.rewatchCount + 1} kez izlendi.'
        : null;

    final entry = await _watchEntriesRepository.upsertStatus(
      tmdbId: tmdbId,
      mediaType: MediaType.tv,
      status: status,
      finishedAt: status == WatchStatus.completed ? lastWatchedAt : null,
      // Tamamlanmış bir dizide "kaldığı yer" göstermenin anlamı yok.
      currentSeason: status == WatchStatus.completed ? null : show.currentSeason,
      currentEpisode: status == WatchStatus.completed ? null : show.currentEpisode,
      appendNotes: rewatchNote,
    );

    if (show.isFavorited && !entry.isFavorite) {
      await _watchEntriesRepository.toggleFavorite(
        tmdbId: tmdbId,
        mediaType: MediaType.tv,
      );
    }

    // ÖNEMLİ: Kütüphanedeki "İzleniyor" <-> "Tamamlandı" ayrımı
    // `watch_entries.status` sütununa DEĞİL, gerçek `episode_logs` sayısına
    // göre anlık hesaplanır (bkz. tv_entry_classification.dart). TV Time
    // export'u bir dizi için sadece kısmi (genelde son birkaç izlemeye ait)
    // bölüm bazlı geçmiş verebilir; `episodesSeen` toplamı bundan çok daha
    // yüksek olabilir. Durum yukarıda "completed" olarak belirlendiyse ama
    // sadece bu kısmi listedeki bölümler işaretlenirse, gerçek izlenen
    // bölüm sayısı toplam bölüm sayısının altında kalır ve dizi
    // "Tamamlandı"ya hiç düşmeyip "İzleniyor"da takılı kalır. Bunu önlemek
    // için: durum "completed" ise TMDB'deki tüm bölümler izlendi olarak
    // işaretlenir (kısmi/yaklaşık aktarıma gerek kalmaz).
    if (status == WatchStatus.completed && detail != null) {
      await _markAllEpisodes(
        watchEntryId: entry.id,
        tmdbId: tmdbId,
        detail: detail,
      );
      result.exactEpisodeShows++;
    } else if (explicitEpisodes != null && explicitEpisodes.isNotEmpty) {
      for (final ep in explicitEpisodes) {
        await _watchEntriesRepository.markEpisodeWatched(
          watchEntryId: entry.id,
          seasonNumber: ep.seasonNumber,
          episodeNumber: ep.episodeNumber,
          watchedAt: ep.watchedAt,
        );
      }
      result.exactEpisodeShows++;
    } else if (show.episodesSeen > 0 && detail != null) {
      await _markFirstEpisodes(
        watchEntryId: entry.id,
        tmdbId: tmdbId,
        detail: detail,
        count: show.episodesSeen,
      );
      result.approximatedEpisodeShows++;
    }

    result.matchedShows++;
  }

  Future<void> _applyMovieMatch(
    TvTimeMovieRecord movie,
    int tmdbId,
    TvTimeImportResult result,
  ) async {
    final entry = await _watchEntriesRepository.upsertStatus(
      tmdbId: tmdbId,
      mediaType: MediaType.movie,
      status: movie.watched ? WatchStatus.completed : WatchStatus.planned,
      finishedAt: movie.watched ? movie.watchedAt : null,
    );

    if (movie.isFavorited && !entry.isFavorite) {
      await _watchEntriesRepository.toggleFavorite(
        tmdbId: tmdbId,
        mediaType: MediaType.movie,
      );
    }

    result.matchedMovies++;
  }

  Future<void> _markFirstEpisodes({
    required String watchEntryId,
    required int tmdbId,
    required TvDetailModel detail,
    required int count,
  }) async {
    var remaining = count;
    final seasons =
        detail.seasons
            .where((season) => season.seasonNumber > 0 && season.episodeCount > 0)
            .toList()
          ..sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));

    for (final season in seasons) {
      if (remaining <= 0) break;
      try {
        final seasonDetail = await _tmdbRepository.getSeasonDetail(
          tmdbId,
          season.seasonNumber,
        );
        final episodes = [...seasonDetail.episodes]
          ..sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));
        // Burada belirli bir `watchedAt` yok (TV Time'ın sadece "kaç bölüm
        // izlendi" toplamından yaklaşık aktarım yapılıyor, hepsi aynı şekilde
        // "şimdi" izlenmiş sayılıyor), bu yüzden `_markAllEpisodes`'taki gibi
        // sezon başına TEK bir toplu `markEpisodesWatched` upsert'i yeterli.
        // Önceden burada her bölüm için ayrı `markEpisodeWatched` çağrılıyordu
        // (N bölüm = N istek); kalabalık dizilerde (yüzlerce bölüm) içe
        // aktarımı gereksiz yere yavaşlatıyor ve fazladan yük bindiriyordu.
        final toMark = <int>[];
        for (final episode in episodes) {
          if (remaining <= 0) break;
          toMark.add(episode.episodeNumber);
          remaining--;
        }
        if (toMark.isNotEmpty) {
          await _watchEntriesRepository.markEpisodesWatched(
            watchEntryId: watchEntryId,
            seasonNumber: season.seasonNumber,
            episodeNumbers: toMark,
          );
        }
      } catch (_) {
        // Bir sezon detayı alınamazsa o sezonu atla, diğer sezonlarla devam et.
      }
    }
  }

  /// Bir dizinin TMDB'deki TÜM bölümlerini (tüm sezonlar) izlendi olarak
  /// işaretler. TV Time'da "tamamlandı" (izlenen bölüm sayısı >= TMDB'deki
  /// toplam bölüm sayısı) olarak belirlenen diziler için kullanılır; böylece
  /// gerçek `episode_logs` sayısı da TMDB toplamına ulaşır ve dizi
  /// kütüphanede doğru şekilde "Tamamlandı" olarak sınıflandırılır (bkz.
  /// tv_entry_classification.dart). Sezon başına toplu `upsert` kullanır
  /// (zaten izlenmiş bölümler `ignoreDuplicates` sayesinde soruna yol açmaz).
  Future<void> _markAllEpisodes({
    required String watchEntryId,
    required int tmdbId,
    required TvDetailModel detail,
  }) async {
    final seasons = detail.seasons.where(
      (season) => season.seasonNumber > 0 && season.episodeCount > 0,
    );

    for (final season in seasons) {
      try {
        final seasonDetail = await _tmdbRepository.getSeasonDetail(
          tmdbId,
          season.seasonNumber,
        );
        final episodeNumbers = seasonDetail.episodes
            .map((episode) => episode.episodeNumber)
            .toList();
        await _watchEntriesRepository.markEpisodesWatched(
          watchEntryId: watchEntryId,
          seasonNumber: season.seasonNumber,
          episodeNumbers: episodeNumbers,
        );
      } catch (_) {
        // Bir sezon detayı alınamazsa o sezonu atla, diğer sezonlarla devam et.
      }
    }
  }

  /// Bir dizinin TV Time'dan gelen bölüm bazlı izleme kayıtları arasından
  /// en yeni tarihli olanı döner (varsa). Genelde bu, dizinin finalinin
  /// izlendiği tarihe denk gelir ve gerçek "bitirme tarihi" olarak kullanılır.
  DateTime? _latestWatchDate(List<TvTimeEpisodeWatch>? episodes) {
    if (episodes == null || episodes.isEmpty) return null;
    DateTime? latest;
    for (final ep in episodes) {
      final date = ep.watchedAt;
      if (date == null) continue;
      if (latest == null || date.isAfter(latest)) latest = date;
    }
    return latest;
  }

  String _seriesKey(String name) =>
      name.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');

  // ---------------------------------------------------------------------
  // Eşleştirme (çok alanlı güven puanlaması `TvTimeMatchEngine`'de)
  // ---------------------------------------------------------------------

  Future<TvTimeMatchOutcome> _matchShow(TvTimeShowRecord show) async {
    try {
      final outcome = await _matchEngine.matchShow(
        rawName: show.yearHint != null ? '${show.name} (${show.yearHint})' : show.name,
        episodesSeenHint: show.episodesSeen > 0 ? show.episodesSeen : null,
      );
      _consecutiveMatchFailures = 0;
      return outcome;
    } catch (e) {
      _registerMatchFailure(show.name, e);
      return const TvTimeMatchOutcome.none();
    }
  }

  Future<TvTimeMatchOutcome> _matchMovie(TvTimeMovieRecord movie) async {
    try {
      final outcome = await _matchEngine.matchMovie(
        rawName: movie.name,
        releaseYearHint: movie.releaseYear,
        runtimeMinutesHint: movie.runtimeMinutes,
      );
      _consecutiveMatchFailures = 0;
      return outcome;
    } catch (e) {
      _registerMatchFailure(movie.name, e);
      return const TvTimeMatchOutcome.none();
    }
  }

  void _registerMatchFailure(String name, Object error) {
    _consecutiveMatchFailures++;
    if (_consecutiveMatchFailures >= _maxConsecutiveFailures) {
      throw Exception(
        'TMDB\'ye yapılan istekler art arda $_maxConsecutiveFailures kez '
        'başarısız oldu (son denenen: "$name"). Aktarım durduruldu; TMDB API '
        'anahtarı, kimlik doğrulama veya internet bağlantısıyla ilgili bir '
        'sorun olabilir.\nSon hata: $error',
      );
    }
  }
}

final tvTimeImportServiceProvider = Provider<TvTimeImportService>((ref) {
  return TvTimeImportService(
    ref.watch(tmdbRepositoryProvider),
    ref.watch(watchEntriesRepositoryProvider),
  );
});
