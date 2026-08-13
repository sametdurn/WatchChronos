import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import '../data/models/watchchronos_export_models.dart';
import '../data/watchchronos_import_service.dart';

enum _ImportStage { idle, reading, importing, done, error }

/// Kullanıcının daha önce "Verilerimi Dışa Aktar" ile oluşturduğu
/// WatchChronos `.json` dosyasını seçip geri yükleyebildiği ekran.
///
/// TV Time importundan ayrıdır (bkz. `TvTimeImportScreen`): burada
/// belirsiz eşleşme/manuel seçim adımı yoktur, çünkü her kayıt zaten kendi
/// `tmdb_id`'siyle gelir ve doğrudan geri yüklenir.
class WatchChronosImportScreen extends ConsumerStatefulWidget {
  const WatchChronosImportScreen({super.key});

  @override
  ConsumerState<WatchChronosImportScreen> createState() =>
      _WatchChronosImportScreenState();
}

class _WatchChronosImportScreenState
    extends ConsumerState<WatchChronosImportScreen> {
  _ImportStage _stage = _ImportStage.idle;
  String? _statusMessageKey;
  Map<String, String> _statusMessageParams = const {};
  double? _progressValue;
  WatchChronosImportResult? _result;
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
      allowedExtensions: ['json'],
      withData: true,
    );
    if (picked == null || picked.files.isEmpty) return;

    final bytes = picked.files.single.bytes;
    if (bytes == null) {
      setState(() {
        _stage = _ImportStage.error;
        _errorMessageKey = 'watchchronos_import_error_file_read';
        _errorMessageParams = const {};
      });
      return;
    }

    setState(() {
      _stage = _ImportStage.reading;
      _statusMessageKey = 'watchchronos_import_status_reading';
      _statusMessageParams = const {};
      _progressValue = null;
      _errorMessageKey = null;
      _errorMessageParams = const {};
      _result = null;
    });

    try {
      final service = ref.read(watchChronosImportServiceProvider);
      final WatchChronosExportData data;
      try {
        data = service.parse(bytes);
      } on WatchChronosExportFormatException catch (e) {
        setState(() {
          _stage = _ImportStage.error;
          _errorMessageKey = e.messageKey;
          _errorMessageParams = e.messageParams;
        });
        return;
      }

      setState(() {
        _stage = _ImportStage.importing;
        _statusMessageKey = 'watchchronos_import_status_starting';
        _statusMessageParams = const {};
      });

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
        _errorMessageKey = 'watchchronos_import_error_generic';
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
        _stage == _ImportStage.reading || _stage == _ImportStage.importing;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.t('settings_import_title'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.t('watchchronos_import_intro')),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                context.l10n.t('watchchronos_import_notes'),
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
                icon: const Icon(Icons.file_open_rounded),
                label: Text(context.l10n.t('watchchronos_import_pick_button')),
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

class _ImportSummary extends StatelessWidget {
  const _ImportSummary({required this.result, required this.onDone});

  final WatchChronosImportResult result;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.tp('watchchronos_import_total_found', {
            'count': '${result.totalEntriesFound}',
          }),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 12),
        Text(
          context.l10n.tp('watchchronos_import_restored_entries', {
            'count': '${result.restoredEntries}',
          }),
        ),
        Text(
          context.l10n.tp('watchchronos_import_restored_episode_logs', {
            'count': '${result.restoredEpisodeLogs}',
          }),
        ),
        if (result.failedEntries.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            context.l10n.tp('watchchronos_import_failed_entries', {
              'count': '${result.failedEntries.length}',
            }),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(result.failedEntries.join('\n')),
        ],
        const SizedBox(height: 20),
        FilledButton(
          onPressed: onDone,
          child: Text(context.l10n.t('common_ok')),
        ),
      ],
    );
  }
}
