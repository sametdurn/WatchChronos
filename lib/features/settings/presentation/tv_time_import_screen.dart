import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env_config.dart';
import '../../../core/localization/app_localizations.dart';
import '../data/models/tv_time_import_models.dart';
import '../data/tv_time_gdpr_parser.dart';
import '../data/tv_time_import_service.dart';
import '../data/tv_time_match_engine.dart';

enum _ImportStage { idle, parsing, importing, done, error }

/// Kullanıcının TV Time'dan aldığı GDPR ZIP dosyasını seçip WatchChronos'a
/// aktarabildiği ekran. Ayarlar sayfasındaki "TV Time Verilerini Aktar"
/// butonundan açılır.
class TvTimeImportScreen extends ConsumerStatefulWidget {
  const TvTimeImportScreen({super.key});

  @override
  ConsumerState<TvTimeImportScreen> createState() =>
      _TvTimeImportScreenState();
}

class _TvTimeImportScreenState extends ConsumerState<TvTimeImportScreen> {
  _ImportStage _stage = _ImportStage.idle;
  String? _statusMessageKey;
  Map<String, String> _statusMessageParams = const {};
  double? _progressValue;
  TvTimeImportResult? _result;
  String? _errorMessageKey;
  Map<String, String> _errorMessageParams = const {};

  String get _statusMessage => _statusMessageKey == null
      ? ''
      : context.l10n.tp(_statusMessageKey!, _statusMessageParams);

  String? get _errorMessage => _errorMessageKey == null
      ? null
      : context.l10n.tp(_errorMessageKey!, _errorMessageParams);

  Future<void> _pickAndImport() async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
      withData: true,
    );
    if (picked == null || picked.files.isEmpty) return;

    final bytes = picked.files.single.bytes;
    if (bytes == null) {
      setState(() {
        _stage = _ImportStage.error;
        _errorMessageKey = 'tv_time_import_error_file_read';
        _errorMessageParams = const {};
      });
      return;
    }

    setState(() {
      _stage = _ImportStage.parsing;
      _statusMessageKey = 'tv_time_import_status_parsing';
      _statusMessageParams = const {};
      _progressValue = null;
      _errorMessageKey = null;
      _errorMessageParams = const {};
      _result = null;
    });

    try {
      const parser = TvTimeGdprParser();
      final TvTimeImportData data;
      try {
        data = parser.parse(bytes);
      } on TvTimeParseException catch (e) {
        setState(() {
          _stage = _ImportStage.error;
          _errorMessageKey = e.messageKey;
          _errorMessageParams = e.messageParams;
        });
        return;
      }

      setState(() {
        _stage = _ImportStage.importing;
        _statusMessageKey = 'tv_time_import_status_starting';
        _statusMessageParams = const {};
      });

      final service = ref.read(tvTimeImportServiceProvider);
      final result = await service.import(
        data,
        onProgress: (progress) {
          if (!mounted) return;
          setState(() {
            _statusMessageKey = progress.messageKey;
            _statusMessageParams = progress.messageParams;
            _progressValue = progress.total == 0
                ? null
                : progress.current / progress.total;
          });
        },
      );

      if (!mounted) return;
      setState(() {
        _stage = _ImportStage.done;
        _result = result;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _stage = _ImportStage.error;
        _errorMessageKey = 'tv_time_import_error_generic';
        _errorMessageParams = {'error': '$e'};
      });
    }
  }

  void _reset() => setState(() {
    _stage = _ImportStage.idle;
    _errorMessageKey = null;
    _errorMessageParams = const {};
    _result = null;
  });

  @override
  Widget build(BuildContext context) {
    final isBusy =
        _stage == _ImportStage.parsing || _stage == _ImportStage.importing;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.t('settings_tv_time_import_title')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.t('tv_time_import_intro')),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                context.l10n.t('tv_time_import_notes'),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),
            if (!isBusy && _stage != _ImportStage.done) ...[
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(height: 12),
              ],
              FilledButton.icon(
                onPressed: _pickAndImport,
                icon: const Icon(Icons.upload_file_rounded),
                label: Text(context.l10n.t('tv_time_import_pick_button')),
              ),
            ],
            if (isBusy) ...[
              LinearProgressIndicator(value: _progressValue),
              const SizedBox(height: 12),
              Text(_statusMessage),
            ],
            if (_stage == _ImportStage.done && _result != null)
              _ImportSummary(result: _result!, onDone: _reset),
          ],
        ),
      ),
    );
  }
}

class _ImportSummary extends ConsumerStatefulWidget {
  const _ImportSummary({required this.result, required this.onDone});

  final TvTimeImportResult result;
  final VoidCallback onDone;

  @override
  ConsumerState<_ImportSummary> createState() => _ImportSummaryState();
}

class _ImportSummaryState extends ConsumerState<_ImportSummary> {
  late final List<TvTimePendingShowMatch> _pendingShows =
      List.of(widget.result.pendingShowMatches);
  late final List<TvTimePendingMovieMatch> _pendingMovies =
      List.of(widget.result.pendingMovieMatches);

  /// Çözülmekte olan (buton tıklandı, bekleniyor) öğelerin anahtarları.
  final Set<String> _resolving = {};

  Future<void> _resolveShow(TvTimePendingShowMatch pending, int? tmdbId) async {
    final key = 'show:${pending.show.name}';
    setState(() => _resolving.add(key));
    try {
      if (tmdbId != null) {
        final service = ref.read(tvTimeImportServiceProvider);
        await service.resolveShowMatch(pending.show, tmdbId, widget.result);
      } else {
        widget.result.unmatchedShows.add(pending.show.name);
      }
    } catch (_) {
      widget.result.unmatchedShows.add(pending.show.name);
    }
    if (!mounted) return;
    setState(() {
      _pendingShows.remove(pending);
      _resolving.remove(key);
    });
  }

  Future<void> _resolveMovie(
    TvTimePendingMovieMatch pending,
    int? tmdbId,
  ) async {
    final key = 'movie:${pending.movie.name}';
    setState(() => _resolving.add(key));
    try {
      if (tmdbId != null) {
        final service = ref.read(tvTimeImportServiceProvider);
        await service.resolveMovieMatch(pending.movie, tmdbId, widget.result);
      } else {
        widget.result.unmatchedMovies.add(pending.movie.name);
      }
    } catch (_) {
      widget.result.unmatchedMovies.add(pending.movie.name);
    }
    if (!mounted) return;
    setState(() {
      _pendingMovies.remove(pending);
      _resolving.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final hasPending = _pendingShows.isNotEmpty || _pendingMovies.isNotEmpty;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              hasPending ? Icons.info_rounded : Icons.check_circle_rounded,
              color: hasPending ? Colors.orange : Colors.green,
            ),
            const SizedBox(width: 8),
            Text(
              hasPending
                  ? l10n.t('tv_time_import_done_with_pending')
                  : l10n.t('tv_time_import_done'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          l10n.tp('tv_time_import_found_stats', {
            'shows': '${result.totalShowsFound}',
            'followed': '${result.followedShowsFound}',
            'movies': '${result.totalMoviesFound}',
          }),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 12),
        Text(l10n.tp('tv_time_import_matched_shows', {
          'count': '${result.matchedShows}',
        })),
        Text(l10n.tp('tv_time_import_matched_movies', {
          'count': '${result.matchedMovies}',
        })),
        Text(l10n.tp('tv_time_import_exact_shows', {
          'count': '${result.exactEpisodeShows}',
        })),
        Text(
          l10n.tp('tv_time_import_approx_shows', {
            'count': '${result.approximatedEpisodeShows}',
          }),
        ),
        if (_pendingShows.isNotEmpty || _pendingMovies.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            l10n.t('tv_time_import_choose_candidate'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (final pending in _pendingShows)
            _PendingMatchCard(
              title: pending.show.name,
              subtitle: pending.show.yearHint != null
                  ? l10n.tp('tv_time_import_subtitle_with_year', {
                      'year': '${pending.show.yearHint}',
                      'type': l10n.t('tv_time_import_type_show'),
                    })
                  : l10n.t('tv_time_import_type_show'),
              candidates: pending.candidates,
              isResolving: _resolving.contains('show:${pending.show.name}'),
              onPick: (tmdbId) => _resolveShow(pending, tmdbId),
            ),
          for (final pending in _pendingMovies)
            _PendingMatchCard(
              title: pending.movie.name,
              subtitle: pending.movie.releaseYear != null
                  ? l10n.tp('tv_time_import_subtitle_with_year', {
                      'year': '${pending.movie.releaseYear}',
                      'type': l10n.t('tv_time_import_type_movie'),
                    })
                  : l10n.t('tv_time_import_type_movie'),
              candidates: pending.candidates,
              isResolving: _resolving.contains('movie:${pending.movie.name}'),
              onPick: (tmdbId) => _resolveMovie(pending, tmdbId),
            ),
        ],
        if (result.unmatchedShows.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            l10n.tp('tv_time_import_unmatched_shows', {
              'count': '${result.unmatchedShows.length}',
            }),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(result.unmatchedShows.join(', ')),
        ],
        if (result.unmatchedMovies.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            l10n.tp('tv_time_import_unmatched_movies', {
              'count': '${result.unmatchedMovies.length}',
            }),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(result.unmatchedMovies.join(', ')),
        ],
        const SizedBox(height: 20),
        FilledButton(
          onPressed: hasPending ? null : widget.onDone,
          child: Text(
            hasPending
                ? l10n.t('tv_time_import_resolve_first')
                : l10n.t('common_ok'),
          ),
        ),
      ],
    );
  }
}

/// Belirsiz bir TV Time kaydı için en güçlü ~3 TMDB adayını gösterip
/// kullanıcıya seçim yaptıran kart. "Oto seç" en yüksek puanlı adayı
/// doğrudan seçer; "Hiçbiri / atla" ise kaydı hiç aktarmadan geçer.
class _PendingMatchCard extends StatelessWidget {
  const _PendingMatchCard({
    required this.title,
    required this.subtitle,
    required this.candidates,
    required this.isResolving,
    required this.onPick,
  });

  final String title;
  final String subtitle;
  final List<TvTimeMatchCandidate> candidates;
  final bool isResolving;
  final void Function(int? tmdbId) onPick;

  /// Adaylar zaten puana göre azalan sırada geliyor (bkz.
  /// [TvTimeMatchEngine._resolve]), ama "Oto seç" burada yine de skora göre
  /// gerçek en yükseği bulur; sıralamaya kör güvenmek yerine.
  TvTimeMatchCandidate get _bestCandidate =>
      candidates.reduce((a, b) => b.score > a.score ? b : a);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            if (isResolving)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(),
              )
            else ...[
              for (final candidate in candidates)
                _CandidateTile(
                  candidate: candidate,
                  onTap: () => onPick(candidate.tmdbId),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: 4,
                  children: [
                    if (candidates.isNotEmpty)
                      TextButton(
                        onPressed: () => onPick(_bestCandidate.tmdbId),
                        child: Text(context.l10n.t('tv_time_import_auto_pick')),
                      ),
                    TextButton(
                      onPressed: () => onPick(null),
                      child: Text(context.l10n.t('tv_time_import_skip')),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Tek bir TMDB adayını; küçük bir afiş, başlık, (varsa ve başlıktan
/// farklıysa) orijinal başlık ve tam yayın tarihiyle gösteren, tıklanabilir
/// satır. Aynı isme sahip ama farklı yıl/dublaj kaydı olan iki adayı ayırt
/// etmeyi kolaylaştırmak için tasarlandı.
class _CandidateTile extends StatelessWidget {
  const _CandidateTile({required this.candidate, required this.onTap});

  final TvTimeMatchCandidate candidate;
  final VoidCallback onTap;

  /// TMDB'nin "YYYY-MM-DD" formatındaki tarihini "12 Ekim 2019" gibi okunur
  /// bir metne çevirir. Format beklenenden farklıysa ham hâliyle döner.
  String _formatDate(BuildContext context, String raw) {
    final l10n = context.l10n;
    if (raw.isEmpty) return l10n.t('tv_time_import_release_date_unknown');
    final parts = raw.split('-');
    if (parts.length != 3) return raw;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null || month < 1 || month > 12) {
      return raw;
    }
    return '$day ${l10n.t('month_$month')} $year';
  }

  bool get _hasDistinctOriginalTitle {
    final a = candidate.title.trim().toLowerCase();
    final b = candidate.originalTitle.trim().toLowerCase();
    return b.isNotEmpty && b != a;
  }

  @override
  Widget build(BuildContext context) {
    final posterUrl = candidate.posterPath == null
        ? null
        : '${EnvConfig.tmdbImageBaseUrl}w92${candidate.posterPath}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 40,
                height: 60,
                child: posterUrl == null
                    ? Container(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.movie_outlined, size: 18),
                      )
                    : Image.network(
                        posterUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.movie_outlined, size: 18),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    candidate.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (_hasDistinctOriginalTitle)
                    Text(
                      candidate.originalTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  Text(
                    _formatDate(context, candidate.releaseDate),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
