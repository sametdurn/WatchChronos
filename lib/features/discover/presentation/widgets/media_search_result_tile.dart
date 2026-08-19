import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/responsive_grid.dart';
import '../../../media/data/models/movie_model.dart';
import '../../../media/data/models/tv_show_model.dart';
import '../../../watch_entries/data/models/media_type.dart';
import '../../../watch_entries/presentation/widgets/add_to_library_button.dart';

/// TMDB `search/multi` sonucundaki film ve dizi kayıtlarını tek bir arayüzde
/// göstermek için kullanılan hafif birleşik model. Kişi (`person`) sonuçları
/// zaten [TmdbRepository.searchMulti] tarafından ayıklandığı için burada
/// sadece film/dizi vardır.
class MediaSearchItem {
  const MediaSearchItem({
    required this.tmdbId,
    required this.mediaType,
    required this.title,
    required this.originalTitle,
    required this.posterPath,
    required this.year,
    required this.isUpcoming,
    required this.voteAverage,
    required this.popularity,
  });

  factory MediaSearchItem.fromMovie(MovieModel movie) {
    return MediaSearchItem(
      tmdbId: movie.id,
      mediaType: MediaType.movie,
      title: movie.title,
      originalTitle: movie.originalTitle,
      posterPath: movie.posterPath,
      year: _yearFrom(movie.releaseDate),
      isUpcoming: _isUpcoming(movie.releaseDate),
      voteAverage: movie.voteAverage,
      popularity: movie.popularity,
    );
  }

  factory MediaSearchItem.fromTvShow(TvShowModel tvShow) {
    return MediaSearchItem(
      tmdbId: tvShow.id,
      mediaType: MediaType.tv,
      title: tvShow.name,
      originalTitle: tvShow.originalName,
      posterPath: tvShow.posterPath,
      year: _yearFrom(tvShow.firstAirDate),
      isUpcoming: _isUpcoming(tvShow.firstAirDate),
      voteAverage: tvShow.voteAverage,
      popularity: tvShow.popularity,
    );
  }

  final int tmdbId;
  final MediaType mediaType;
  final String title;
  final String originalTitle;
  final String? posterPath;
  final String? year;

  /// TMDB'nin verdiği çıkış/ilk yayın tarihi bugünden ileriyse (ya da bugün
  /// ise) `true`. Tarih boş/bilinmiyorsa `false` döner — sadece kesin
  /// bilinen gelecekteki bir tarih için "Yakında" gösterilir.
  final bool isUpcoming;
  final double voteAverage;
  final double popularity;

  static String? _yearFrom(String date) {
    if (date.length < 4) return null;
    return date.substring(0, 4);
  }

  static bool _isUpcoming(String date) {
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return true;
    return !parsed.isBefore(DateTime.now());
  }
}

class MediaSearchResultTile extends StatelessWidget {
  const MediaSearchResultTile({required this.item, super.key});

  final MediaSearchItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final posterUrl = item.posterPath == null
        ? null
        : '${EnvConfig.tmdbImageBaseUrl}w185${item.posterPath}';
    // Geniş (masaüstü) ekranlarda satır aynı sabit küçük boyutta kalıp
    // sağda/altta boşluk bırakmasın diye poster ve buton ölçeklenir.
    final scale = posterScaleFactor(context).clamp(1.0, 1.4);
    final posterWidth = 48 * scale;
    final posterHeight = 72 * scale;
    final buttonSize = 32 * scale;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AddToLibraryButton(
            tmdbId: item.tmdbId,
            mediaType: item.mediaType,
            size: buttonSize,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: posterWidth,
            height: posterHeight,
            child: posterUrl == null
                ? Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.movie_outlined),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: posterUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        [
          item.mediaType == MediaType.movie
              ? context.l10n.t('common_media_type_movie')
              : context.l10n.t('common_media_type_show'),
          if (item.year != null) item.year!,
          if (item.isUpcoming) context.l10n.t('discover_upcoming_label'),
        ].join(' · '),
      ),
      trailing: item.voteAverage > 0
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                const SizedBox(width: 2),
                Text(item.voteAverage.toStringAsFixed(1)),
              ],
            )
          : null,
      onTap: () => context.push(
        AppRoutes.mediaDetail(
          mediaType: item.mediaType.name,
          tmdbId: item.tmdbId,
        ),
      ),
    );
  }
}
