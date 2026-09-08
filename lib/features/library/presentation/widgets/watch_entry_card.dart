import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/cache/models/cached_media.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../episodes/utils/next_episode_calculator.dart';
import '../../../media/data/media_repository.dart';
import '../../../media/domain/aired_episodes.dart';
import '../../../media/domain/tv_entry_classification.dart';
import '../../../media/domain/tv_show_lifecycle.dart';
import '../../../media/domain/tv_watch_progress.dart';
import '../../../watch_entries/data/models/media_type.dart';
import '../../../watch_entries/data/models/watch_entry.dart';
import '../../../watch_entries/data/models/watch_status.dart';
import '../../../watch_entries/data/watch_entries_repository.dart';

typedef _MediaKey = ({int tmdbId, MediaType mediaType});

final _watchEntryMediaProvider = FutureProvider.autoDispose
    .family<CachedMedia, _MediaKey>((ref, key) {
      final repository = ref.watch(mediaRepositoryProvider);
      return repository.getMediaDetail(
        tmdbId: key.tmdbId,
        mediaType: key.mediaType,
      );
    });

/// Bir TV [WatchEntry]'nin izlenmiş toplam bölüm sayısı. Rozet ve "sıradaki
/// bölüm" satırının hangi [TvLibrarySection]'a ait olduğunu doğru
/// hesaplayabilmek için (sadece TMDB `status`'üne değil, kullanıcının kaç
/// bölüm izlediğine de bakılması gerekir) kullanılır.
final _watchedEpisodesCountProvider = FutureProvider.autoDispose
    .family<int, String>((ref, watchEntryId) {
      final repository = ref.watch(watchEntriesRepositoryProvider);
      return repository.watchedEpisodesTotalCount(watchEntryId: watchEntryId);
    });

String? _posterUrl(String? posterPath) {
  if (posterPath == null || posterPath.isEmpty) return null;
  return '${EnvConfig.tmdbImageBaseUrl}w185$posterPath';
}

/// Kütüphane listelerinde her satırda gösterilen kart. [WatchEntry] sadece
/// `tmdbId`/`mediaType` taşıdığından, poster + başlık + yıl bilgisi
/// `MediaRepository` üzerinden ayrıca çekilir (cache-first).
///
/// Kart düzeni: [poster] | [başlık/sezon-bölüm veya yıl/rozet bilgisi
/// (Expanded)] | varsa "sıradaki bölümü izledim" aksiyonu, kartın en
/// sağında ve kartın tam yüksekliğine göre dikeyde ortalanmış şekilde
/// (bkz. [_TrailingAction]). Dizilerde yıl yerine güncel sezon/bölüm kalın
/// olarak gösterilir. Bir bölüm izlendi işaretlendiğinde tüm kart sağa
/// doğru kayarak kaybolur, sıradaki bölümü gösteren kart soldan içeri
/// kayar (bkz. build() içindeki [AnimatedSwitcher]).
class WatchEntryCard extends ConsumerWidget {
  const WatchEntryCard({required this.entry, this.watchedCount, super.key});

  final WatchEntry entry;

  /// Dizinin toplam izlenen bölüm sayısı, çağıran taraf (ör. kütüphane
  /// sekmesi) bunu zaten sınıflandırma için hesaplamışsa buradan verilir.
  /// `null` bırakılırsa kart kendi başına [_watchedEpisodesCountProvider]
  /// ile ayrıca sorgular (ör. tek bir kartın bağımsız kullanıldığı yerler).
  /// Bu sayede aynı bilgi hem liste ekranında hem her kartta ayrı ayrı
  /// sorgulanıp N+1 sorguya yol açmaz.
  final int? watchedCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaAsync = ref.watch(
      _watchEntryMediaProvider((
        tmdbId: entry.tmdbId,
        mediaType: entry.mediaType,
      )),
    );

    // Bir bölüm izlendi olarak işaretlendiğinde `entry.currentSeason`/
    // `currentEpisode` değişir (bkz. _NextEpisodeAction._markWatched); bu
    // anahtar değiştiğinde AnimatedSwitcher eski kartı sağa doğru kaydırıp
    // kaybederken yeni (sıradaki bölümü gösteren) kartı soldan kaydırarak
    // içeri alır. Böylece animasyon tek bir metin yerine kartın tamamında
    // gerçekleşir.
    final cardKey = ValueKey('${entry.currentSeason}_${entry.currentEpisode}');

    return ClipRect(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final isIncoming = child.key == cardKey;
          final offsetTween = isIncoming
              ? Tween<Offset>(begin: const Offset(-0.25, 0), end: Offset.zero)
              : Tween<Offset>(begin: Offset.zero, end: const Offset(0.25, 0));
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: offsetTween.animate(animation),
              child: child,
            ),
          );
        },
        child: _buildCard(context, ref, theme, mediaAsync, cardKey),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    AsyncValue<CachedMedia> mediaAsync,
    Key cardKey,
  ) {
    return Card(
      key: cardKey,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () => context.push(
          AppRoutes.mediaDetail(
            mediaType: entry.mediaType.name,
            tmdbId: entry.tmdbId,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Poster(mediaAsync: mediaAsync),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    mediaAsync.when(
                      data: (media) => Text(
                        media.title,
                        style: theme.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      loading: () => Container(
                        height: 16,
                        width: 140,
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      error: (_, _) => Text(
                        'tmdbId: ${entry.tmdbId}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 4),
                    entry.mediaType == MediaType.tv
                        ? mediaAsync.when(
                            data: (media) =>
                                _SeasonEpisodeLabel(entry: entry, media: media),
                            loading: () => Text(
                              'S${entry.currentSeason ?? 1} • '
                              'B${entry.currentEpisode ?? 1}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            error: (_, _) => Text(
                              'S${entry.currentSeason ?? 1} • '
                              'B${entry.currentEpisode ?? 1}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : mediaAsync.when(
                            data: (media) {
                              final date =
                                  media.releaseDate ?? media.firstAirDate;
                              return Text(
                                date == null ? '—' : '${date.year}',
                                style: theme.textTheme.bodyMedium,
                              );
                            },
                            loading: () => const SizedBox.shrink(),
                            error: (_, _) => const SizedBox.shrink(),
                          ),
                    const SizedBox(height: 6),
                    if (entry.mediaType == MediaType.tv)
                      mediaAsync.when(
                        data: (media) {
                          if (watchedCount != null) {
                            return _TvBadge(
                              entry: entry,
                              media: media,
                              watchedCount: watchedCount!,
                            );
                          }
                          final watchedCountAsync = ref.watch(
                            _watchedEpisodesCountProvider(entry.id),
                          );
                          return watchedCountAsync.when(
                            data: (count) => _TvBadge(
                              entry: entry,
                              media: media,
                              watchedCount: count,
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (_, _) => const SizedBox.shrink(),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                    if (entry.isFavorite)
                      const Icon(Icons.favorite, size: 18, color: Colors.red),
                  ],
                ),
              ),
              _TrailingAction(
                entry: entry,
                mediaAsync: mediaAsync,
                watchedCount: watchedCount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `entry.currentSeason`/`entry.currentEpisode` DB'de "en son izlenen
/// bölüm"ü tutar (bkz. `sync_current_episode` trigger'ı), "sıradaki
/// izlenecek bölüm"ü DEĞİL. Bir sezonun son bölümü izlendiğinde bu ikisi
/// farklılaşır: ör. 10 bölümlük 1. sezon bitince DB'de hâlâ "S1 • B10"
/// yazar, oysa kullanıcıya "S2 • B1" gösterilmesi gerekir. Bu widget,
/// [_NextEpisodeAction] ile aynı [_nextEpisodeProvider] hesaplamasını
/// kullanarak doğru olanı gösterir; bu provider zaten önbelleğe
/// alındığından (aynı tvId/sezon/bölüm ile) ekstra bir ağ isteğine yol
/// açmaz.
class _SeasonEpisodeLabel extends ConsumerWidget {
  const _SeasonEpisodeLabel({required this.entry, required this.media});

  final WatchEntry entry;
  final CachedMedia media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold);

    final currentSeason = entry.currentSeason;
    final currentEpisode = entry.currentEpisode;
    if (currentSeason == null || currentEpisode == null) {
      return Text('S1 • B1', style: style);
    }

    final nextAsync = ref.watch(
      _nextEpisodeProvider((
        tvId: entry.tmdbId,
        currentSeason: currentSeason,
        currentEpisode: currentEpisode,
        totalSeasons: media.numberOfSeasons,
      )),
    );

    return nextAsync.when(
      data: (next) {
        // `next == null` -> dizinin tüm (yayınlanmış) bölümleri izlenmiş;
        // gösterilecek "sıradaki" bölüm yok, en son izlenen bölüm gösterilir.
        final displaySeason = next?.season ?? currentSeason;
        final displayEpisode = next?.episode ?? currentEpisode;
        return Text('S$displaySeason • B$displayEpisode', style: style);
      },
      loading: () => Text('S$currentSeason • B$currentEpisode', style: style),
      error: (_, _) => Text('S$currentSeason • B$currentEpisode', style: style),
    );
  }
}

/// Sadece TMDB durumu rozetini (ör. "Devamı Gelecek", "Final Yaptı")
/// gösterir. Sadece TMDB `status`'üne değil, kullanıcının kaç bölüm
/// izlediğine de bakar:
/// - [TvLibrarySection.notStarted] / [TvLibrarySection.watching]: dizi
///   final yapmış/iptal edilmiş olsa bile hâlâ izlenecek bölüm olduğu için
///   rozet GÖSTERİLMEZ.
/// - [TvLibrarySection.upcoming]: kullanıcı mevcut bölümleri bitirmiş ama
///   dizi devam ediyor; "Devamı Gelecek" rozeti gösterilir.
/// - [TvLibrarySection.completed]: final yapmış/iptal edilmiş VE tüm
///   bölümler izlenmiş; TMDB durumu rozet olarak gösterilir.
class _TvBadge extends ConsumerWidget {
  const _TvBadge({
    required this.entry,
    required this.media,
    required this.watchedCount,
  });

  final WatchEntry entry;
  final CachedMedia media;
  final int watchedCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reachedEndAsync = ref.watch(
      _reachedEndOfAiredEpisodesProvider((
        tvId: entry.tmdbId,
        currentSeason: entry.currentSeason,
        currentEpisode: entry.currentEpisode,
        numberOfSeasons: media.numberOfSeasons,
      )),
    );

    // Bilgi yüklenene kadar (ya da hata durumunda) eski/yedek davranışa
    // (yalnızca toplam bölüm sayısı karşılaştırması) düşülür; bu sadece
    // kısa bir an için yanlış rozet göstermemek amacıyla var, sonuç
    // geldiğinde build tekrar tetiklenip doğru rozete geçilir.
    final reachedEnd = reachedEndAsync.asData?.value ?? false;
    return _buildBadge(context, reachedEnd);
  }

  Widget _buildBadge(BuildContext context, bool reachedEndOfAiredEpisodes) {
    final theme = Theme.of(context);
    final section = classifyTvEntry(
      media: media,
      entry: entry,
      watchedEpisodesCount: watchedCount,
      reachedEndOfAiredEpisodes: reachedEndOfAiredEpisodes,
    );

    String? badgeLabel;
    Color? badgeColor;
    switch (section) {
      case TvLibrarySection.upcoming:
        badgeLabel = context.l10n.t('watch_entry_card_upcoming_badge');
        badgeColor = theme.colorScheme.primaryContainer;
        break;
      case TvLibrarySection.completed:
        final lifecycle = parseTvShowLifecycle(media.status);
        badgeLabel = lifecycle == TvShowLifecycle.unknown
            ? null
            : context.l10n.t(lifecycle.labelKey);
        badgeColor = theme.colorScheme.surfaceContainerHighest;
        break;
      case TvLibrarySection.notStarted:
      case TvLibrarySection.watching:
        badgeLabel = null;
        break;
    }

    if (badgeLabel == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Chip(
        label: Text(badgeLabel),
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        backgroundColor: badgeColor,
      ),
    );
  }
}

/// Kartın en sağında, kartın tam yüksekliğine göre dikeyde ortalanmış
/// "sıradaki bölümü izledim" aksiyonu. Sadece izlenecek bölümü olan
/// (henüz bitmemiş) diziler için gösterilir; film veya rozet gerektiren
/// (tamamlanmış/devamı gelecek) durumlarda hiçbir şey render etmez.
class _TrailingAction extends ConsumerWidget {
  const _TrailingAction({
    required this.entry,
    required this.mediaAsync,
    this.watchedCount,
  });

  final WatchEntry entry;
  final AsyncValue<CachedMedia> mediaAsync;
  final int? watchedCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (entry.mediaType != MediaType.tv) return const SizedBox.shrink();
    if (entry.status != WatchStatus.planned &&
        entry.status != WatchStatus.watching) {
      return const SizedBox.shrink();
    }

    return mediaAsync.when(
      data: (media) {
        if (watchedCount != null) {
          return _buildForCount(ref, media, watchedCount!);
        }
        final watchedCountAsync = ref.watch(
          _watchedEpisodesCountProvider(entry.id),
        );
        return watchedCountAsync.when(
          data: (count) => _buildForCount(ref, media, count),
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildForCount(WidgetRef ref, CachedMedia media, int count) {
    final reachedEndAsync = ref.watch(
      _reachedEndOfAiredEpisodesProvider((
        tvId: entry.tmdbId,
        currentSeason: entry.currentSeason,
        currentEpisode: entry.currentEpisode,
        numberOfSeasons: media.numberOfSeasons,
      )),
    );
    final reachedEnd = reachedEndAsync.asData?.value ?? false;
    final section = classifyTvEntry(
      media: media,
      entry: entry,
      watchedEpisodesCount: count,
      reachedEndOfAiredEpisodes: reachedEnd,
    );
    final show =
        section == TvLibrarySection.notStarted ||
        section == TvLibrarySection.watching;
    if (!show) return const SizedBox.shrink();
    return _NextEpisodeAction(entry: entry, media: media);
  }
}

typedef _NextEpisodeKey = ({
  int tvId,
  int currentSeason,
  int currentEpisode,
  int? totalSeasons,
});

/// [_SeasonEpisodeLabel] ve [_NextEpisodeAction] TARAFINDAN paylaşılan tek
/// "sıradaki bölüm" hesaplaması. Mevcut sezonun *yayınlanmış* bölüm sayısını
/// kullanır (bkz. `airedEpisodeCount`) ve sıradaki sezona geçmeden önce o
/// sezonun gerçekten yayınlanıp yayınlanmadığını kontrol eder — TMDB,
/// onaylanan bir sonraki sezonu bölümler çıkmadan önce sezon nesnesi olarak
/// ekleyebildiğinden (bkz. `next_episode_calculator.dart`), sadece sezon
/// sayısına bakmak henüz çıkmamış bir bölümü "sıradaki" gibi gösterebilir.
final _nextEpisodeProvider = FutureProvider.autoDispose
    .family<({int season, int episode})?, _NextEpisodeKey>((ref, key) async {
      final repository = ref.watch(mediaRepositoryProvider);
      final currentSeasonDetail = await repository.getSeasonDetail(
        tvId: key.tvId,
        seasonNumber: key.currentSeason,
      );
      final airedInCurrent = airedEpisodeCount(currentSeasonDetail);
      final totalSeasons = key.totalSeasons ?? key.currentSeason;

      int? airedInNext;
      if (key.currentEpisode >= airedInCurrent &&
          key.currentSeason < totalSeasons) {
        try {
          final nextSeasonDetail = await repository.getSeasonDetail(
            tvId: key.tvId,
            seasonNumber: key.currentSeason + 1,
          );
          airedInNext = airedEpisodeCount(nextSeasonDetail);
        } catch (_) {
          airedInNext = null;
        }
      }

      return computeNextEpisode(
        currentSeason: key.currentSeason,
        currentEpisode: key.currentEpisode,
        episodesInCurrentSeason: airedInCurrent,
        totalSeasons: totalSeasons,
        episodesAiredInNextSeason: airedInNext,
      );
    });

typedef _ReachedEndKey = ({
  int tvId,
  int? currentSeason,
  int? currentEpisode,
  int? numberOfSeasons,
});

/// [_TvBadge] ve [_TrailingAction] TARAFINDAN paylaşılan, kullanıcının
/// dizinin fiilen yayınlanmış tüm bölümlerini izleyip izlemediği bilgisi
/// (bkz. `hasReachedEndOfAiredTvEpisodes`).
final _reachedEndOfAiredEpisodesProvider = FutureProvider.autoDispose
    .family<bool, _ReachedEndKey>((ref, key) {
      final repository = ref.watch(mediaRepositoryProvider);
      return hasReachedEndOfAiredTvEpisodes(
        tmdbId: key.tvId,
        currentSeason: key.currentSeason,
        currentEpisode: key.currentEpisode,
        numberOfSeasons: key.numberOfSeasons,
        mediaRepository: repository,
      );
    });

/// "İzliyorum" listesinde dizinin sıradaki bölümünü gösterir ve tek
/// dokunuşla o bölümü izlendi olarak işaretler. Henüz hiç bölüm
/// izlenmemişse doğrudan 1. sezon 1. bölüm gösterilir. Bir bölüm
/// işaretlendiğinde `sync_current_episode` DB trigger'ı
/// `watch_entries.current_season/current_episode` alanlarını günceller;
/// bu widget o güncellenmiş [WatchEntry] ile yeniden oluşturulduğunda
/// otomatik olarak bir sonraki bölümü hesaplayıp gösterir.
///
/// Bölüm etiketi sabit metin olarak gösterilir (animasyon yok); bir
/// sonraki bölüme geçildiği hissi bunun yerine üst düzeydeki
/// [WatchEntryCard]'ın tamamının sağa kayıp yenisinin soldan gelmesiyle
/// verilir. Buton da işaretleme anında kısa bir "pop" animasyonu yapar.
class _NextEpisodeAction extends ConsumerStatefulWidget {
  const _NextEpisodeAction({required this.entry, required this.media});

  final WatchEntry entry;
  final CachedMedia media;

  @override
  ConsumerState<_NextEpisodeAction> createState() =>
      _NextEpisodeActionState();
}

class _NextEpisodeActionState extends ConsumerState<_NextEpisodeAction>
    with SingleTickerProviderStateMixin {
  bool _marking = false;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;

    if (entry.currentSeason == null || entry.currentEpisode == null) {
      return _buildAction(context, season: 1, episode: 1);
    }

    final nextAsync = ref.watch(
      _nextEpisodeProvider((
        tvId: entry.tmdbId,
        currentSeason: entry.currentSeason!,
        currentEpisode: entry.currentEpisode!,
        totalSeasons: widget.media.numberOfSeasons,
      )),
    );

    return nextAsync.when(
      data: (next) {
        if (next == null) {
          return SizedBox(
            width: 56,
            child: Text(
              context.l10n.t('watch_entry_card_all_episodes_watched'),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.green),
            ),
          );
        }
        return _buildAction(context, season: next.season, episode: next.episode);
      },
      loading: () => const SizedBox(
        width: 56,
        height: 56,
        child: Center(
          child: SizedBox(
            height: 14,
            width: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildAction(
    BuildContext context, {
    required int season,
    required int episode,
  }) {
    return SizedBox(
      height: 56,
      width: 56,
      child: Center(
        child: _marking
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : ScaleTransition(
                scale: _pulseAnimation,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  iconSize: 38,
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  tooltip: context.l10n.t('watch_entry_card_mark_watched_tooltip'),
                  onPressed: () => _markWatched(season, episode),
                ),
              ),
      ),
    );
  }

  Future<void> _markWatched(int season, int episode) async {
    final repository = ref.read(watchEntriesRepositoryProvider);
    setState(() => _marking = true);
    try {
      await repository.markEpisodeWatched(
        watchEntryId: widget.entry.id,
        seasonNumber: season,
        episodeNumber: episode,
      );
      // Küçük bir "pop" animasyonu ile işaretlemenin başarılı olduğuna dair
      // hafif bir geri bildirim ver; kartın tamamındaki sağa kayma geçişi
      // ise WatchEntryCard'da entry güncellenince otomatik tetiklenecek.
      if (mounted) _pulseController.forward(from: 0);
      // Rozet/bölüm satırının doğru gösterilebilmesi için izlenen bölüm
      // sayısı önbelleğini hemen tazele (autoDispose süresini beklemeden).
      ref.invalidate(_watchedEpisodesCountProvider(widget.entry.id));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                context.l10n.t('watch_entry_card_mark_watched_failed'),
              ),
            ),
          );
      }
    } finally {
      if (mounted) setState(() => _marking = false);
    }
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.mediaAsync});

  final AsyncValue<CachedMedia> mediaAsync;

  @override
  Widget build(BuildContext context) {
    const width = 64.0;
    const height = 96.0;

    return mediaAsync.when(
      data: (media) {
        final url = _posterUrl(media.posterPath);
        if (url == null) {
          return Container(
            width: width,
            height: height,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.movie_outlined),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: url,
            width: width,
            height: height,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: width,
              height: height,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            errorWidget: (context, url, error) => Container(
              width: width,
              height: height,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.broken_image_outlined),
            ),
          ),
        );
      },
      loading: () => Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      error: (_, _) => Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Icon(Icons.error_outline),
      ),
    );
  }
}