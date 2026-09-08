import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cache/models/cached_media.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/responsive_grid.dart';
import '../../media/data/media_repository.dart';
import '../../media/domain/tv_entry_classification.dart';
import '../../media/domain/tv_watch_progress.dart';
import '../../watch_entries/data/models/media_type.dart';
import '../../watch_entries/data/models/watch_entry.dart';
import '../../watch_entries/data/models/watch_status.dart';
import '../../watch_entries/data/watch_entries_repository.dart';
import 'widgets/poster_grid_tile.dart';

/// "Tamamlandı" sekmesindeki "Tamamlanan Diziler" / "Tamamlanan Filmler"
/// başlığına dokununca açılan, sadece o türü gösteren tam grid sayfası.
class CompletedGridScreen extends StatelessWidget {
  const CompletedGridScreen({required this.mediaType, super.key});

  final MediaType mediaType;

  @override
  Widget build(BuildContext context) {
    final title = mediaType == MediaType.tv
        ? context.l10n.t('library_completed_shows_title')
        : context.l10n.t('library_completed_movies_title');

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: mediaType == MediaType.tv
          ? const _CompletedTvGrid()
          : const _CompletedMoviesGrid(),
    );
  }
}

Widget _buildGrid(BuildContext context, List<WatchEntry> entries) {
  if (entries.isEmpty) {
    return Center(child: Text(context.l10n.t('library_no_completed')));
  }
  return GridView.builder(
    padding: const EdgeInsets.all(12),
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: responsivePosterExtent(context),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2 / 3,
    ),
    itemCount: entries.length,
    itemBuilder: (context, index) => PosterGridTile(entry: entries[index]),
  );
}

class _CompletedMoviesGrid extends ConsumerWidget {
  const _CompletedMoviesGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(libraryEntriesStreamProvider);
    if (entriesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (entriesAsync.hasError) {
      return Center(child: Text(context.l10n.t('common_load_failed_retry')));
    }
    final entries =
        [
            ...(entriesAsync.asData?.value ?? const <WatchEntry>[]).where(
              (e) =>
                  e.mediaType == MediaType.movie &&
                  e.status == WatchStatus.completed,
            ),
          ]
          ..sort(_byMostRecentlyFinished);
    return _buildGrid(context, entries);
  }
}

/// Tamamlanan dizi/film girdilerini en son bitirilen en üstte olacak
/// şekilde sıralar (bkz. library_screen.dart'taki aynı isimli fonksiyon).
int _byMostRecentlyFinished(WatchEntry a, WatchEntry b) {
  final aDate = a.finishedAt ?? a.updatedAt;
  final bDate = b.finishedAt ?? b.updatedAt;
  return bDate.compareTo(aDate);
}

typedef _TvContext = ({
  WatchEntry entry,
  CachedMedia media,
  int watchedCount,
  bool reachedEndOfAiredEpisodes,
});

class _CompletedTvGrid extends ConsumerWidget {
  const _CompletedTvGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(watchEntriesRepositoryProvider);
    final mediaRepository = ref.watch(mediaRepositoryProvider);
    final entriesAsync = ref.watch(libraryEntriesStreamProvider);

    if (entriesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (entriesAsync.hasError) {
      return Center(child: Text(context.l10n.t('common_load_failed_retry')));
    }

    const tvStatuses = {
      WatchStatus.planned,
      WatchStatus.watching,
      WatchStatus.completed,
    };
    final entries = (entriesAsync.asData?.value ?? const <WatchEntry>[])
        .where((e) => e.mediaType == MediaType.tv && tvStatuses.contains(e.status))
        .toList();
    if (entries.isEmpty) {
      return Center(child: Text(context.l10n.t('library_no_completed')));
    }

    {
      // NOT: Önceden burada her dizi için ayrı ayrı
      // `watchedEpisodesTotalCount` çağrılıyordu (N dizi = N ayrı Supabase
      // sorgusu). `watchedEpisodesTotalCounts` (bkz. WatchEntriesRepository)
      // tam da bunun için var: library_screen.dart'taki `_loadTvContext`
      // bu toplu sorguyu zaten kullanıyor, burası unutulmuştu. Tek bir
      // `IN (...)` sorgusuyla tüm sayımlar önceden çekilip bellekte
      // eşleştiriliyor.
      return FutureBuilder<List<_TvContext>>(
          future: () async {
            final countsFuture = repository.watchedEpisodesTotalCounts(
              watchEntryIds: entries.map((e) => e.id).toList(),
            );
            final mediaListFuture = Future.wait(
              entries.map(
                (entry) => mediaRepository.getMediaDetail(
                  tmdbId: entry.tmdbId,
                  mediaType: MediaType.tv,
                ),
              ),
            );
            final counts = await countsFuture;
            final mediaList = await mediaListFuture;

            final reachedEndFlags = await Future.wait([
              for (var i = 0; i < entries.length; i++)
                hasReachedEndOfAiredTvEpisodes(
                  tmdbId: entries[i].tmdbId,
                  currentSeason: entries[i].currentSeason,
                  currentEpisode: entries[i].currentEpisode,
                  numberOfSeasons: mediaList[i].numberOfSeasons,
                  mediaRepository: mediaRepository,
                ),
            ]);

            return [
              for (var i = 0; i < entries.length; i++)
                (
                  entry: entries[i],
                  media: mediaList[i],
                  watchedCount: counts[entries[i].id] ?? 0,
                  reachedEndOfAiredEpisodes: reachedEndFlags[i],
                ),
            ];
          }(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Text(context.l10n.t('common_load_failed_retry')),
              );
            }

            final finished = snapshot.data!
                .where(
                  (tv) =>
                      classifyTvEntry(
                        media: tv.media,
                        entry: tv.entry,
                        watchedEpisodesCount: tv.watchedCount,
                        reachedEndOfAiredEpisodes: tv.reachedEndOfAiredEpisodes,
                      ) ==
                      TvLibrarySection.completed,
                )
                .map((tv) => tv.entry)
                .toList()
              ..sort(_byMostRecentlyFinished);

            return _buildGrid(context, finished);
          },
        );
    }
  }
}
