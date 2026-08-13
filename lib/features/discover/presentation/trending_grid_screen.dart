import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/cache/models/cached_media.dart';
import '../../../core/config/env_config.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/responsive_grid.dart';
import '../../media/data/media_repository.dart';
import '../../media/data/tmdb_providers.dart';
import '../../watch_entries/data/models/media_type.dart';
import '../../watch_entries/presentation/widgets/add_to_library_button.dart';

/// "Gündemdeki Diziler" / "Gündemdeki Filmler" başlığına dokununca açılan
/// tam liste. Aşağı doğru kayan, PC'de 2 / mobilde 1 sütunlu bir grid;
/// her kart yatay (16:9) bir kapak fotoğrafı, altında ad + süre/tür bilgisi
/// ve sağ üstte kütüphaneye ekleme butonu içerir.
class TrendingGridScreen extends ConsumerWidget {
  const TrendingGridScreen({required this.mediaType, super.key});

  final MediaType mediaType;

  static String routeFor(MediaType mediaType) =>
      AppRoutes.trendingGrid(mediaType: mediaType.name);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = mediaType == MediaType.tv
        ? context.l10n.t('discover_trending_shows')
        : context.l10n.t('discover_trending_movies');

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: mediaType == MediaType.tv
          ? ref
                .watch(trendingTvShowsProvider(1))
                .when(
                  data: (response) => _Grid(
                    mediaType: mediaType,
                    items: response.results
                        .map(
                          (tv) => (
                            tmdbId: tv.id,
                            posterPath: tv.posterPath,
                            backdropPath: tv.backdropPath,
                            title: tv.name,
                          ),
                        )
                        .toList(),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) => Center(
                    child: Text(context.l10n.t('common_load_failed_retry')),
                  ),
                )
          : ref
                .watch(trendingMoviesProvider(1))
                .when(
                  data: (response) => _Grid(
                    mediaType: mediaType,
                    items: response.results
                        .map(
                          (movie) => (
                            tmdbId: movie.id,
                            posterPath: movie.posterPath,
                            backdropPath: movie.backdropPath,
                            title: movie.title,
                          ),
                        )
                        .toList(),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) => Center(
                    child: Text(context.l10n.t('common_load_failed_retry')),
                  ),
                ),
    );
  }
}

typedef _GridItem = ({
  int tmdbId,
  String? posterPath,
  String? backdropPath,
  String title,
});

class _Grid extends StatelessWidget {
  const _Grid({required this.mediaType, required this.items});

  final MediaType mediaType;
  final List<_GridItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(context.l10n.t('discover_no_content')),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: responsivePosterExtent(context, base: 340),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _TrendingDetailCard(
          tmdbId: item.tmdbId,
          mediaType: mediaType,
          posterPath: item.posterPath,
          backdropPath: item.backdropPath,
          title: item.title,
        );
      },
    );
  }
}

typedef _MediaKey = ({int tmdbId, MediaType mediaType});

final _gridMediaDetailProvider = FutureProvider.autoDispose
    .family<CachedMedia, _MediaKey>((ref, key) {
      final repository = ref.watch(mediaRepositoryProvider);
      return repository.getMediaDetail(
        tmdbId: key.tmdbId,
        mediaType: key.mediaType,
      );
    });

/// Üstte yatay (16:9) kapak fotoğrafı, altında ad ve süre/tür bilgisi olan
/// kart. Süre/tür bilgisi TMDB detay çağrısını gerektirdiği için (liste
/// uç noktaları bunu döndürmez) kart görünür olduğunda arka planda ayrıca
/// yüklenir; MediaRepository zaten bunu önbelleğe alır.
class _TrendingDetailCard extends ConsumerWidget {
  const _TrendingDetailCard({
    required this.tmdbId,
    required this.mediaType,
    required this.posterPath,
    required this.backdropPath,
    required this.title,
  });

  final int tmdbId;
  final MediaType mediaType;
  final String? posterPath;
  final String? backdropPath;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final placeholderColor = theme.colorScheme.surfaceContainerHighest;
    final imagePath = backdropPath ?? posterPath;
    final imageUrl = imagePath == null
        ? null
        : '${EnvConfig.tmdbImageBaseUrl}w500$imagePath';
    final mediaAsync = ref.watch(
      _gridMediaDetailProvider((tmdbId: tmdbId, mediaType: mediaType)),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
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
                  imageUrl == null
                      ? Container(
                          color: placeholderColor,
                          child: const Icon(Icons.movie_outlined),
                        )
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: placeholderColor),
                          errorWidget: (context, url, error) => Container(
                            color: placeholderColor,
                            child: const Icon(Icons.broken_image_outlined),
                          ),
                        ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: AddToLibraryButton(
                      tmdbId: tmdbId,
                      mediaType: mediaType,
                      size: 34,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  mediaAsync.when(
                    data: (media) => Text(
                      _subtitleFor(context, media, mediaType),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    loading: () => Text(
                      context.l10n.t('common_loading_ellipsis'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _subtitleFor(
  BuildContext context,
  CachedMedia media,
  MediaType mediaType,
) {
  final l10n = context.l10n;
  final parts = <String>[];
  if (mediaType == MediaType.movie) {
    if (media.runtimeMinutes != null && media.runtimeMinutes! > 0) {
      parts.add(l10n.tp('common_minutes_short', {
        'count': '${media.runtimeMinutes}',
      }));
    }
  } else {
    if (media.numberOfSeasons != null && media.numberOfSeasons! > 0) {
      final s = media.numberOfSeasons;
      parts.add(
        s == 1
            ? l10n.t('common_one_season')
            : l10n.tp('common_n_seasons', {'count': '$s'}),
      );
    }
  }
  if (media.genres.isNotEmpty) {
    parts.add(media.genres.take(3).join(', '));
  }
  return parts.isEmpty ? '—' : parts.join(' • ');
}
