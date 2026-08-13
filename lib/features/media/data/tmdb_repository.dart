import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import 'models/cast_member_model.dart';
import 'models/movie_detail_model.dart';
import 'models/movie_model.dart';
import 'models/multi_search_result_model.dart';
import 'models/paginated_response_model.dart';
import 'models/season_detail_model.dart';
import 'models/tv_detail_model.dart';
import 'models/tv_show_model.dart';

class TmdbRepository {
  TmdbRepository(this._dio);

  final Dio _dio;

  Future<PaginatedResponseModel<MovieModel>> getTrendingMovies({
    String timeWindow = 'day',
    int page = 1,
  }) async {
    final json = await _get(
      '/trending/movie/$timeWindow',
      queryParameters: {'page': page},
    );
    return PaginatedResponseModel<MovieModel>.fromJson(
      json,
      (item) => MovieModel.fromJson(item as Map<String, dynamic>),
    );
  }

  Future<PaginatedResponseModel<TvShowModel>> getTrendingTvShows({
    String timeWindow = 'day',
    int page = 1,
  }) async {
    final json = await _get(
      '/trending/tv/$timeWindow',
      queryParameters: {'page': page},
    );
    return PaginatedResponseModel<TvShowModel>.fromJson(
      json,
      (item) => TvShowModel.fromJson(item as Map<String, dynamic>),
    );
  }

  Future<PaginatedResponseModel<MovieModel>> getPopularMovies({
    int page = 1,
  }) async {
    final json = await _get(
      '/movie/popular',
      queryParameters: {'page': page},
    );
    return PaginatedResponseModel<MovieModel>.fromJson(
      json,
      (item) => MovieModel.fromJson(item as Map<String, dynamic>),
    );
  }

  Future<PaginatedResponseModel<TvShowModel>> getPopularTvShows({
    int page = 1,
  }) async {
    final json = await _get('/tv/popular', queryParameters: {'page': page});
    return PaginatedResponseModel<TvShowModel>.fromJson(
      json,
      (item) => TvShowModel.fromJson(item as Map<String, dynamic>),
    );
  }

  Future<MultiSearchResultModel> searchMulti(
    String query, {
    int page = 1,
  }) async {
    final json = await _get(
      '/search/multi',
      queryParameters: {'query': query, 'page': page},
    );

    final results = (json['results'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();

    final movies = <MovieModel>[];
    final tvShows = <TvShowModel>[];

    for (final item in results) {
      final mediaType = item['media_type'] as String?;
      if (mediaType == 'movie') {
        movies.add(MovieModel.fromJson(item));
      } else if (mediaType == 'tv') {
        tvShows.add(TvShowModel.fromJson(item));
      }
    }

    return MultiSearchResultModel(
      page: json['page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 0,
      totalResults: json['total_results'] as int? ?? 0,
      movies: movies,
      tvShows: tvShows,
    );
  }

  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    final json = await _get('/movie/$movieId');
    return MovieDetailModel.fromJson(json);
  }

  Future<TvDetailModel> getTvDetail(int seriesId) async {
    final json = await _get('/tv/$seriesId');
    return TvDetailModel.fromJson(json);
  }

  Future<SeasonDetailModel> getSeasonDetail(
    int seriesId,
    int seasonNumber,
  ) async {
    final json = await _get('/tv/$seriesId/season/$seasonNumber');
    return SeasonDetailModel.fromJson(json);
  }

  /// Filmin oyuncu kadrosunu (ilk 9 kişi) döner. Detay ekranındaki
  /// "Oyuncular" bölümü için kullanılır.
  Future<List<CastMemberModel>> getMovieCast(int movieId) async {
    final json = await _get('/movie/$movieId/credits');
    return _parseCast(json);
  }

  /// Dizinin oyuncu kadrosunu (ilk 9 kişi) döner.
  Future<List<CastMemberModel>> getTvCast(int seriesId) async {
    final json = await _get('/tv/$seriesId/credits');
    return _parseCast(json);
  }

  /// Filmin fragman videosunun YouTube anahtarını döner. Öncelik sırası:
  /// 1) Uygulamanın güncel dili (örn. Türkçe seçiliyse Türkçe altyazılı/
  ///    dublajlı fragman), 2) o dilde yoksa içeriğin orijinal dili
  ///    ([originalMovieLanguage] ile), 3) o da yoksa TMDB'de neredeyse her
  ///    zaman bulunan İngilizce (en-US) fragmana düşülür.
  Future<String?> getMovieTrailerKey(
    int movieId, {
    String? originalLanguage,
  }) async {
    return _getTrailerKeyWithFallback(
      '/movie/$movieId/videos',
      originalLanguage,
    );
  }

  /// Dizinin fragman videosunun YouTube anahtarını döner (bkz.
  /// [getMovieTrailerKey] için dil önceliği mantığı).
  Future<String?> getTvTrailerKey(
    int seriesId, {
    String? originalLanguage,
  }) async {
    return _getTrailerKeyWithFallback(
      '/tv/$seriesId/videos',
      originalLanguage,
    );
  }

  Future<String?> _getTrailerKeyWithFallback(
    String path,
    String? originalLanguage,
  ) async {
    // 1) Uygulamanın güncel dili (interceptor otomatik ekler).
    final localized = await _get(path);
    final localizedKey = _extractTrailerKey(localized);
    if (localizedKey != null) return localizedKey;

    // 2) İçeriğin orijinal dili (örn. Türkçe bir film için "tr", Korece
    // bir dizi için "ko"...). `include_video_language` ISO-639-1 kodunu
    // bölge eklemeden kabul ettiği için burada güvenilir.
    if (originalLanguage != null && originalLanguage.isNotEmpty) {
      final original = await _get(
        path,
        queryParameters: {
          'language': originalLanguage,
          'include_video_language': '$originalLanguage,null',
        },
      );
      final originalKey = _extractTrailerKey(original);
      if (originalKey != null) return originalKey;
    }

    // 3) Son çare: TMDB'de neredeyse her zaman bulunan İngilizce fragman.
    final fallback = await _get(
      path,
      queryParameters: const {'language': 'en-US'},
    );
    return _extractTrailerKey(fallback);
  }

  List<CastMemberModel> _parseCast(Map<String, dynamic> json) {
    final cast = (json['cast'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    return cast.take(9).map(CastMemberModel.fromJson).toList();
  }

  /// Önce resmi ("official") fragmanı, yoksa herhangi bir fragmanı, o da
  /// yoksa herhangi bir YouTube videosunu tercih eder.
  String? _extractTrailerKey(Map<String, dynamic> json) {
    final videos = (json['results'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>()
        .where((v) => v['site'] == 'YouTube' && v['key'] != null)
        .toList();
    if (videos.isEmpty) return null;

    Map<String, dynamic>? match(bool Function(Map<String, dynamic>) test) {
      for (final video in videos) {
        if (test(video)) return video;
      }
      return null;
    }

    final video =
        match((v) => v['type'] == 'Trailer' && v['official'] == true) ??
        match((v) => v['type'] == 'Trailer') ??
        videos.first;
    return video['key'] as String?;
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return response.data ?? <String, dynamic>{};
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }
}

final tmdbRepositoryProvider = Provider<TmdbRepository>((ref) {
  final dio = ref.watch(tmdbDioProvider);
  return TmdbRepository(dio);
});