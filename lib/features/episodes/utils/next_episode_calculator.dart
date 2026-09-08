/// Bir bölüm izlendi olarak işaretlendikten sonra sıradaki bölümü hesaplayan
/// saf fonksiyon. Dış bağımlılığı yoktur, doğrudan test edilebilir.
///
/// Dizi tamamen bittiyse (`currentSeason == totalSeasons` ve
/// `currentEpisode == episodesInCurrentSeason`) `null` döner.
///
/// [episodesInCurrentSeason] mevcut sezonun *yayınlanmış* bölüm sayısı
/// olmalıdır (bkz. `aired_episodes.dart`), ham `episodes.length` değil —
/// aksi halde haftalık yayınlanan bir dizide TMDB'nin önceden listelediği
/// gelecek tarihli bölümler zaten izlenmiş sanılabilir.
///
/// [episodesAiredInNextSeason], sıradaki sezona geçilmesi gerektiğinde
/// (`currentSeason < totalSeasons`) o sezonun kaç bölümünün fiilen
/// yayınlandığını bilen çağıran taraf tarafından verilir. TMDB, onaylanan
/// bir sonraki sezonun sezon nesnesini (dolayısıyla `numberOfSeasons`'ı)
/// bölümler yayınlanmadan ÖNCE oluşturabildiğinden, sadece sezon sayısına
/// bakıp ilerlemek "4. Sezon 1. Bölüm" gibi henüz çıkmamış bir bölümü
/// sıradaki bölüm olarak göstermeye yol açar. Bu bilgi yoksa (`null`,
/// örn. çağıran taraf kontrol etmediyse) eski davranış korunur.
({int season, int episode})? computeNextEpisode({
  required int currentSeason,
  required int currentEpisode,
  required int episodesInCurrentSeason,
  required int totalSeasons,
  int? episodesAiredInNextSeason,
}) {
  if (currentEpisode < episodesInCurrentSeason) {
    return (season: currentSeason, episode: currentEpisode + 1);
  }
  if (currentSeason < totalSeasons) {
    if (episodesAiredInNextSeason != null && episodesAiredInNextSeason <= 0) {
      // Sıradaki sezon TMDB'de "var" görünüyor ama fiilen hiç bölümü
      // yayınlanmamış; kullanıcı hâlâ mevcut (yayınlanmış) sezonun sonunda
      // sayılır, ileri gidilmez.
      return null;
    }
    return (season: currentSeason + 1, episode: 1);
  }
  return null;
}
