/// WatchChronos'un kendi izleme verisini dışa/içe aktarmak için kullandığı
/// JSON şeması.
///
/// TV Time aktarımının aksine burada bir eşleştirme motoruna (bkz.
/// `TvTimeMatchEngine`) İHTİYAÇ YOKTUR: her kayıt zaten kendi `tmdb_id`'sini
/// taşır, bu yüzden içe aktarım doğrudan `tmdb_id` üzerinden `upsert`
/// yapabilir -- ya birebir eşleşir ya da (uyumsuz bir dosyaysa) baştan
/// reddedilir. Belirsiz/kısmi/manuel seçim durumu söz konusu değildir.
///
/// [watchChronosExportSchemaVersion] ileride alan eklenip/çıkarılırsa eski
/// export dosyalarının yine de okunabilmesi için tutulur; içe aktarım
/// tarafı bu alana göre dallanabilir/reddedebilir.
///
/// Kasıtlı olarak DIŞARIDA bırakılan alanlar: `id`, `user_id`, `created_at`,
/// `updated_at`. Bunlar veritabanına/hedef hesaba özgüdür; içe aktarımda
/// zaten hedef kullanıcı için yeniden üretilirler. Kullanıcının GERÇEKTEN
/// önemsediği her şey (durum, favori, puan, not, kaldığı yer, tam bölüm
/// geçmişi) birebir taşınır.
library;

const int watchChronosExportSchemaVersion = 1;

/// Bir dizinin tek bir bölüm izleme kaydı ("hangi bölüm, ne zaman
/// izlendi"). Sadece `media_type == 'tv'` olan kayıtlarda kullanılır.
class WatchChronosExportEpisodeLog {
  const WatchChronosExportEpisodeLog({
    required this.seasonNumber,
    required this.episodeNumber,
    required this.watchedAt,
  });

  final int seasonNumber;
  final int episodeNumber;
  final DateTime watchedAt;

  Map<String, dynamic> toJson() => {
    'season_number': seasonNumber,
    'episode_number': episodeNumber,
    'watched_at': watchedAt.toUtc().toIso8601String(),
  };

  static WatchChronosExportEpisodeLog fromJson(Map<String, dynamic> json) {
    return WatchChronosExportEpisodeLog(
      seasonNumber: json['season_number'] as int,
      episodeNumber: json['episode_number'] as int,
      watchedAt: DateTime.parse(json['watched_at'] as String),
    );
  }
}

/// `watch_entries` tablosundaki TEK bir satırın (dizi ya da film) dışa
/// aktarım karşılığı. Kullanıcının bu kayıtla ilgili anlamlı olan HER
/// alanı (durum, favori, kütüphanede olup olmama, puan, not, başlangıç/
/// bitiş tarihi, kaldığı sezon/bölüm, tam bölüm geçmişi) birebir taşır.
class WatchChronosExportEntry {
  const WatchChronosExportEntry({
    required this.tmdbId,
    required this.mediaType,
    required this.status,
    required this.isFavorite,
    required this.inLibrary,
    this.rating,
    this.notes,
    this.startedAt,
    this.finishedAt,
    this.currentSeason,
    this.currentEpisode,
    this.episodeLogs = const [],
  });

  final int tmdbId;

  /// Ham DB değeri: `'movie'` veya `'tv'`.
  final String mediaType;

  /// Ham DB değeri: `'planned'`, `'watching'`, `'completed'`. Eski export
  /// dosyalarında `'on_hold'` veya `'dropped'` da bulunabilir (uygulamadan
  /// kaldırıldı); içe aktarımda ikisi de `'watching'`e eşleniyor.
  final String status;

  final bool isFavorite;

  /// `false` ise kayıt kütüphaneden kaldırılmış ama geçmişi/puanı hâlâ
  /// korunuyor demektir (bkz. `WatchEntriesRepository.removeFromLibrary`).
  /// Export bu bayrağı da birebir taşır, aksi halde geri içe aktarımda
  /// kaldırılmış bir kayıt yeniden kütüphanede beliriverir.
  final bool inLibrary;

  final double? rating;
  final String? notes;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final int? currentSeason;
  final int? currentEpisode;

  /// Yalnızca `mediaType == 'tv'` için doldurulur.
  final List<WatchChronosExportEpisodeLog> episodeLogs;

  Map<String, dynamic> toJson() => {
    'tmdb_id': tmdbId,
    'media_type': mediaType,
    'status': status,
    'is_favorite': isFavorite,
    'in_library': inLibrary,
    if (rating != null) 'rating': rating,
    if (notes != null && notes!.isNotEmpty) 'notes': notes,
    if (startedAt != null) 'started_at': startedAt!.toUtc().toIso8601String(),
    if (finishedAt != null)
      'finished_at': finishedAt!.toUtc().toIso8601String(),
    if (currentSeason != null) 'current_season': currentSeason,
    if (currentEpisode != null) 'current_episode': currentEpisode,
    if (episodeLogs.isNotEmpty)
      'episode_logs': episodeLogs.map((e) => e.toJson()).toList(),
  };

  static WatchChronosExportEntry fromJson(Map<String, dynamic> json) {
    final rawLogs = json['episode_logs'] as List<dynamic>?;
    return WatchChronosExportEntry(
      tmdbId: json['tmdb_id'] as int,
      mediaType: json['media_type'] as String,
      status: json['status'] as String,
      isFavorite: json['is_favorite'] as bool? ?? false,
      inLibrary: json['in_library'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      startedAt: json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at'] as String),
      finishedAt: json['finished_at'] == null
          ? null
          : DateTime.parse(json['finished_at'] as String),
      currentSeason: json['current_season'] as int?,
      currentEpisode: json['current_episode'] as int?,
      episodeLogs: rawLogs == null
          ? const []
          : rawLogs
                .map(
                  (e) => WatchChronosExportEpisodeLog.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList(),
    );
  }
}

/// Bütün export dosyasının kök nesnesi.
class WatchChronosExportData {
  const WatchChronosExportData({
    required this.schemaVersion,
    required this.exportedAt,
    required this.entries,
  });

  final int schemaVersion;
  final DateTime exportedAt;
  final List<WatchChronosExportEntry> entries;

  Map<String, dynamic> toJson() => {
    'schema_version': schemaVersion,
    'exported_at': exportedAt.toUtc().toIso8601String(),
    'entries': entries.map((e) => e.toJson()).toList(),
  };

  static WatchChronosExportData fromJson(Map<String, dynamic> json) {
    final version = json['schema_version'] as int? ?? 1;
    if (version > watchChronosExportSchemaVersion) {
      throw const WatchChronosExportFormatException(
        'Bu dosya, uygulamanın bu sürümünden daha yeni bir formatta '
        'kaydedilmiş. Lütfen uygulamayı güncelleyip tekrar dene.',
      );
    }
    final rawEntries = json['entries'] as List<dynamic>? ?? const [];
    return WatchChronosExportData(
      schemaVersion: version,
      exportedAt: json['exported_at'] == null
          ? DateTime.now().toUtc()
          : DateTime.parse(json['exported_at'] as String),
      entries: rawEntries
          .map(
            (e) =>
                WatchChronosExportEntry.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

/// Seçilen dosya WatchChronos export formatında değilse (beklenen alanlar
/// yok, `schema_version` desteklenmiyor, JSON parse edilemiyor vb.)
/// fırlatılır. Mesajı doğrudan kullanıcıya gösterilecek şekilde açıklayıcı
/// tutulur (bkz. `TvTimeParseException` ile aynı desen).
/// [message] artık ham metin değil, bir çeviri anahtarıdır (bkz.
/// core/localization); UI katmanı `context.l10n.tp(messageKey, params)`
/// ile gösterir.
class WatchChronosExportFormatException implements Exception {
  const WatchChronosExportFormatException(
    this.messageKey, {
    this.messageParams = const {},
  });

  final String messageKey;
  final Map<String, String> messageParams;

  @override
  String toString() => messageKey;
}
