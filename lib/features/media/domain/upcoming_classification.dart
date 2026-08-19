import '../../../core/cache/models/cached_media.dart';

/// TMDB'nin henüz tarih vermediği ama durumu ("status") üzerinden
/// yayınlanmadığı belli olan yapımlar için kullanılan durum kümeleri.
/// Örn. Cyberpunk: Edgerunners 2 gibi "In Production" bir dizinin henüz
/// `first_air_date`'i yoktur ama TMDB durumu bunun yayınlanmadığını zaten
/// söyler.
const _unreleasedTvStatuses = {'planned', 'in production', 'pilot'};
const _unreleasedMovieStatuses = {
  'rumored',
  'planned',
  'in production',
  'post production',
};

/// Bir dizinin TMDB'de henüz hiç bölümü yayınlanmamış (duyurulmuş/planlanan/
/// pilot aşamasında, ilk yayın tarihi gelecekte) olup olmadığını belirler.
/// "Yaklaşanlar" sekmesini Diziler sekmesindeki "Henüz Başlanmadı"
/// grubundan ayırmak için kullanılır: true dönerse dizi Yaklaşanlar'da,
/// false dönerse (yani yayınlanmışsa) normal Diziler sekmesinde gösterilir.
///
/// ÖNEMLİ: `firstAirDate` boşsa (TMDB'de eksik/kısıtlı bölgesel veri gibi
/// nedenlerle) dizi YAYINLANMIŞ kabul edilir — aksi halde ilk yayın tarihi
/// bilinmeyen ama aslında yıllar önce çıkmış diziler yanlışlıkla
/// Yaklaşanlar'da görünür. Tarih yokken tek istisna: TMDB "0 bölüm
/// yayınlandı" diyorsa (`numberOfEpisodes == 0`) ya da durumu açıkça
/// [_unreleasedTvStatuses] içindeyse (ör. "In Production", "Planned"),
/// dizi yine de yayınlanmamış sayılır.
bool isUnreleasedTv(CachedMedia media, {DateTime? now}) {
  final referenceNow = now ?? DateTime.now();
  final firstAirDate = media.firstAirDate;
  if (firstAirDate != null) {
    return !firstAirDate.isBefore(referenceNow);
  }
  if (media.numberOfEpisodes == 0) return true;
  final status = media.status?.toLowerCase().trim();
  return status != null && _unreleasedTvStatuses.contains(status);
}

/// Aynı mantığın filmler için karşılığı. `releaseDate` boşsa film
/// YAYINLANMIŞ kabul edilir (bkz. yukarıdaki not) — bilinen ve bugünden
/// ileri bir vizyon tarihi varsa, ya da durumu açıkça
/// [_unreleasedMovieStatuses] içindeyse (ör. "In Production", "Post
/// Production") film "henüz çıkmadı" sayılır.
bool isUnreleasedMovie(CachedMedia media, {DateTime? now}) {
  final referenceNow = now ?? DateTime.now();
  final releaseDate = media.releaseDate;
  if (releaseDate != null) {
    return !releaseDate.isBefore(referenceNow);
  }
  final status = media.status?.toLowerCase().trim();
  return status != null && _unreleasedMovieStatuses.contains(status);
}
