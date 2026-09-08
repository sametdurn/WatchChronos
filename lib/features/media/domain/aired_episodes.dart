import '../../../core/cache/models/cached_season.dart';

/// TMDB, onaylanan bir sonraki sezonun (hatta çoğu zaman mevcut sezonun
/// haftalık yayınlanan ileri tarihli bölümlerinin) sezon/bölüm sayfalarını
/// bölümler fiilen yayınlanmadan ÖNCE oluşturabiliyor. Bu yüzden bir sezonda
/// "gerçekten kaç bölüm var" sorusunun cevabı `season.episodes.length`
/// DEĞİL, `airDate`'i dolu ve geçmişte (ya da bugün) olan bölüm sayısıdır.
///
/// Örnek: Silo 4. sezon TMDB'de "duyurulduğu" an bir sezon nesnesi olarak
/// eklenip `numberOfSeasons`'ı 4'e çıkarabiliyor, hatta 1. bölümün adı/afişi
/// bilinse bile o bölüm henüz YAYINLANMAMIŞ olabiliyor. Ham bölüm sayısına
/// güvenen kodlar (bkz. eski `next_episode_calculator.dart` ve
/// `library_screen.dart`/`completed_grid_screen.dart`'taki final sezon
/// sayımı) bu durumda diziyi olduğundan ileri bir noktada izleniyor sanır.
int airedEpisodeCount(CachedSeason season, {DateTime? now}) {
  final referenceNow = now ?? DateTime.now();
  return season.episodes
      .where(
        (episode) =>
            episode.airDate != null && !episode.airDate!.isAfter(referenceNow),
      )
      .length;
}
