import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/cache/models/cached_media.dart';
import '../../../core/cache/models/cached_season.dart';
import '../../../core/localization/app_localizations.dart';
import '../../media/data/media_repository.dart';
import '../../media/domain/tv_show_lifecycle.dart';
import '../../watch_entries/data/models/media_type.dart';
import '../../watch_entries/data/models/watch_entry.dart';
import '../../watch_entries/data/models/watch_status.dart';
import '../../watch_entries/data/watch_entries_repository.dart';
import '../utils/next_episode_calculator.dart';
import 'widgets/episode_tile.dart';
import 'widgets/season_selector.dart';

class EpisodeTrackingScreen extends ConsumerStatefulWidget {
  const EpisodeTrackingScreen({
    required this.mediaType,
    required this.tmdbId,
    super.key,
  });

  final MediaType mediaType;
  final int tmdbId;

  @override
  ConsumerState<EpisodeTrackingScreen> createState() =>
      _EpisodeTrackingScreenState();
}

class _EpisodeTrackingScreenState extends ConsumerState<EpisodeTrackingScreen> {
  bool _initializing = true;
  String? _initErrorKey;

  WatchEntry? _entry;
  CachedMedia? _media;
  int _numberOfSeasons = 0;
  int _selectedSeason = 1;

  bool _loadingSeason = false;
  CachedSeason? _seasonDetail;
  Set<int> _watchedEpisodes = {};

  final _episodeKeys = <int, GlobalKey>{};
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == MediaType.tv) {
      _initialize();
    } else {
      _initializing = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    final watchEntriesRepository = ref.read(watchEntriesRepositoryProvider);
    final mediaRepository = ref.read(mediaRepositoryProvider);

    try {
      var entry = await watchEntriesRepository.getEntry(
        tmdbId: widget.tmdbId,
        mediaType: MediaType.tv,
      );
      entry ??= await watchEntriesRepository.upsertStatus(
        tmdbId: widget.tmdbId,
        mediaType: MediaType.tv,
        status: WatchStatus.planned,
      );

      final media = await mediaRepository.getMediaDetail(
        tmdbId: widget.tmdbId,
        mediaType: MediaType.tv,
      );

      final numberOfSeasons = media.numberOfSeasons ?? 0;
      final startingSeason = (entry.currentSeason ?? 1)
          .clamp(1, numberOfSeasons < 1 ? 1 : numberOfSeasons)
          .toInt();

      if (!mounted) return;
      setState(() {
        _entry = entry;
        _media = media;
        _numberOfSeasons = numberOfSeasons;
        _selectedSeason = startingSeason;
        _initializing = false;
      });

      await _loadSeason(startingSeason);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _initErrorKey = 'episode_tracking_init_error';
        _initializing = false;
      });
    }
  }

  Future<void> _loadSeason(int seasonNumber) async {
    final mediaRepository = ref.read(mediaRepositoryProvider);
    final watchEntriesRepository = ref.read(watchEntriesRepositoryProvider);
    final entry = _entry;
    if (entry == null) return;

    setState(() => _loadingSeason = true);
    try {
      final season = await mediaRepository.getSeasonDetail(
        tvId: widget.tmdbId,
        seasonNumber: seasonNumber,
      );
      final watched = await watchEntriesRepository.watchedEpisodeNumbers(
        watchEntryId: entry.id,
        seasonNumber: seasonNumber,
      );
      if (!mounted) return;
      _episodeKeys
        ..clear()
        ..addEntries(
          season.episodes.map(
            (episode) => MapEntry(episode.episodeNumber, GlobalKey()),
          ),
        );
      setState(() {
        _seasonDetail = season;
        _watchedEpisodes = watched;
        _loadingSeason = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingSeason = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(context.l10n.t('episode_tracking_season_load_error'))),
        );
    }
  }

  Future<void> _onEpisodeToggled(int episodeNumber, bool watched) async {
    final entry = _entry;
    if (entry == null) return;
    final watchEntriesRepository = ref.read(watchEntriesRepositoryProvider);

    try {
      if (watched) {
        await watchEntriesRepository.markEpisodeWatched(
          watchEntryId: entry.id,
          seasonNumber: _selectedSeason,
          episodeNumber: episodeNumber,
        );
      } else {
        await watchEntriesRepository.unmarkEpisodeWatched(
          watchEntryId: entry.id,
          seasonNumber: _selectedSeason,
          episodeNumber: episodeNumber,
        );
      }

      final refreshedWatched = await watchEntriesRepository
          .watchedEpisodeNumbers(
            watchEntryId: entry.id,
            seasonNumber: _selectedSeason,
          );
      // current_season/current_episode hem izlerken hem de geri alırken DB
      // trigger'ları tarafından güncellenir; ekranın da bunu yansıtması için
      // entry'yi burada yeniden çekiyoruz (aksi halde geri alma sonrası eski
      // "en son izlenen bölüm" bilgisiyle kalırdı).
      final refreshedEntry = await watchEntriesRepository.getEntry(
        tmdbId: widget.tmdbId,
        mediaType: MediaType.tv,
      );
      if (!mounted) return;
      setState(() {
        _watchedEpisodes = refreshedWatched;
        if (refreshedEntry != null) _entry = refreshedEntry;
      });

      if (watched) {
        await _handleAutoAdvance();
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(context.l10n.t('episode_tracking_action_failed'))),
        );
    }
  }

  /// Kullanıcı, dizinin bilinen son bölümüne (mevcut sezon/bölüm göstergesine
  /// göre) ulaştığında çağrılır. Dizi final yapmış/iptal edilmişse (yeni
  /// bölüm gelmeyecekse) VE tüm sezonların tüm bölümleri gerçekten izlendi
  /// olarak işaretlenmişse, durumu otomatik olarak "Tamamlandı" yapar.
  ///
  /// `current_season`/`current_episode` göstergesi yalnızca EN SON
  /// işaretlenen bölümü takip eder; kullanıcı önceki bölümleri atlamış
  /// olabilir. Bu yüzden asıl karar, TMDB'nin toplam bölüm sayısıyla
  /// veritabanındaki gerçek izlenmiş bölüm sayısının karşılaştırılmasına
  /// dayanır — yalnızca göstericinin son bölüme gelmiş olması yeterli
  /// sayılmaz.
  ///
  /// Dizi daha sonra geri çekilirse (TMDB status'ü tekrar "Returning
  /// Series"/"In Production" olursa), `classifyTvEntry` (bkz.
  /// tv_entry_classification.dart) zaten bunu "Diziler" sekmesine geri
  /// döndürür; burada yazılan `WatchStatus.completed`, uygulamanın kalıcı
  /// bir "isCompleted" bayrağı SAKLAMAMA prensibiyle çelişmez çünkü bu
  /// alan zaten kullanıcının menüden elle "Tamamlandı" işaretlemesiyle de
  /// aynı şekilde ayarlanabiliyor.
  Future<void> _maybeAutoCompleteSeries(WatchEntry entry) async {
    final media = _media;
    if (media == null) return;
    if (entry.status == WatchStatus.completed) return;

    final lifecycle = parseTvShowLifecycle(media.status);
    if (!lifecycle.isFinished) return;

    final totalEpisodes = media.numberOfEpisodes;
    if (totalEpisodes == null || totalEpisodes <= 0) return;

    final watchEntriesRepository = ref.read(watchEntriesRepositoryProvider);
    final int watchedTotal;
    try {
      watchedTotal = await watchEntriesRepository.watchedEpisodesTotalCount(
        watchEntryId: entry.id,
      );
    } catch (_) {
      return;
    }
    if (watchedTotal < totalEpisodes) return;

    try {
      final updated = await watchEntriesRepository.upsertStatus(
        tmdbId: widget.tmdbId,
        mediaType: MediaType.tv,
        status: WatchStatus.completed,
      );
      if (!mounted) return;
      setState(() => _entry = updated);
    } catch (_) {
      // Otomatik tamamlama başarısız olursa sessizce vazgeçilir; kullanıcı
      // isterse durumu menüden elle "Tamamlandı" olarak işaretleyebilir.
    }
  }

  /// "Bölümleri Yönet" ekranında görüntülenen sezonun henüz izlenmemiş tüm
  /// bölümlerini tek seferde "izlendi" olarak işaretler.
  Future<void> _markSeasonWatched() async {
    final entry = _entry;
    final season = _seasonDetail;
    if (entry == null || season == null) return;

    final toMark = season.episodes
        .map((episode) => episode.episodeNumber)
        .where((episodeNumber) => !_watchedEpisodes.contains(episodeNumber))
        .toList();
    if (toMark.isEmpty) return;

    final watchEntriesRepository = ref.read(watchEntriesRepositoryProvider);
    setState(() => _loadingSeason = true);
    try {
      await watchEntriesRepository.markEpisodesWatched(
        watchEntryId: entry.id,
        seasonNumber: _selectedSeason,
        episodeNumbers: toMark,
      );

      final refreshedWatched = await watchEntriesRepository
          .watchedEpisodeNumbers(
            watchEntryId: entry.id,
            seasonNumber: _selectedSeason,
          );
      final refreshedEntry = await watchEntriesRepository.getEntry(
        tmdbId: widget.tmdbId,
        mediaType: MediaType.tv,
      );
      if (!mounted) return;
      setState(() {
        _watchedEpisodes = refreshedWatched;
        if (refreshedEntry != null) _entry = refreshedEntry;
        _loadingSeason = false;
      });

      await _handleAutoAdvance();
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingSeason = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(context.l10n.t('episode_tracking_season_complete_error')),
          ),
        );
    }
  }

  /// "Bölümleri Yönet" ekranında görüntülenen sezonun izlenmiş tüm
  /// bölümlerini tek seferde "izlenmedi" olarak işaretler.
  Future<void> _markSeasonUnwatched() async {
    final entry = _entry;
    final season = _seasonDetail;
    if (entry == null || season == null) return;

    final toUnmark = season.episodes
        .map((episode) => episode.episodeNumber)
        .where((episodeNumber) => _watchedEpisodes.contains(episodeNumber))
        .toList();
    if (toUnmark.isEmpty) return;

    final watchEntriesRepository = ref.read(watchEntriesRepositoryProvider);
    setState(() => _loadingSeason = true);
    try {
      await watchEntriesRepository.unmarkEpisodesWatched(
        watchEntryId: entry.id,
        seasonNumber: _selectedSeason,
        episodeNumbers: toUnmark,
      );

      final refreshedWatched = await watchEntriesRepository
          .watchedEpisodeNumbers(
            watchEntryId: entry.id,
            seasonNumber: _selectedSeason,
          );
      // current_season/current_episode DB trigger'ları tarafından
      // güncellenir; ekranın da bunu yansıtması için entry'yi burada
      // yeniden çekiyoruz.
      final refreshedEntry = await watchEntriesRepository.getEntry(
        tmdbId: widget.tmdbId,
        mediaType: MediaType.tv,
      );
      if (!mounted) return;
      setState(() {
        _watchedEpisodes = refreshedWatched;
        if (refreshedEntry != null) _entry = refreshedEntry;
        _loadingSeason = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingSeason = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(context.l10n.t('episode_tracking_season_reset_error')),
          ),
        );
    }
  }

  Future<void> _handleAutoAdvance() async {
    final entry = _entry;
    final seasonDetail = _seasonDetail;
    if (entry == null || seasonDetail == null) return;

    final watchEntriesRepository = ref.read(watchEntriesRepositoryProvider);
    final updatedEntry = await watchEntriesRepository.getEntry(
      tmdbId: widget.tmdbId,
      mediaType: MediaType.tv,
    );
    if (updatedEntry == null) return;
    if (mounted) setState(() => _entry = updatedEntry);

    final currentSeason = updatedEntry.currentSeason;
    final currentEpisode = updatedEntry.currentEpisode;
    if (currentSeason == null || currentEpisode == null) return;

    int episodesInCurrentSeason;
    if (currentSeason == _selectedSeason) {
      episodesInCurrentSeason = seasonDetail.episodes.length;
    } else {
      final mediaRepository = ref.read(mediaRepositoryProvider);
      try {
        final otherSeason = await mediaRepository.getSeasonDetail(
          tvId: widget.tmdbId,
          seasonNumber: currentSeason,
        );
        episodesInCurrentSeason = otherSeason.episodes.length;
      } catch (_) {
        return;
      }
    }

    final next = computeNextEpisode(
      currentSeason: currentSeason,
      currentEpisode: currentEpisode,
      episodesInCurrentSeason: episodesInCurrentSeason,
      totalSeasons: _numberOfSeasons,
    );
    if (next == null) {
      await _maybeAutoCompleteSeries(updatedEntry);
      return;
    }
    if (!mounted) return;

    if (next.season == _selectedSeason) {
      final key = _episodeKeys[next.episode];
      final episodeContext = key?.currentContext;
      if (episodeContext != null && episodeContext.mounted) {
        Scrollable.ensureVisible(
          episodeContext,
          duration: const Duration(milliseconds: 300),
          alignment: 0.5,
        );
      }
    } else if (next.season > _selectedSeason) {
      // Önceden burada kullanıcıya "Sezon X'e geçmek ister misin?" diye
      // sorulup geçiş bir SnackBar aksiyonuna bağlıydı. Bir sezonun tüm
      // bölümleri izlendiğinde sıradaki sezona geçmek zaten tek makul
      // seçenek olduğu için artık sorulmadan otomatik geçiliyor ve
      // sıradaki sezonun ilk bölümüne kaydırılıyor.
      setState(() => _selectedSeason = next.season);
      await _loadSeason(next.season);
      if (!mounted) return;

      // Yeni sezonun bölüm kartları henüz bir sonraki frame'de çizilene
      // kadar `GlobalKey`lerin `currentContext`'i hazır olmayabilir; bu
      // yüzden kaydırmadan önce bir frame bekleniyor.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final key = _episodeKeys[next.episode];
        final episodeContext = key?.currentContext;
        if (episodeContext != null && episodeContext.mounted) {
          Scrollable.ensureVisible(
            episodeContext,
            duration: const Duration(milliseconds: 300),
            alignment: 0.5,
          );
        }
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.tp('episode_tracking_season_switched', {
                'season': '${next.season}',
              }),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaType != MediaType.tv) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.t('episode_tracking_title'))),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.t('episode_tracking_tv_only'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => context.pop(),
                  child: Text(context.l10n.t('common_go_back')),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final allWatched =
        _seasonDetail != null &&
        _seasonDetail!.episodes.isNotEmpty &&
        _seasonDetail!.episodes.every(
          (episode) => _watchedEpisodes.contains(episode.episodeNumber),
        );
    final anyWatched =
        _seasonDetail != null &&
        _seasonDetail!.episodes.any(
          (episode) => _watchedEpisodes.contains(episode.episodeNumber),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.t('episode_tracking_title')),
        actions: [
          if (_seasonDetail != null && !allWatched)
            IconButton(
              tooltip: context.l10n.t('episode_tracking_complete_season'),
              icon: const Icon(Icons.done_all_rounded),
              onPressed: _loadingSeason ? null : _markSeasonWatched,
            ),
          if (_seasonDetail != null && anyWatched)
            IconButton(
              tooltip: context.l10n.t('episode_tracking_reset_season'),
              icon: const Icon(Icons.remove_done_rounded),
              onPressed: _loadingSeason ? null : _markSeasonUnwatched,
            ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_initializing) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_initErrorKey != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.t(_initErrorKey!),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _initializing = true;
                    _initErrorKey = null;
                  });
                  _initialize();
                },
                child: Text(context.l10n.t('common_retry')),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 12),
        SeasonSelector(
          numberOfSeasons: _numberOfSeasons,
          selectedSeason: _selectedSeason,
          onSeasonSelected: (season) {
            setState(() => _selectedSeason = season);
            _loadSeason(season);
          },
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _loadingSeason || _seasonDetail == null
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _seasonDetail!.episodes.length,
                  itemBuilder: (context, index) {
                    final episode = _seasonDetail!.episodes[index];
                    return KeyedSubtree(
                      key: _episodeKeys[episode.episodeNumber],
                      child: EpisodeTile(
                        episode: episode,
                        isWatched: _watchedEpisodes.contains(
                          episode.episodeNumber,
                        ),
                        onChanged: (watched) =>
                            _onEpisodeToggled(episode.episodeNumber, watched),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
