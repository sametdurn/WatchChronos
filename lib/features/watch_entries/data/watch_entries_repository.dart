import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import 'models/media_type.dart';
import 'models/watch_entry.dart';
import 'models/watch_entry_stats.dart';
import 'models/watch_status.dart';
import 'watch_entry_error_translator.dart';

class WatchEntriesRepository {
  WatchEntriesRepository(this._client);

  final SupabaseClient _client;

  static const _episodeAlreadyLoggedCode = '23505';

  String _requireUserId() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('WatchEntriesRepository: kullanıcı giriş yapmamış.');
    }
    return userId;
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

  Future<WatchEntry?> getEntry({
    required int tmdbId,
    required MediaType mediaType,
  }) async {
    final userId = _requireUserId();
    try {
      final response = await _client
          .from('watch_entries')
          .select()
          .eq('user_id', userId)
          .eq('tmdb_id', tmdbId)
          .eq('media_type', _mediaTypeToJson(mediaType))
          .maybeSingle();
      return response == null ? null : WatchEntry.fromJson(response);
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }

  /// Kullanıcının kütüphanesindeki TÜM kayıtları (tür/durum ayrımı yapmadan)
  /// TEK bir realtime aboneliğiyle döner. Diziler/Filmler/Tamamlandı/
  /// Favoriler sekmeleri artık her biri kendi `watchEntries(...)` çağrısıyla
  /// ayrı bir Supabase kanalı açmak yerine, bu tek stream'i paylaşıp
  /// filtrelemeyi kendi tarafında (istemci tarafında, zaten elde olan veri
  /// üzerinde) yapar. Böylece aynı anda açık birden çok sekme, aynı veriyi
  /// tekrar tekrar Supabase'den çekmez.
  Stream<List<WatchEntry>> libraryEntries() {
    final userId = _requireUserId();
    return _client
        .from('watch_entries')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map(
          (rows) => rows
              .where(_isInLibrary)
              .map(WatchEntry.fromJson)
              .toList(),
        );
  }

  Stream<List<WatchEntry>> watchEntriesByStatus(WatchStatus status) {
    final userId = _requireUserId();
    final targetStatus = _statusToJson(status);
    return _client
        .from('watch_entries')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map(
          (rows) => rows
              .where(
                (row) =>
                    row['status'] == targetStatus && _isInLibrary(row),
              )
              .map(WatchEntry.fromJson)
              .toList(),
        );
  }

  /// Bir satırın hâlâ kullanıcının kütüphanesinde sayılıp sayılmayacağını
  /// döner. Sütun eski (migration öncesi) bir yerel/anlık görüntüde yoksa
  /// `true` kabul edilir (varsayılan DB değeriyle tutarlı).
  bool _isInLibrary(Map<String, dynamic> row) => row['in_library'] != false;

  /// "Diziler" / "Filmler" gibi birden çok tür+durum kombinasyonuna göre
  /// filtrelenmiş kütüphane listeleri için genel amaçlı stream. Sadece hâlâ
  /// kütüphanede olan (`in_library = true`) kayıtları döner — kaldırılmış
  /// kayıtlar burada görünmez ama silinmeden veritabanında kalmaya devam
  /// eder (bkz. [removeFromLibrary]).
  /// [mediaType] veya [statuses] `null` bırakılırsa o filtre uygulanmaz.
  Stream<List<WatchEntry>> watchEntries({
    MediaType? mediaType,
    Set<WatchStatus>? statuses,
  }) {
    final userId = _requireUserId();
    final targetStatuses = statuses
        ?.map(_statusToJson)
        .toSet();
    return _client
        .from('watch_entries')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map(
          (rows) => rows
              .where(
                (row) =>
                    _isInLibrary(row) &&
                    (mediaType == null ||
                        row['media_type'] == _mediaTypeToJson(mediaType)) &&
                    (targetStatuses == null ||
                        targetStatuses.contains(row['status'])),
              )
              .map(WatchEntry.fromJson)
              .toList(),
        );
  }

  Stream<List<WatchEntry>> favoriteEntries() {
    final userId = _requireUserId();
    return _client
        .from('watch_entries')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map(
          (rows) => rows
              .where((row) => row['is_favorite'] == true && _isInLibrary(row))
              .map(WatchEntry.fromJson)
              .toList(),
        );
  }

  Future<WatchEntry> upsertStatus({
    required int tmdbId,
    required MediaType mediaType,
    required WatchStatus status,
    // TV Time gibi dış kaynaklardan aktarım yaparken, kullanıcının diziyi/
    // filmi GERÇEKTEN ne zaman bitirdiği biliniyorsa (izleme tarihinden)
    // bu tarih verilebilir; verilmezse `now()` kullanılır.
    DateTime? finishedAt,
    // TV Time gibi dış kaynaklardan aktarımda "kaldığı yer" (en son izlenen
    // sezon/bölüm) biliniyorsa buraya yazılabilir; `null` verilirse mevcut
    // değer korunur (üzerine yazılmaz).
    int? currentSeason,
    int? currentEpisode,
    // Dış kaynaktan aktarılan, WatchChronos şemasında karşılığı olmayan
    // bilgiler (ör. TV Time'daki yeniden izleme sayısı) için serbest metin
    // notu. `null` verilirse mevcut not korunur.
    String? appendNotes,
  }) async {
    final userId = _requireUserId();
    final existing = await getEntry(tmdbId: tmdbId, mediaType: mediaType);
    final now = DateTime.now().toUtc().toIso8601String();

    final payload = <String, dynamic>{
      'user_id': userId,
      'tmdb_id': tmdbId,
      'media_type': _mediaTypeToJson(mediaType),
      'status': _statusToJson(status),
      // Bir durum bilinçli olarak ayarlanıyorsa (menüden/durum seçiciden)
      // kayıt kütüphanede sayılmalı; daha önce kaldırılmış olsa bile.
      'in_library': true,
    };
    if (status == WatchStatus.watching && existing?.startedAt == null) {
      payload['started_at'] = now;
    }
    if (status == WatchStatus.completed && existing?.finishedAt == null) {
      payload['finished_at'] =
          (finishedAt?.toUtc() ?? DateTime.now().toUtc()).toIso8601String();
    }
    if (currentSeason != null) payload['current_season'] = currentSeason;
    if (currentEpisode != null) payload['current_episode'] = currentEpisode;
    if (appendNotes != null && appendNotes.isNotEmpty) {
      final existingNotes = existing?.notes;
      payload['notes'] = (existingNotes == null || existingNotes.isEmpty)
          ? appendNotes
          : '$existingNotes\n$appendNotes';
    }

    try {
      final response = await _client
          .from('watch_entries')
          .upsert(payload, onConflict: 'user_id,tmdb_id,media_type')
          .select()
          .single();
      return WatchEntry.fromJson(response);
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }

  /// Kütüphaneye ekler. Bu tmdbId/mediaType için DAHA ÖNCE bir kayıt varsa
  /// (örn. kullanıcı kaldırıp tekrar ekliyorsa), eski durumu/izlenen bölüm
  /// geçmişini SIFIRLAMADAN sadece [WatchEntry.inLibrary] alanını tekrar
  /// `true` yapar. Hiç kayıt yoksa yeni bir tane "Henüz Başlanmadı"
  /// durumuyla oluşturur.
  Future<WatchEntry> addToLibrary({
    required int tmdbId,
    required MediaType mediaType,
  }) async {
    final existing = await getEntry(tmdbId: tmdbId, mediaType: mediaType);
    if (existing != null) {
      return _setInLibraryFlag(existing.id, true);
    }
    return upsertStatus(
      tmdbId: tmdbId,
      mediaType: mediaType,
      status: WatchStatus.planned,
    );
  }

  /// Kütüphaneden kaldırır.
  ///
  /// - Dizi (`tv`) ise ve hiç bölüm izlenmemişse (`episode_logs`'ta hiç
  ///   kaydı yoksa): kayıt veritabanından TAMAMEN SİLİNİR. Kaybedilecek bir
  ///   izleme geçmişi olmadığı için kütüphanede "yarım kalmış, boş" bir
  ///   dizi kaydı bırakmanın anlamı yok.
  /// - Dizi olup en az bir bölüm izlenmişse, veya film ise: kayıt SİLİNMEZ
  ///   — sadece `in_library = false` yapılır; böylece izlenen bölüm
  ///   geçmişi (`episode_logs`), puan ve notlar korunur. Kaldırılmış bir
  ///   kayıt kütüphane listelerinde görünmez ama Keşfet'ten girilen içerik
  ///   detayında (`getEntry`) hâlâ erişilebilir, kütüphaneye tekrar
  ///   eklenirse (bkz. [addToLibrary]) eski durumu geri gelir.
  Future<void> removeFromLibrary(String watchEntryId) async {
    _requireUserId();
    try {
      final row = await _client
          .from('watch_entries')
          .select('id, media_type')
          .eq('id', watchEntryId)
          .single();

      if (row['media_type'] == 'tv') {
        final episodeLogs = await _client
            .from('episode_logs')
            .select('id')
            .eq('watch_entry_id', watchEntryId)
            .limit(1);
        if (episodeLogs.isEmpty) {
          await _client.from('watch_entries').delete().eq('id', watchEntryId);
          return;
        }
      }
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }

    await _setInLibraryFlag(watchEntryId, false);
  }

  Future<WatchEntry> _setInLibraryFlag(
    String watchEntryId,
    bool inLibrary,
  ) async {
    _requireUserId();
    try {
      final response = await _client
          .from('watch_entries')
          .update({'in_library': inLibrary})
          .eq('id', watchEntryId)
          .select()
          .single();
      return WatchEntry.fromJson(response);
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }

  /// `favorited_at` burada elle set EDİLMEZ: `is_favorite` FALSE'tan
  /// TRUE'ya geçtiğinde onu otomatik dolduran bir DB trigger'ı var (bkz.
  /// 20260805120000_watch_entries_favorited_at.sql migration'ı). Böylece bu
  /// alanı unutabilecek her yeni yazma yolunda (import, gelecekteki bir
  /// özellik...) ayrıca hatırlanması gerekmiyor.
  Future<WatchEntry> toggleFavorite({
    required int tmdbId,
    required MediaType mediaType,
  }) async {
    final userId = _requireUserId();
    final existing = await getEntry(tmdbId: tmdbId, mediaType: mediaType);
    final newFavorite = existing == null ? true : !existing.isFavorite;

    final payload = <String, dynamic>{
      'user_id': userId,
      'tmdb_id': tmdbId,
      'media_type': _mediaTypeToJson(mediaType),
      'is_favorite': newFavorite,
    };

    try {
      final response = await _client
          .from('watch_entries')
          .upsert(payload, onConflict: 'user_id,tmdb_id,media_type')
          .select()
          .single();
      return WatchEntry.fromJson(response);
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }

  /// [rating] `null` verilirse puan tamamen kaldırılır (favori toggle'ına
  /// benzer şekilde, aynı yıldıza tekrar basılınca kullanılır).
  Future<WatchEntry> setRating({
    required int tmdbId,
    required MediaType mediaType,
    required double? rating,
  }) async {
    if (rating != null && (rating < 0 || rating > 5)) {
      throw ArgumentError.value(
        rating,
        'rating',
        'rating 0-5 arasında olmalı',
      );
    }
    final userId = _requireUserId();
    final payload = <String, dynamic>{
      'user_id': userId,
      'tmdb_id': tmdbId,
      'media_type': _mediaTypeToJson(mediaType),
      'rating': rating,
    };

    try {
      final response = await _client
          .from('watch_entries')
          .upsert(payload, onConflict: 'user_id,tmdb_id,media_type')
          .select()
          .single();
      return WatchEntry.fromJson(response);
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }

  Future<void> markEpisodeWatched({
    required String watchEntryId,
    required int seasonNumber,
    required int episodeNumber,
    // TV Time gibi dış kaynaklardan aktarımda bölümün GERÇEKTEN ne zaman
    // izlendiği biliniyorsa buraya verilir; `null` ise `now()` kullanılır
    // (tablo varsayılanı).
    DateTime? watchedAt,
  }) async {
    final userId = _requireUserId();
    try {
      await _client.from('episode_logs').insert({
        'watch_entry_id': watchEntryId,
        'user_id': userId,
        'season_number': seasonNumber,
        'episode_number': episodeNumber,
        if (watchedAt != null) 'watched_at': watchedAt.toUtc().toIso8601String(),
      });
    } on PostgrestException catch (e) {
      if (e.code == _episodeAlreadyLoggedCode) return;
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }

  Future<void> unmarkEpisodeWatched({
    required String watchEntryId,
    required int seasonNumber,
    required int episodeNumber,
  }) async {
    _requireUserId();
    try {
      await _client
          .from('episode_logs')
          .delete()
          .eq('watch_entry_id', watchEntryId)
          .eq('season_number', seasonNumber)
          .eq('episode_number', episodeNumber);
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }

  /// Bir sezonun (henüz izlenmemiş) tüm bölümlerini tek istekte "izlendi"
  /// olarak işaretler. "Bölümleri Yönet" ekranındaki "Sezonu Tamamla"
  /// aksiyonu için kullanılır; [markEpisodeWatched]'i bölüm bölüm N kez
  /// çağırmak yerine tek bir toplu `upsert` atar. Zaten izlenmiş bölümler
  /// `ignoreDuplicates` sayesinde hataya sebep olmaz.
  Future<void> markEpisodesWatched({
    required String watchEntryId,
    required int seasonNumber,
    required List<int> episodeNumbers,
  }) async {
    final userId = _requireUserId();
    if (episodeNumbers.isEmpty) return;
    try {
      await _client
          .from('episode_logs')
          .upsert(
            [
              for (final episodeNumber in episodeNumbers)
                {
                  'watch_entry_id': watchEntryId,
                  'user_id': userId,
                  'season_number': seasonNumber,
                  'episode_number': episodeNumber,
                },
            ],
            onConflict: 'watch_entry_id,season_number,episode_number',
            ignoreDuplicates: true,
          );
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }

  /// Bir sezonun (izlenmiş) tüm bölümlerini tek istekte "izlenmedi" olarak
  /// işaretler. "Bölümleri Yönet" ekranındaki "Sezonu Sıfırla" aksiyonu için
  /// kullanılır; [unmarkEpisodeWatched]'i bölüm bölüm N kez çağırmak yerine
  /// tek bir toplu `delete` atar.
  Future<void> unmarkEpisodesWatched({
    required String watchEntryId,
    required int seasonNumber,
    required List<int> episodeNumbers,
  }) async {
    _requireUserId();
    if (episodeNumbers.isEmpty) return;
    try {
      await _client
          .from('episode_logs')
          .delete()
          .eq('watch_entry_id', watchEntryId)
          .eq('season_number', seasonNumber)
          .inFilter('episode_number', episodeNumbers);
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }

  Future<Set<int>> watchedEpisodeNumbers({
    required String watchEntryId,
    required int seasonNumber,
  }) async {
    _requireUserId();
    try {
      final response = await _client
          .from('episode_logs')
          .select('episode_number')
          .eq('watch_entry_id', watchEntryId)
          .eq('season_number', seasonNumber);
      return response.map((row) => row['episode_number'] as int).toSet();
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }

  /// Bir dizinin (tüm sezonlar dahil) toplam kaç bölümünün izlendi olarak
  /// işaretlendiğini döner. "Dizinin tüm bölümleri izlendi mi?" sorusunu
  /// cevaplamak için `CachedMedia.numberOfEpisodes` ile karşılaştırılır.
  Future<int> watchedEpisodesTotalCount({required String watchEntryId}) async {
    _requireUserId();
    try {
      final response = await _client
          .from('episode_logs')
          .select('episode_number')
          .eq('watch_entry_id', watchEntryId);
      return response.length;
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }

  /// [watchedEpisodesTotalCount]'un toplu hâli. Kütüphane sekmesi gibi
  /// birçok dizinin izlenen bölüm sayısına aynı anda ihtiyaç duyulan
  /// yerlerde, her dizi için ayrı bir sorgu atmak yerine (N dizi = N sorgu)
  /// tüm `watch_entry_id`'ler tek bir `IN (...)` sorgusuyla çekilir ve
  /// sonuçlar bellekte gruplanır.
  Future<Map<String, int>> watchedEpisodesTotalCounts({
    required List<String> watchEntryIds,
  }) async {
    _requireUserId();
    if (watchEntryIds.isEmpty) return const {};
    try {
      final response = await _client
          .from('episode_logs')
          .select('watch_entry_id')
          .inFilter('watch_entry_id', watchEntryIds);
      final counts = <String, int>{};
      for (final row in response) {
        final id = row['watch_entry_id'] as String;
        counts[id] = (counts[id] ?? 0) + 1;
      }
      return counts;
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }

  /// Belirli bir [mediaType] için kullanıcının kütüphanesindeki tüm
  /// `tmdb_id`'lerin kümesini tek bir sorgu/realtime abonelik ile döner.
  ///
  /// Keşfet ekranındaki arama sonuçları ve gündem listelerinde her kart
  /// kendi `AddToLibraryButton`'ı için ayrı ayrı "bu kütüphanede var mı?"
  /// sorgusu atarsa (N sonuç = N sorgu) gereksiz yere çok fazla istek
  /// oluşur. Bunun yerine tek bir stream tüm ekrandaki butonlar arasında
  /// paylaşılır (Riverpod aynı [mediaType] için aynı stream'i tekilleştirir).
  Stream<Set<int>> libraryTmdbIds({required MediaType mediaType}) {
    final userId = _requireUserId();
    final targetType = _mediaTypeToJson(mediaType);
    return _client
        .from('watch_entries')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map(
          (rows) => rows
              .where(
                (row) => row['media_type'] == targetType && _isInLibrary(row),
              )
              .map((row) => row['tmdb_id'] as int)
              .toSet(),
        );
  }

  Future<WatchEntryStats?> getStats() async {
    _requireUserId();
    try {
      final response = await _client
          .from('user_watch_stats')
          .select()
          .maybeSingle();
      return response == null ? null : WatchEntryStats.fromJson(response);
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }

  // ---------------------------------------------------------------------
  // İçe aktarım (import) — bkz. WatchChronosImportService
  // ---------------------------------------------------------------------

  /// Bir WatchChronos export kaydını AYNEN geri yükler: durum, favori,
  /// kütüphanede olma bayrağı, puan, not, başlama/bitiş tarihi, kaldığı
  /// sezon/bölüm — hepsi verilen değerle DOĞRUDAN üzerine yazılır.
  ///
  /// [upsertStatus]'un aksine burada "akıllı"/koşullu davranış YOKTUR
  /// (ör. "sadece boşsa tarih ata", "nota ekle, üzerine yazma"): import'un
  /// amacı kullanıcı etkileşimini simüle etmek değil, export'ta ne varsa
  /// birebir/eksiksiz geri getirmektir. Bu yüzden [rating]/[notes]/
  /// [startedAt]/[finishedAt]/[currentSeason]/[currentEpisode] `null`
  /// verilirse mevcut değer korunmaz, tabloda da `null` olarak yazılır —
  /// export dosyasında o alan yoksa zaten kaynakta da `null`dı.
  Future<WatchEntry> restoreEntry({
    required int tmdbId,
    required MediaType mediaType,
    required WatchStatus status,
    required bool isFavorite,
    required bool inLibrary,
    double? rating,
    String? notes,
    DateTime? startedAt,
    DateTime? finishedAt,
    int? currentSeason,
    int? currentEpisode,
  }) async {
    final userId = _requireUserId();
    final payload = <String, dynamic>{
      'user_id': userId,
      'tmdb_id': tmdbId,
      'media_type': _mediaTypeToJson(mediaType),
      'status': _statusToJson(status),
      'is_favorite': isFavorite,
      'in_library': inLibrary,
      'rating': rating,
      'notes': notes,
      'started_at': startedAt?.toUtc().toIso8601String(),
      'finished_at': finishedAt?.toUtc().toIso8601String(),
      'current_season': currentSeason,
      'current_episode': currentEpisode,
    };

    try {
      final response = await _client
          .from('watch_entries')
          .upsert(payload, onConflict: 'user_id,tmdb_id,media_type')
          .select()
          .single();
      return WatchEntry.fromJson(response);
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }

  // ---------------------------------------------------------------------
  // Dışa aktarım (export) — bkz. WatchChronosExportService
  // ---------------------------------------------------------------------

  /// Dışa aktarım için kullanıcının TÜM `watch_entries` kayıtlarını döner.
  ///
  /// Kasıtlı olarak `in_library` durumundan BAĞIMSIZDIR: kütüphaneden
  /// kaldırılmış ama geçmişi/puanı korunan kayıtlar (bkz.
  /// [removeFromLibrary]) da export'a dahil edilir, aksi halde export
  /// "%100 eksiksiz" olamazdı.
  Future<List<WatchEntry>> getAllEntriesForExport() async {
    final userId = _requireUserId();
    try {
      final response = await _client
          .from('watch_entries')
          .select()
          .eq('user_id', userId);
      return response.map(WatchEntry.fromJson).toList();
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }

  /// Dışa aktarım için kullanıcının TÜM bölüm izleme kayıtlarını
  /// (`episode_logs`) tek seferde, `watch_entry_id`'ye göre gruplanmış
  /// olarak döner. [watchedEpisodesTotalCounts]'daki gibi: her dizi için
  /// ayrı sorgu atmak yerine (N dizi = N sorgu) tek bir toplu sorgu.
  Future<Map<String, List<ExportEpisodeLogRow>>>
  getAllEpisodeLogsForExport() async {
    final userId = _requireUserId();
    try {
      final response = await _client
          .from('episode_logs')
          .select('watch_entry_id, season_number, episode_number, watched_at')
          .eq('user_id', userId);
      final grouped = <String, List<ExportEpisodeLogRow>>{};
      for (final row in response) {
        final entryId = row['watch_entry_id'] as String;
        grouped
            .putIfAbsent(entryId, () => [])
            .add(
              ExportEpisodeLogRow(
                seasonNumber: row['season_number'] as int,
                episodeNumber: row['episode_number'] as int,
                watchedAt: DateTime.parse(row['watched_at'] as String),
              ),
            );
      }
      return grouped;
    } on PostgrestException catch (e) {
      throw WatchEntryErrorTranslator.fromPostgrestException(e);
    }
  }
}

/// [WatchEntriesRepository.getAllEpisodeLogsForExport] için ham satır.
/// Ayrı bir dosyaya/Freezed modeline gerek yok; sadece export servisine
/// veri taşıyan geçici bir yapı.
class ExportEpisodeLogRow {
  const ExportEpisodeLogRow({
    required this.seasonNumber,
    required this.episodeNumber,
    required this.watchedAt,
  });

  final int seasonNumber;
  final int episodeNumber;
  final DateTime watchedAt;
}

final watchEntriesRepositoryProvider = Provider<WatchEntriesRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return WatchEntriesRepository(client);
});

/// Supabase'in oturum durumu değişikliklerini (giriş/çıkış/kullanıcı
/// değişimi) dinler. [libraryEntriesStreamProvider] bunu izleyerek her
/// oturum değişiminde kendini otomatik olarak sıfırdan kurar.
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange;
});

/// Kütüphane ekranındaki tüm sekmelerin (Diziler, Filmler, Tamamlandı,
/// Favoriler) paylaştığı TEK realtime abonelik. Riverpod aynı provider'ı
/// izleyen birden çok widget için tek bir stream örneğini paylaştığından,
/// bu sekmeler artık her biri ayrı bir Supabase kanalı açıp aynı tabloyu
/// tekrar tekrar çekmek yerine bu tek kaynaktan client-side filtreleme
/// yapar. `keepAlive` ile kütüphane ekranından çıkılıp geri dönüldüğünde
/// abonelik sıfırdan kurulmaz.
///
/// ÖNEMLİ: `WatchEntriesRepository.libraryEntries()` çağrıldığı anda
/// oturum açmış bir kullanıcı yoksa senkron olarak hata fırlatır. Bu
/// provider eskiden doğrudan `repository.libraryEntries()`'i çağırıp
/// SADECE `signOut()` içindeki elle `invalidate` çağrısına güveniyordu;
/// eğer provider - kısa süreliğine de olsa - oturum tam oturmadan ÖNCE
/// (ör. giriş yaptıktan hemen sonraki bir yeniden çizimde) build edilirse
/// hataya düşüyor ve `keepAlive` sayesinde bu hata durumunda TAKILI
/// KALIYORDU: dil değiştirip çıkış/giriş yapılan senaryoda "bir şeyler
/// ters gitti" hatasının kalıcı görünmesinin sebebi buydu. Artık
/// [authStateChangesProvider]'ı izleyerek kullanıcı her değiştiğinde
/// (giriş/çıkış) kendini otomatik olarak yeniden kurar; kullanıcı yoksa
/// hata fırlatmak yerine boş bir liste döner.
final libraryEntriesStreamProvider =
    StreamProvider.autoDispose<List<WatchEntry>>((ref) {
      ref.keepAlive();
      final userId = ref.watch(
            authStateChangesProvider.select(
              // NOT: Bu proje Riverpod 3.x kullanıyor; o sürümde
              // `valueOrNull` kaldırıldı çünkü `value` artık zaten hata
              // durumunda (eskisi gibi hatayı yeniden fırlatmak yerine)
              // `null` dönüyor. Riverpod 2.x'te bu satır `valueOrNull`
              // olmalıydı.
              (state) => state.value?.session?.user.id,
            ),
          ) ??
          ref.watch(supabaseClientProvider).auth.currentUser?.id;

      if (userId == null) {
        return Stream<List<WatchEntry>>.value(const []);
      }

      final repository = ref.watch(watchEntriesRepositoryProvider);
      return repository.libraryEntries();
    });

/// Profil sekmesindeki istatistik kartları için tekil `FutureProvider`.
/// Önceden `_StatsSection` içinde `repository.getStats()` doğrudan
/// `build()`/`FutureBuilder` içinde çağrılıyordu; bu da profil sayfası
/// (avatar/kapak/kullanıcı adı değişince gelen realtime event ile) her
/// rebuild olduğunda -istatistiklerle hiç ilgisi olmasa bile- yeniden
/// sorgu atılmasına ve kısa süreliğine yükleniyor animasyonunun tekrar
/// görünmesine sebep oluyordu. `autoDispose` ile ekran açık olduğu
/// sürece sonuç önbellekte tutulur, sadece ilk açılışta veya
/// aşağı çekilip yenilendiğinde tekrar sorgulanır.
final watchEntryStatsProvider = FutureProvider.autoDispose<WatchEntryStats?>((
  ref,
) {
  final repository = ref.watch(watchEntriesRepositoryProvider);
  return repository.getStats();
});