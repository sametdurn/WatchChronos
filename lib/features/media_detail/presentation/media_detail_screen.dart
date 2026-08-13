import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/cache/models/cached_media.dart';
import '../../../core/config/env_config.dart';
import '../../../core/localization/app_localizations.dart';
import '../../media/data/media_repository.dart';
import '../../media/data/models/cast_member_model.dart';
import '../../media/data/tmdb_repository.dart';
import '../../watch_entries/data/models/media_type.dart';
import '../../watch_entries/data/models/watch_entry.dart';
import '../../watch_entries/data/models/watch_status.dart';
import '../../watch_entries/data/watch_entries_repository.dart';
import '../../watch_entries/data/watch_entry_error_translator.dart';
import 'widgets/rating_input.dart';

const _statusLabelKeys = {
  WatchStatus.planned: 'library_section_not_started',
  WatchStatus.watching: 'library_section_watching',
  WatchStatus.completed: 'library_tab_completed',
};

enum _TvMenuAction { markCompleted, markPlanned, remove }

enum _MovieMenuAction { remove }

class MediaDetailScreen extends ConsumerStatefulWidget {
  const MediaDetailScreen({
    required this.mediaType,
    required this.tmdbId,
    super.key,
  });

  final MediaType mediaType;
  final int tmdbId;

  @override
  ConsumerState<MediaDetailScreen> createState() => _MediaDetailScreenState();
}

class _MediaDetailScreenState extends ConsumerState<MediaDetailScreen> {
  Future<CachedMedia>? _mediaFuture;
  WatchEntry? _entry;
  bool _entryLoaded = false;
  bool _busy = false;
  int? _watchedEpisodesCount;
  String? _trailerKey;
  List<CastMemberModel> _cast = const [];

  /// Film için "izledim" (tamamlandı), dizi için en az 1 bölüm izlenmiş
  /// olması oylama yapabilmenin ön şartıdır. Kayıt kütüphanede yoksa da
  /// (henüz eklenmemiş) oylama yapılamaz.
  bool get _canRate {
    final entry = _entry;
    if (entry == null) return false;
    if (widget.mediaType == MediaType.movie) {
      return entry.status == WatchStatus.completed;
    }
    return (_watchedEpisodesCount ?? 0) > 0;
  }

  String get _ratingWarningMessageKey => widget.mediaType == MediaType.movie
      ? 'media_detail_rating_warning_movie'
      : 'media_detail_rating_warning_tv';

  @override
  void initState() {
    super.initState();
    _loadMedia();
    _loadEntry();
    _loadExtras();
  }

  /// Fragman ve oyuncu kadrosunu TMDB'den çeker. Bu veriler önbelleğe
  /// alınmaz (CachedMedia şemasına dahil değildir); ekran her açıldığında
  /// taze çekilir. Başarısız olursa sessizce yok sayılır (fragman/oyuncu
  /// bölümleri gösterilmez), ana içerik yüklemesini etkilemez.
  Future<void> _loadExtras() async {
    final repository = ref.read(tmdbRepositoryProvider);
    try {
      final originalLanguage = widget.mediaType == MediaType.movie
          ? (await repository.getMovieDetail(widget.tmdbId)).originalLanguage
          : (await repository.getTvDetail(widget.tmdbId)).originalLanguage;
      final trailerKey = widget.mediaType == MediaType.movie
          ? await repository.getMovieTrailerKey(
              widget.tmdbId,
              originalLanguage: originalLanguage,
            )
          : await repository.getTvTrailerKey(
              widget.tmdbId,
              originalLanguage: originalLanguage,
            );
      final cast = widget.mediaType == MediaType.movie
          ? await repository.getMovieCast(widget.tmdbId)
          : await repository.getTvCast(widget.tmdbId);
      if (mounted) {
        setState(() {
          _trailerKey = trailerKey;
          _cast = cast;
        });
      }
    } catch (e, st) {
      debugPrint('Fragman/oyuncu bilgisi alınamadı: $e\n$st');
    }
  }

  Future<void> _openTrailer() async {
    final key = _trailerKey;
    if (key == null) return;
    final uri = Uri.parse('https://www.youtube.com/watch?v=$key');
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      _showError('media_detail_error_trailer_open_failed');
    }
  }

  Future<void> _openTmdbPage() async {
    final path = widget.mediaType == MediaType.movie ? 'movie' : 'tv';
    final uri = Uri.parse('https://www.themoviedb.org/$path/${widget.tmdbId}');
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      _showError('media_detail_error_tmdb_open_failed');
    }
  }

  void _loadMedia({bool forceRefresh = false}) {
    final repository = ref.read(mediaRepositoryProvider);
    setState(() {
      _mediaFuture = repository.getMediaDetail(
        tmdbId: widget.tmdbId,
        mediaType: widget.mediaType,
        forceRefresh: forceRefresh,
      );
    });
  }

  /// Kütüphane kaydını (ve dizi ise izlenen bölüm sayısını) yükler.
  /// Bölüm işaretleme ekranından dönüldüğünde de tekrar çağrılır ki
  /// oylama şartı ("en az 1 bölüm izlendi") güncel kalsın.
  Future<void> _loadEntry() async {
    final repository = ref.read(watchEntriesRepositoryProvider);
    final entry = await repository.getEntry(
      tmdbId: widget.tmdbId,
      mediaType: widget.mediaType,
    );
    int? watchedCount;
    if (entry != null && widget.mediaType == MediaType.tv) {
      watchedCount = await repository.watchedEpisodesTotalCount(
        watchEntryId: entry.id,
      );
    }
    if (mounted) {
      setState(() {
        _entry = entry;
        _entryLoaded = true;
        _watchedEpisodesCount = watchedCount;
      });
    }
  }

  Future<void> _addToLibrary() async {
    final repository = ref.read(watchEntriesRepositoryProvider);
    setState(() => _busy = true);
    try {
      final created = await repository.addToLibrary(
        tmdbId: widget.tmdbId,
        mediaType: widget.mediaType,
      );
      if (mounted) setState(() => _entry = created);
    } catch (e, st) {
      debugPrint('Kütüphaneye eklenemedi: $e\n$st');
      _showError(_resolveErrorMessageKey(e, 'media_detail_error_add_failed'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _setStatus(WatchStatus status) async {
    final repository = ref.read(watchEntriesRepositoryProvider);
    setState(() => _busy = true);
    try {
      final updated = await repository.upsertStatus(
        tmdbId: widget.tmdbId,
        mediaType: widget.mediaType,
        status: status,
      );
      if (mounted) setState(() => _entry = updated);
    } catch (e, st) {
      debugPrint('Durum güncellenemedi: $e\n$st');
      _showError(_resolveErrorMessageKey(e, 'media_detail_error_status_update_failed'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleMovieWatched() async {
    final entry = _entry;
    if (entry == null) return;
    final nextStatus = entry.status == WatchStatus.completed
        ? WatchStatus.planned
        : WatchStatus.completed;
    await _setStatus(nextStatus);
  }

  /// Kütüphaneden kaldırır. Kayıt SİLİNMEZ (izlenen bölüm geçmişi/puan
  /// korunur), sadece kütüphane listelerinden çıkar; bu yüzden burada
  /// `_entry`'yi `null` yapmıyoruz, olduğu gibi (artık `inLibrary: false`)
  /// yeniden çekiyoruz ki "Bölümleri Yönet" ile geçmiş hâlâ görülebilsin.
  Future<void> _removeFromLibrary() async {
    final entry = _entry;
    if (entry == null) return;
    final repository = ref.read(watchEntriesRepositoryProvider);
    setState(() => _busy = true);
    try {
      await repository.removeFromLibrary(entry.id);
      final refreshed = await repository.getEntry(
        tmdbId: widget.tmdbId,
        mediaType: widget.mediaType,
      );
      if (mounted) setState(() => _entry = refreshed);
    } catch (e, st) {
      debugPrint('Kütüphaneden kaldırılamadı: $e\n$st');
      _showError(_resolveErrorMessageKey(e, 'media_detail_error_remove_failed'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleFavorite() async {
    final repository = ref.read(watchEntriesRepositoryProvider);
    try {
      final updated = await repository.toggleFavorite(
        tmdbId: widget.tmdbId,
        mediaType: widget.mediaType,
      );
      if (mounted) setState(() => _entry = updated);
    } catch (e, st) {
      debugPrint('Favori durumu güncellenemedi: $e\n$st');
      _showError(_resolveErrorMessageKey(e, 'media_detail_error_favorite_failed'));
    }
  }

  Future<void> _setRating(double? rating) async {
    // Not: `rating == null` durumu "Puanı Geri Al" butonuna basıldığında
    // oluşur ve puanın kaldırılması gerekir; burada erken `return` etmek
    // butonun hiçbir şey yapmamasına (çalışmıyormuş gibi görünmesine)
    // sebep oluyordu.
    if (rating != null && !_canRate) {
      _showError(context.l10n.t(_ratingWarningMessageKey));
      return;
    }
    final repository = ref.read(watchEntriesRepositoryProvider);
    try {
      final updated = await repository.setRating(
        tmdbId: widget.tmdbId,
        mediaType: widget.mediaType,
        rating: rating,
      );
      if (mounted) setState(() => _entry = updated);
    } catch (e, st) {
      debugPrint('Puan kaydedilemedi: $e\n$st');
      _showError(_resolveErrorMessageKey(e, 'media_detail_error_rating_failed'));
    }
  }

  /// Gerçek hatayı kullanıcıya anlamlı bir mesaja çeviren bir çeviri
  /// anahtarı döner.
  String _resolveErrorMessageKey(Object error, String fallbackKey) {
    if (error is WatchEntryException) {
      return WatchEntryErrorTranslator.messageKey(error);
    }
    if (error is StateError) {
      return 'media_detail_error_no_session';
    }
    return fallbackKey;
  }

  void _showError(String messageKey) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.t(messageKey))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CachedMedia>(
        future: _mediaFuture,
        builder: (context, snapshot) {
          // Medya VE kütüphane kaydı (varsa) birlikte yüklenene kadar
          // bekle. Aksi halde `_entry` henüz null iken küçük "Kütüphaneme
          // Ekle" butonu bir an gösterilip, `_entry` az sonra gelince
          // birden "İzledim olarak işaretle" satırına büyüyerek zıplıyordu.
          if (snapshot.connectionState == ConnectionState.waiting ||
              !_entryLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.t('media_detail_load_failed'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => _loadMedia(forceRefresh: true),
                      child: Text(context.l10n.t('common_retry')),
                    ),
                  ],
                ),
              ),
            );
          }
          return _DetailBody(
            media: snapshot.data!,
            entry: _entry,
            busy: _busy,
            canRate: _canRate,
            trailerKey: _trailerKey,
            cast: _cast,
            onAddToLibrary: _addToLibrary,
            onSetStatus: _setStatus,
            onToggleMovieWatched: _toggleMovieWatched,
            onRemoveFromLibrary: _removeFromLibrary,
            onFavoriteToggled: _toggleFavorite,
            onRatingChanged: _setRating,
            onEpisodesManaged: _loadEntry,
            onWatchTrailer: _openTrailer,
            onMoreInfo: _openTmdbPage,
          );
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.media,
    required this.entry,
    required this.busy,
    required this.canRate,
    required this.trailerKey,
    required this.cast,
    required this.onAddToLibrary,
    required this.onSetStatus,
    required this.onToggleMovieWatched,
    required this.onRemoveFromLibrary,
    required this.onFavoriteToggled,
    required this.onRatingChanged,
    required this.onEpisodesManaged,
    required this.onWatchTrailer,
    required this.onMoreInfo,
  });

  final CachedMedia media;
  final WatchEntry? entry;
  final bool busy;
  final bool canRate;
  final String? trailerKey;
  final List<CastMemberModel> cast;
  final VoidCallback onAddToLibrary;
  final ValueChanged<WatchStatus> onSetStatus;
  final VoidCallback onToggleMovieWatched;
  final VoidCallback onRemoveFromLibrary;
  final VoidCallback onFavoriteToggled;
  final ValueChanged<double?> onRatingChanged;
  final VoidCallback onEpisodesManaged;
  final VoidCallback onWatchTrailer;
  final VoidCallback onMoreInfo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = media.releaseDate ?? media.firstAirDate;
    final backdropUrl = media.backdropPath == null
        ? null
        : '${EnvConfig.tmdbImageBaseUrl}w780${media.backdropPath}';
    final posterUrl = media.posterPath == null
        ? null
        : '${EnvConfig.tmdbImageBaseUrl}w342${media.posterPath}';

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: backdropUrl == null ? 120 : 220,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: backdropUrl == null
                ? Container(color: theme.colorScheme.surfaceContainerHighest)
                : CachedNetworkImage(imageUrl: backdropUrl, fit: BoxFit.cover),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: posterUrl == null
                          ? Container(
                              width: 96,
                              height: 144,
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.movie_outlined),
                            )
                          : CachedNetworkImage(
                              imageUrl: posterUrl,
                              width: 96,
                              height: 144,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(media.title, style: theme.textTheme.headlineMedium),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (date != null)
                                Text('${date.year}', style: theme.textTheme.bodyMedium),
                              Chip(
                                label: Text(
                                  media.mediaType == MediaType.movie
                                      ? context.l10n.t(
                                          'common_media_type_movie',
                                        )
                                      : context.l10n.t(
                                          'common_media_type_show',
                                        ),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              if (media.voteAverage != null)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(media.voteAverage!.toStringAsFixed(1)),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (trailerKey != null)
                                OutlinedButton.icon(
                                  onPressed: onWatchTrailer,
                                  icon: const Icon(
                                    Icons.play_circle_outline_rounded,
                                    size: 18,
                                  ),
                                  label: Text(
                                    context.l10n.t('media_detail_watch_trailer'),
                                  ),
                                ),
                              OutlinedButton.icon(
                                onPressed: onMoreInfo,
                                icon: const Icon(
                                  Icons.info_outline_rounded,
                                  size: 18,
                                ),
                                label: Text(
                                  context.l10n.t('media_detail_more_info'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (media.overview != null && media.overview!.isNotEmpty)
                  Text(media.overview!, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 24),
                _LibrarySection(
                  media: media,
                  entry: entry,
                  busy: busy,
                  onAddToLibrary: onAddToLibrary,
                  onSetStatus: onSetStatus,
                  onToggleMovieWatched: onToggleMovieWatched,
                  onRemoveFromLibrary: onRemoveFromLibrary,
                  onEpisodesManaged: onEpisodesManaged,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      context.l10n.t('media_detail_favorite'),
                      style: theme.textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: onFavoriteToggled,
                      icon: Icon(
                        (entry?.isFavorite ?? false)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.t('media_detail_your_rating'),
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                RatingInput(
                  rating: entry?.rating,
                  onChanged: onRatingChanged,
                  enabled: canRate,
                  disabledHint: media.mediaType == MediaType.movie
                      ? context.l10n.t('media_detail_disabled_hint_movie')
                      : context.l10n.t('media_detail_disabled_hint_tv'),
                ),
                if (cast.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.t('media_detail_cast'),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 168,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: cast.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final member = cast[index];
                        final photoUrl = member.profilePath == null
                            ? null
                            : '${EnvConfig.tmdbImageBaseUrl}w185${member.profilePath}';
                        return SizedBox(
                          width: 96,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(48),
                                child: photoUrl == null
                                    ? Container(
                                        width: 72,
                                        height: 72,
                                        color:
                                            theme.colorScheme.surfaceContainerHighest,
                                        child: const Icon(
                                          Icons.person_outline_rounded,
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: photoUrl,
                                        width: 72,
                                        height: 72,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                member.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (member.character != null &&
                                  member.character!.isNotEmpty)
                                Text(
                                  member.character!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodySmall,
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// İçerik türüne göre "Kütüphaneme Ekle" / durum yönetimi bloğu.
/// - Henüz eklenmemişse: tek bir "Kütüphaneme Ekle" butonu.
/// - Film ise: "İzledim" toggle butonu (Tamamlandı <-> Henüz Başlanmadı).
/// - Dizi ise: durum etiketi + "Bölümleri Yönet" + manuel durum menüsü.
class _LibrarySection extends StatelessWidget {
  const _LibrarySection({
    required this.media,
    required this.entry,
    required this.busy,
    required this.onAddToLibrary,
    required this.onSetStatus,
    required this.onToggleMovieWatched,
    required this.onRemoveFromLibrary,
    required this.onEpisodesManaged,
  });

  final CachedMedia media;
  final WatchEntry? entry;
  final bool busy;
  final VoidCallback onAddToLibrary;
  final ValueChanged<WatchStatus> onSetStatus;
  final VoidCallback onToggleMovieWatched;
  final VoidCallback onRemoveFromLibrary;
  final VoidCallback onEpisodesManaged;

  @override
  Widget build(BuildContext context) {
    if (entry == null) {
      return FilledButton.icon(
        onPressed: busy ? null : onAddToLibrary,
        icon: const Icon(Icons.add_rounded),
        label: Text(context.l10n.t('media_detail_add_to_library')),
      );
    }

    // Daha önce kütüphaneden kaldırılmış ama kaydı (ve izlenen bölüm
    // geçmişi) hâlâ duran bir içerik: "Kütüphaneme Ekle" ile geri
    // eklenebilir; dizilerde ayrıca geçmiş bölüm işaretlerine de -tekrar
    // eklemeden- bakılabilir.
    if (!entry!.inLibrary) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton.icon(
            onPressed: busy ? null : onAddToLibrary,
            icon: const Icon(Icons.add_rounded),
            label: Text(context.l10n.t('media_detail_re_add_to_library')),
          ),
          if (media.mediaType == MediaType.tv) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => context.push(
                AppRoutes.episodeTracking(
                  mediaType: media.mediaType.name,
                  tmdbId: media.tmdbId,
                ),
              ),
              icon: const Icon(Icons.checklist_rounded),
              label: Text(context.l10n.t('media_detail_view_watched_episodes')),
            ),
          ],
        ],
      );
    }

    if (media.mediaType == MediaType.movie) {
      final watched = entry!.status == WatchStatus.completed;
      return Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: busy ? null : onToggleMovieWatched,
              icon: Icon(
                watched
                    ? Icons.check_circle_rounded
                    : Icons.check_circle_outline_rounded,
              ),
              label: Text(
                watched
                    ? context.l10n.t('media_detail_watched')
                    : context.l10n.t('media_detail_mark_watched'),
              ),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<_MovieMenuAction>(
            onSelected: (action) {
              if (action == _MovieMenuAction.remove) onRemoveFromLibrary();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _MovieMenuAction.remove,
                child: Text(context.l10n.t('media_detail_remove_from_library')),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Chip(
          label: Text(
            context.l10n.t(_statusLabelKeys[entry!.status] ?? ''),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () async {
              await context.push(
                AppRoutes.episodeTracking(
                  mediaType: media.mediaType.name,
                  tmdbId: media.tmdbId,
                ),
              );
              onEpisodesManaged();
            },
            icon: const Icon(Icons.checklist_rounded),
            label: Text(context.l10n.t('media_detail_manage_episodes')),
          ),
        ),
        PopupMenuButton<_TvMenuAction>(
          onSelected: (action) {
            switch (action) {
              case _TvMenuAction.markCompleted:
                onSetStatus(WatchStatus.completed);
                break;
              case _TvMenuAction.markPlanned:
                onSetStatus(WatchStatus.planned);
                break;
              case _TvMenuAction.remove:
                onRemoveFromLibrary();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _TvMenuAction.markCompleted,
              child: Text(context.l10n.t('media_detail_mark_completed')),
            ),
            PopupMenuItem(
              value: _TvMenuAction.markPlanned,
              child: Text(context.l10n.t('library_section_not_started')),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: _TvMenuAction.remove,
              child: Text(context.l10n.t('media_detail_remove_from_library')),
            ),
          ],
        ),
      ],
    );
  }
}
