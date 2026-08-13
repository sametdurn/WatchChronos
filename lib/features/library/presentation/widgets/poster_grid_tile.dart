import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/cache/models/cached_media.dart';
import '../../../../core/config/env_config.dart';
import '../../../media/data/media_repository.dart';
import '../../../watch_entries/data/models/media_type.dart';
import '../../../watch_entries/data/models/watch_entry.dart';

typedef _MediaKey = ({int tmdbId, MediaType mediaType});

final _posterMediaProvider = FutureProvider.autoDispose
    .family<CachedMedia, _MediaKey>((ref, key) {
      final repository = ref.watch(mediaRepositoryProvider);
      return repository.getMediaDetail(
        tmdbId: key.tmdbId,
        mediaType: key.mediaType,
      );
    });

/// Sadece kapak (poster) gösteren, tıklanınca detay sayfasını açan sade
/// grid kartı. "Tamamlandı" sekmesinde kullanılır.
class PosterGridTile extends ConsumerWidget {
  const PosterGridTile({required this.entry, this.media, super.key});

  final WatchEntry entry;

  /// Çağıran taraf medya detayını zaten çekmişse (ör. "Filmler" sekmesi)
  /// doğrudan buradan verilir; böylece kart, listede yukarı/aşağı
  /// kaydırılırken ekrana her giriş çıkışında kendi `autoDispose`
  /// provider'ını yeniden tetikleyip aynı veriyi tekrar sorgulamaz. `null`
  /// bırakılırsa (ör. yalnızca [entry] elde olan yerlerde) kart kendi
  /// başına [_posterMediaProvider] ile sorgular.
  final CachedMedia? media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeholderColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    final providedMedia = media;
    final mediaAsync = providedMedia != null
        ? AsyncValue.data(providedMedia)
        : ref.watch(
            _posterMediaProvider((
              tmdbId: entry.tmdbId,
              mediaType: entry.mediaType,
            )),
          );

    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.mediaDetail(
          mediaType: entry.mediaType.name,
          tmdbId: entry.tmdbId,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: mediaAsync.when(
          data: (media) {
            final url = media.posterPath == null
                ? null
                : '${EnvConfig.tmdbImageBaseUrl}w342${media.posterPath}';
            if (url == null) {
              return Container(
                color: placeholderColor,
                child: const Icon(Icons.movie_outlined),
              );
            }
            return CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: placeholderColor),
              errorWidget: (context, url, error) => Container(
                color: placeholderColor,
                child: const Icon(Icons.broken_image_outlined),
              ),
            );
          },
          loading: () => Container(color: placeholderColor),
          error: (_, _) => Container(
            color: placeholderColor,
            child: const Icon(Icons.error_outline),
          ),
        ),
      ),
    );
  }
}

