import 'package:freezed_annotation/freezed_annotation.dart';

import 'media_type.dart';
import 'watch_status.dart';

part 'watch_entry.freezed.dart';
part 'watch_entry.g.dart';

@freezed
sealed class WatchEntry with _$WatchEntry {
  const factory WatchEntry({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'tmdb_id') required int tmdbId,
    @JsonKey(name: 'media_type') required MediaType mediaType,
    @Default(WatchStatus.planned) WatchStatus status,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
    // `is_favorite` FALSE'tan TRUE'ya her geçtiğinde bir DB trigger'ı
    // (bkz. 20260805120000_watch_entries_favorited_at.sql migration'ı)
    // tarafından otomatik doldurulur; favori KALDIĞI sürece (başka bir alan
    // güncellense bile) DEĞİŞMEZ. Bu yüzden Favoriler sekmesinde/grid'inde
    // "en son favorilenen üstte" sıralaması için `updated_at` DEĞİL bu alan
    // kullanılır (`updated_at` favori dışı bir değişiklikte de güncellenir,
    // bu da sıralamayı yanlış yapardı). Migration öncesi favorilenmiş eski
    // kayıtlarda bu alan migration'ın kendisi tarafından `updated_at`'e
    // yaklaşık olarak dolduruldu; hâlâ `null` gelme ihtimaline karşı
    // sıralama tarafında yine de `updatedAt`'e düşülüyor.
    @JsonKey(name: 'favorited_at') DateTime? favoritedAt,
    // Kütüphaneden kaldırılan kayıtlar SİLİNMEZ (izlenme geçmişi/rating
    // korunsun diye); sadece bu bayrak false yapılır. Kütüphane listeleri
    // (Diziler/Filmler/Tamamlandı/Favoriler) hep `inLibrary == true` olan
    // kayıtları gösterir; `getEntry` (detay sayfası) ise bu bayraktan
    // bağımsız çalışır ki kaldırılmış bir kayda ait geçmiş yine görülebilsin.
    @JsonKey(name: 'in_library') @Default(true) bool inLibrary,
    double? rating,
    String? notes,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'finished_at') DateTime? finishedAt,
    @JsonKey(name: 'current_season') int? currentSeason,
    @JsonKey(name: 'current_episode') int? currentEpisode,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _WatchEntry;

  /// [fromJson]'ın DB'den gelen ham JSON'u parse etmeden önceki güvenlik
  /// adımı. `dropped` ve `on_hold` durumları uygulamadan tamamen kaldırıldı
  /// (bkz. `20260719120000_remove_dropped_status.sql` ve
  /// `20260806_remove_on_hold_status.sql` migration'ları), ama bu
  /// migration'lar Supabase projesinde henüz ÇALIŞTIRILMAMIŞSA veritabanında
  /// hâlâ `status = 'dropped'` / `status = 'on_hold'` olan eski satırlar
  /// olabilir. `WatchStatus` enum'unda artık böyle değerler olmadığından bu
  /// satırları olduğu gibi parse etmeye çalışmak (`$enumDecodeNullable`) bir
  /// hata fırlatıp tüm listeyi/ekranı çökertir. Bunun yerine görürsek
  /// sessizce `watching`e çeviriyoruz — DB migration'ları çalıştırıldığında
  /// zaten kalıcı olarak aynı dönüşüm olacak, burası sadece migration'lar
  /// çalışana kadarki ara dönem için bir güvenlik ağı.
  static Map<String, dynamic> _sanitizeLegacyStatus(Map<String, dynamic> json) {
    if (json['status'] == 'dropped' || json['status'] == 'on_hold') {
      return {...json, 'status': 'watching'};
    }
    return json;
  }

  factory WatchEntry.fromJson(Map<String, dynamic> json) =>
      _$WatchEntryFromJson(_sanitizeLegacyStatus(json));
}