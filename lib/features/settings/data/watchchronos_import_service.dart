import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../watch_entries/data/models/media_type.dart';
import '../../watch_entries/data/models/watch_status.dart';
import '../../watch_entries/data/watch_entries_repository.dart';
import 'models/watchchronos_export_models.dart';

/// WatchChronos'un kendi export dosyasını ([WatchChronosExportData]) geri
/// yükleyen servis.
///
/// [TvTimeImportService]'ten TAMAMEN AYRIDIR ve kasıtlı olarak çok daha
/// basittir: TV Time importunda başlık/yıl gibi belirsiz bilgilerden yola
/// çıkıp TMDB'de doğru içeriği "tahmin etmek" gerekiyordu (bkz.
/// `TvTimeMatchEngine`), bu yüzden bulanık eşleştirme + ambiguous/manuel
/// seçim akışı vardı. Burada öyle bir belirsizlik YOKTUR: her kayıt zaten
/// kendi `tmdb_id`'sini taşıyor, dolayısıyla eşleştirme motoruna, aday
/// puanlamasına ya da kullanıcıya soru sormaya gerek kalmadan doğrudan
/// `tmdb_id` üzerinden `upsert` yapılır. Sonuç ya "geri yüklendi" ya da
/// (satır bozuksa/DB hatası varsa) "başarısız" olur; "belirsiz" bir hal
/// yoktur.
class WatchChronosImportProgress {
  const WatchChronosImportProgress({
    required this.current,
    required this.total,
    required this.messageKey,
    this.messageParams = const {},
  });

  final int current;
  final int total;
  final String messageKey;
  final Map<String, String> messageParams;
}

/// İçe aktarım tamamlandığında kullanıcıya gösterilecek özet.
class WatchChronosImportResult {
  int totalEntriesFound = 0;
  int restoredEntries = 0;
  int restoredEpisodeLogs = 0;

  /// Geri yüklenemeyen kayıtlar, sebebiyle birlikte (tanı amaçlı, doğrudan
  /// kullanıcıya gösterilir).
  final List<String> failedEntries = [];
}

class WatchChronosImportService {
  WatchChronosImportService(this._watchEntriesRepository);

  final WatchEntriesRepository _watchEntriesRepository;

  /// Dosyadan okunan ham byte'ları [WatchChronosExportData]'ya çevirir.
  /// JSON bozuksa, beklenen alanlar yoksa ya da `schema_version` bu
  /// uygulama sürümünün desteklediğinden yeniyse
  /// [WatchChronosExportFormatException] fırlatır — mesajı doğrudan
  /// kullanıcıya gösterilebilir.
  WatchChronosExportData parse(Uint8List bytes) {
    dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(bytes));
    } catch (e) {
      throw WatchChronosExportFormatException(
        'watchchronos_import_error_unreadable',
        messageParams: {'error': '$e'},
      );
    }
    if (decoded is! Map<String, dynamic>) {
      throw const WatchChronosExportFormatException(
        'watchchronos_import_error_bad_format',
      );
    }
    if (decoded['entries'] == null) {
      throw const WatchChronosExportFormatException(
        'watchchronos_import_error_missing_entries',
      );
    }
    try {
      return WatchChronosExportData.fromJson(decoded);
    } on WatchChronosExportFormatException {
      rethrow;
    } catch (e) {
      throw WatchChronosExportFormatException(
        'watchchronos_import_error_parse_failed',
        messageParams: {'error': '$e'},
      );
    }
  }

  /// Ayrıştırılmış export verisini kullanıcının hesabına geri yükler.
  /// Her kayıt bağımsız işlenir: biri başarısız olursa diğerleri etkilenmez
  /// (bkz. [WatchChronosImportResult.failedEntries]).
  Future<WatchChronosImportResult> import(
    WatchChronosExportData data, {
    required void Function(WatchChronosImportProgress progress) onProgress,
  }) async {
    final result = WatchChronosImportResult();
    result.totalEntriesFound = data.entries.length;

    var current = 0;
    for (final entry in data.entries) {
      current++;
      onProgress(
        WatchChronosImportProgress(
          current: current,
          total: data.entries.length,
          messageKey: 'watchchronos_import_progress_restoring',
          messageParams: {'tmdbId': '${entry.tmdbId}'},
        ),
      );

      final mediaType = entry.mediaType == 'movie'
          ? MediaType.movie
          : MediaType.tv;

      final WatchStatus status;
      try {
        status = _statusFromJson(entry.status);
      } catch (_) {
        result.failedEntries.add(
          'TMDB #${entry.tmdbId} (${entry.mediaType}): bilinmeyen durum '
          '"${entry.status}"',
        );
        continue;
      }

      try {
        final restored = await _watchEntriesRepository.restoreEntry(
          tmdbId: entry.tmdbId,
          mediaType: mediaType,
          status: status,
          isFavorite: entry.isFavorite,
          inLibrary: entry.inLibrary,
          rating: entry.rating,
          notes: entry.notes,
          startedAt: entry.startedAt,
          finishedAt: entry.finishedAt,
          currentSeason: entry.currentSeason,
          currentEpisode: entry.currentEpisode,
        );
        result.restoredEntries++;

        // Bölüm geçmişi sadece dizilerde vardır. `markEpisodeWatched`
        // zaten aynı (watch_entry_id, sezon, bölüm) tekrar geldiğinde
        // sessizce geçiyor (23505 hatası özel olarak yutuluyor), bu yüzden
        // aynı export'un tekrar tekrar içe aktarılması güvenlidir.
        if (mediaType == MediaType.tv && entry.episodeLogs.isNotEmpty) {
          for (final log in entry.episodeLogs) {
            try {
              await _watchEntriesRepository.markEpisodeWatched(
                watchEntryId: restored.id,
                seasonNumber: log.seasonNumber,
                episodeNumber: log.episodeNumber,
                watchedAt: log.watchedAt,
              );
              result.restoredEpisodeLogs++;
            } catch (_) {
              // Tek bir bölüm kaydı başarısız olursa diziyi/diğer
              // bölümleri etkilememesi için atla, devam et.
            }
          }
        }
      } catch (e) {
        result.failedEntries.add('TMDB #${entry.tmdbId} (${entry.mediaType}): $e');
      }
    }

    return result;
  }

  WatchStatus _statusFromJson(String raw) {
    switch (raw) {
      case 'planned':
        return WatchStatus.planned;
      case 'watching':
        return WatchStatus.watching;
      case 'completed':
        return WatchStatus.completed;
      case 'on_hold':
        // Geriye dönük uyumluluk: 'on_hold' durumu uygulamadan tamamen
        // kaldırıldı (artık üretilmiyor/seçilemiyor — zaten UI'da hiçbir
        // yerden ayarlanamıyordu). Bu değeri hâlâ içeren eski bir export
        // dosyası içe aktarılırsa reddetmek yerine, tıpkı 'dropped' gibi,
        // 'watching'e eşliyoruz.
        return WatchStatus.watching;
      case 'dropped':
        // Geriye dönük uyumluluk: 'dropped' durumu uygulamadan tamamen
        // kaldırıldı (artık üretilmiyor/seçilemiyor). Bu değeri hâlâ
        // içeren eski bir export dosyası içe aktarılırsa reddetmek yerine
        // 'watching'e eşliyoruz — aynı DB migration'ın var olan kayıtlara
        // yaptığı gibi.
        return WatchStatus.watching;
      default:
        throw ArgumentError('Bilinmeyen durum: $raw');
    }
  }
}

final watchChronosImportServiceProvider = Provider<WatchChronosImportService>(
  (ref) =>
      WatchChronosImportService(ref.watch(watchEntriesRepositoryProvider)),
);
