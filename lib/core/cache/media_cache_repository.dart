import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';

import '../../features/watch_entries/data/models/media_type.dart';
import 'isar_service.dart';
import 'models/cached_media.dart';
import 'models/cached_season.dart';

class MediaCacheRepository {
  MediaCacheRepository(this._isar);

  final Isar _isar;

  Future<CachedMedia?> getMedia({
    required int tmdbId,
    required MediaType mediaType,
  }) {
    return _isar.cachedMedias
        .filter()
        .tmdbIdEqualTo(tmdbId)
        .mediaTypeEqualTo(mediaType)
        .findFirst();
  }

  /// ÖNEMLİİ: Önce ayrı bir sorguyla "var mı" bakıp SONRA ayrı bir
  /// transaction'da yazmak (eskiden burada olduğu gibi) bir yarış durumu
  /// (race condition) yaratıyordu: aynı dizi/film neredeyse aynı anda
  /// birden fazla yerden istenirse (ör. kütüphane listesi + her kartın
  /// kendi sağlayıcısı), iki çağrı da "kayıt yok" görüp `tmdbId` için AYRI
  /// iki satır eklemeye çalışabiliyor; `tmdbId`+`mediaType` üzerindeki
  /// tekil (unique) indeks bunu reddedip `IsarError: Unique index
  /// violated` ile uygulamayı çökertiyordu. Kontrol + yazma artık TEK bir
  /// `writeTxn` içinde yapılıyor; Isar'da yazma transaction'ları ardışık
  /// (birbiriyle çakışmadan) çalıştığı için bu, işlemi atomik hale getirip
  /// yarış durumunu ortadan kaldırıyor.
  Future<void> upsertMedia(CachedMedia media) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.cachedMedias
          .filter()
          .tmdbIdEqualTo(media.tmdbId)
          .mediaTypeEqualTo(media.mediaType)
          .findFirst();
      if (existing != null) {
        media.id = existing.id;
      }
      await _isar.cachedMedias.put(media);
    });
  }

  Future<CachedSeason?> getSeason({
    required int tvId,
    required int seasonNumber,
  }) {
    return _isar.cachedSeasons
        .filter()
        .tvIdEqualTo(tvId)
        .seasonNumberEqualTo(seasonNumber)
        .findFirst();
  }

  /// Aynı yarış durumu düzeltmesi `upsertMedia` için de geçerli — bkz. o
  /// metodun üzerindeki not.
  Future<void> upsertSeason(CachedSeason season) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.cachedSeasons
          .filter()
          .tvIdEqualTo(season.tvId)
          .seasonNumberEqualTo(season.seasonNumber)
          .findFirst();
      if (existing != null) {
        season.id = existing.id;
      }
      await _isar.cachedSeasons.put(season);
    });
  }

  bool isStale(DateTime cachedAt, {Duration maxAge = const Duration(days: 7)}) {
    return DateTime.now().difference(cachedAt) > maxAge;
  }

  /// Önbelleğe alınmış TÜM film/dizi detaylarını ve sezon/bölüm bilgilerini
  /// siler.
  ///
  /// `CachedMedia`/`CachedSeason` kayıtları hangi dilde çekildiğini ayrıca
  /// SAKLAMIYOR (tek bir `title`/`name` alanı var); bu yüzden kullanıcı
  /// uygulama dilini değiştirdiğinde eski dildeki başlıklar 7 günlük
  /// "taze" sayılma süresi dolana kadar ekranda kalmaya devam ederdi. Dil
  /// değişince bu metod çağrılarak önbellek tamamen temizlenir, böylece
  /// bir sonraki görüntülemede içerik doğrudan TMDB'den YENİ dille tekrar
  /// çekilir.
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.cachedMedias.clear();
      await _isar.cachedSeasons.clear();
    });
  }
}

final mediaCacheRepositoryProvider = Provider<MediaCacheRepository>((ref) {
  return MediaCacheRepository(ref.watch(isarProvider));
});