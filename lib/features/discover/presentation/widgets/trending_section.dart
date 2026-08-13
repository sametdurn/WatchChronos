import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/utils/responsive_grid.dart';
import '../../../media/data/tmdb_providers.dart';
import '../../../watch_entries/data/models/media_type.dart';
import '../../../watch_entries/presentation/widgets/add_to_library_button.dart';
import '../trending_grid_screen.dart';

/// Keşfet ekranında arama kutusu boşken gösterilen "Gündemdeki Diziler" /
/// "Gündemdeki Filmler" bölümü: başlık + yana kayan poster listesi (en
/// fazla 10 öğe). Başlığa dokununca tam grid sayfası açılır. Veri, zaten
/// var olan `trendingMoviesProvider(page)` / `trendingTvShowsProvider(page)`
/// (bkz. tmdb_providers.dart) üzerinden alınır; ilk sayfa (~20 kayıt)
/// hem yatay listeye hem de grid sayfasına yeter.
class TrendingSection extends ConsumerWidget {
  const TrendingSection({
    required this.title,
    required this.mediaType,
    super.key,
  });

  final String title;
  final MediaType mediaType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (mediaType == MediaType.tv) {
      final asyncTv = ref.watch(trendingTvShowsProvider(1));
      return asyncTv.when(
        data: (response) => _SectionBody(
          title: title,
          mediaType: mediaType,
          items: response.results
              .map(
                (tv) => (
                  tmdbId: tv.id,
                  posterPath: tv.posterPath,
                  title: tv.name,
                ),
              )
              .toList(),
        ),
        loading: () => _SectionLoading(title: title),
        error: (_, _) => const SizedBox.shrink(),
      );
    }

    final asyncMovies = ref.watch(trendingMoviesProvider(1));
    return asyncMovies.when(
      data: (response) => _SectionBody(
        title: title,
        mediaType: mediaType,
        items: response.results
            .map(
              (movie) => (
                tmdbId: movie.id,
                posterPath: movie.posterPath,
                title: movie.title,
              ),
            )
            .toList(),
      ),
      loading: () => _SectionLoading(title: title),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

typedef _TrendingItem = ({int tmdbId, String? posterPath, String title});

class _SectionLoading extends StatelessWidget {
  const _SectionLoading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          const Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}

class _SectionBody extends StatelessWidget {
  const _SectionBody({
    required this.title,
    required this.mediaType,
    required this.items,
  });

  final String title;
  final MediaType mediaType;
  final List<_TrendingItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (items.isEmpty) return const SizedBox.shrink();
    final topTen = items.take(10).toList();
    // Geniş ekranlarda (PC) yatay şerit sabit küçük boyutta kalıp altında
    // boşluk bırakmasın diye poster genişliği/yüksekliği ölçeklenir.
    final scale = posterStripScaleFactor(context);
    final tileWidth = 110 * scale;
    final sectionHeight = 190 * scale;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.push(TrendingGridScreen.routeFor(mediaType)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title, style: theme.textTheme.titleMedium),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
          SizedBox(
            height: sectionHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: topTen.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final item = topTen[index];
                return _TrendingPosterTile(
                  tmdbId: item.tmdbId,
                  mediaType: mediaType,
                  posterPath: item.posterPath,
                  title: item.title,
                  width: tileWidth,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendingPosterTile extends StatelessWidget {
  const _TrendingPosterTile({
    required this.tmdbId,
    required this.mediaType,
    required this.posterPath,
    required this.title,
    required this.width,
  });

  final int tmdbId;
  final MediaType mediaType;
  final String? posterPath;
  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final placeholderColor = theme.colorScheme.surfaceContainerHighest;
    final posterUrl = posterPath == null
        ? null
        : '${EnvConfig.tmdbImageBaseUrl}w185$posterPath';

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () => context.push(
          AppRoutes.mediaDetail(mediaType: mediaType.name, tmdbId: tmdbId),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: posterUrl == null
                        ? Container(
                            color: placeholderColor,
                            child: const Icon(Icons.movie_outlined),
                          )
                        : CachedNetworkImage(
                            imageUrl: posterUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) =>
                                Container(color: placeholderColor),
                            errorWidget: (context, url, error) => Container(
                              color: placeholderColor,
                              child: const Icon(Icons.broken_image_outlined),
                            ),
                          ),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: AddToLibraryButton(
                      tmdbId: tmdbId,
                      mediaType: mediaType,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}