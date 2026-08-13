import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/responsive_grid.dart';
import '../../watch_entries/data/models/media_type.dart';
import '../../watch_entries/data/models/watch_entry.dart';
import '../../watch_entries/data/watch_entries_repository.dart';
import 'widgets/poster_grid_tile.dart';

/// "Favoriler" sekmesindeki "Favori Diziler" / "Favori Filmler" başlığına
/// dokununca açılan, sadece o türü gösteren tam grid sayfası.
///
/// [CompletedGridScreen] ile aynı görsel dile sahiptir; favoriler izleme
/// durumundan bağımsız olduğu için (tamamlanmış/izleniyor fark etmez) ek
/// bir TMDB sınıflandırma adımına ihtiyaç yoktur — `is_favorite` alanına
/// göre filtrelenmiş `watchEntries` stream'i yeterlidir.
class FavoritesGridScreen extends ConsumerWidget {
  const FavoritesGridScreen({required this.mediaType, super.key});

  final MediaType mediaType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = mediaType == MediaType.tv
        ? context.l10n.t('library_favorite_shows_title')
        : context.l10n.t('library_favorite_movies_title');
    final entriesAsync = ref.watch(libraryEntriesStreamProvider);

    Widget body;
    if (entriesAsync.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (entriesAsync.hasError) {
      body = Center(child: Text(context.l10n.t('common_load_failed_retry')));
    } else {
      final entries = (entriesAsync.asData?.value ?? const <WatchEntry>[])
          .where((e) => e.isFavorite && e.mediaType == mediaType)
          .toList()
        ..sort(_byMostRecentlyFavorited);

      if (entries.isEmpty) {
        body = Center(child: Text(context.l10n.t('library_no_favorites')));
      } else {
        body = GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: responsivePosterExtent(context),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2 / 3,
          ),
          itemCount: entries.length,
          itemBuilder: (context, index) =>
              PosterGridTile(entry: entries[index]),
        );
      }
    }

    return Scaffold(appBar: AppBar(title: Text(title)), body: body);
  }
}

/// Favori dizi/film girdilerini en son favorilenen en üstte olacak şekilde
/// sıralar. `favoritedAt`, `is_favorite` false'tan true'ya geçtiğinde bir DB
/// trigger'ı tarafından otomatik set edilir (bkz.
/// 20260805120000_watch_entries_favorited_at.sql migration'ı) ve favori
/// KALDIĞI sürece başka bir alan değişse bile SABİT kalır — bu yüzden
/// `updatedAt` burada kullanılamaz (o, favori dışı her değişiklikte de
/// güncellenir ve sıralamayı yanlış yapar). Migration öncesi favorilenmiş
/// eski kayıtlar migration sırasında `updatedAt`'e yaklaşık dolduruldu; yine
/// de hiç dolmamış olma ihtimaline karşı burada da `updatedAt`'e düşülüyor.
int _byMostRecentlyFavorited(WatchEntry a, WatchEntry b) {
  final aDate = a.favoritedAt ?? a.updatedAt;
  final bDate = b.favoritedAt ?? b.updatedAt;
  return bDate.compareTo(aDate);
}
