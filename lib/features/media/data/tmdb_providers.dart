import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/movie_model.dart';
import 'models/paginated_response_model.dart';
import 'models/tv_show_model.dart';
import 'tmdb_repository.dart';

/// Trend listeleri bu süre boyunca sağlayıcıda (provider) canlı tutulur;
/// ekrandan çıkıp geri dönmek (Discover sekmesi vb.) TMDB'ye tekrar istek
/// atmaz. Süre dolunca bir sonraki dinleyicide otomatik yenilenir. Elle
/// "aşağı çekip yenile" (bkz. discover_screen.dart) bunu beklemeden
/// `ref.invalidate` ile anında tetikleyebilir.
const _trendingCacheTtl = Duration(minutes: 30);

final trendingMoviesProvider =
    FutureProvider.family<PaginatedResponseModel<MovieModel>, int>((
      ref,
      page,
    ) {
      final repository = ref.watch(tmdbRepositoryProvider);
      final ttlTimer = Timer(_trendingCacheTtl, ref.invalidateSelf);
      ref.onDispose(ttlTimer.cancel);
      return repository.getTrendingMovies(page: page);
    });

final trendingTvShowsProvider =
    FutureProvider.family<PaginatedResponseModel<TvShowModel>, int>((
      ref,
      page,
    ) {
      final repository = ref.watch(tmdbRepositoryProvider);
      final ttlTimer = Timer(_trendingCacheTtl, ref.invalidateSelf);
      ref.onDispose(ttlTimer.cancel);
      return repository.getTrendingTvShows(page: page);
    });
