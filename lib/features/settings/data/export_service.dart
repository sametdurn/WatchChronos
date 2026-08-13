import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../watch_entries/data/models/media_type.dart';
import '../../watch_entries/data/models/watch_status.dart';
import '../../watch_entries/data/watch_entries_repository.dart';
import 'models/watchchronos_export_models.dart';

/// Kullanıcının TÜM izleme verisini (`watch_entries` + `episode_logs`)
/// WatchChronos'un kendi JSON şemasında ([WatchChronosExportData]) dışa
/// aktarır.
///
/// TV Time aktarımının aksine burada bir eşleştirme motoruna gerek yoktur:
/// her kayıt zaten kendi `tmdb_id`'sini taşıdığından, karşılığındaki içe
/// aktarım servisi doğrudan `tmdb_id` üzerinden `upsert` yapabilir — bulanık
/// başlık eşleştirmesi, belirsizlik ya da manuel seçim söz konusu değildir.
/// Dolayısıyla bu export, doğru bir içe aktarım servisiyle birleştiğinde
/// %100 birebir (kayıpsız) bir yedekleme/geri yükleme sağlayacak şekilde
/// tasarlanmıştır: `id`/`user_id`/`created_at`/`updated_at` dışındaki HER
/// alan taşınır (bkz. `watchchronos_export_models.dart` üstündeki not).
class WatchChronosExportService {
  WatchChronosExportService(this._watchEntriesRepository);

  final WatchEntriesRepository _watchEntriesRepository;

  /// Export verisini (henüz JSON'a çevrilmemiş) oluşturur.
  Future<WatchChronosExportData> buildExportData() async {
    final entries = await _watchEntriesRepository.getAllEntriesForExport();
    final episodeLogsByEntry = await _watchEntriesRepository
        .getAllEpisodeLogsForExport();

    return WatchChronosExportData(
      schemaVersion: watchChronosExportSchemaVersion,
      exportedAt: DateTime.now().toUtc(),
      entries: [
        for (final entry in entries)
          WatchChronosExportEntry(
            tmdbId: entry.tmdbId,
            mediaType: _mediaTypeToJson(entry.mediaType),
            status: _statusToJson(entry.status),
            isFavorite: entry.isFavorite,
            inLibrary: entry.inLibrary,
            rating: entry.rating,
            notes: entry.notes,
            startedAt: entry.startedAt,
            finishedAt: entry.finishedAt,
            currentSeason: entry.currentSeason,
            currentEpisode: entry.currentEpisode,
            episodeLogs: [
              for (final log in episodeLogsByEntry[entry.id] ?? const [])
                WatchChronosExportEpisodeLog(
                  seasonNumber: log.seasonNumber,
                  episodeNumber: log.episodeNumber,
                  watchedAt: log.watchedAt,
                ),
            ],
          ),
      ],
    );
  }

  /// [buildExportData]'yı okunabilir (girintili) JSON metnine çevirip
  /// UTF-8 byte dizisi olarak döner — doğrudan dosyaya yazmaya/paylaşmaya
  /// hazır hâldedir.
  Future<Uint8List> exportToJsonBytes() async {
    final data = await buildExportData();
    const encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(data.toJson());
    return Uint8List.fromList(utf8.encode(jsonString));
  }

  /// Önerilen dosya adı, ör. `watchchronos_export_2026-07-18.json`.
  String suggestedFileName() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return 'watchchronos_export_${now.year}-${two(now.month)}-${two(now.day)}'
        '.json';
  }

  String _mediaTypeToJson(MediaType mediaType) =>
      mediaType == MediaType.movie ? 'movie' : 'tv';

  String _statusToJson(WatchStatus status) {
    switch (status) {
      case WatchStatus.planned:
        return 'planned';
      case WatchStatus.watching:
        return 'watching';
      case WatchStatus.completed:
        return 'completed';
    }
  }
}

final watchChronosExportServiceProvider = Provider<WatchChronosExportService>(
  (ref) => WatchChronosExportService(ref.watch(watchEntriesRepositoryProvider)),
);
