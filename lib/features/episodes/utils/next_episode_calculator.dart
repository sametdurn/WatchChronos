/// Bir bölüm izlendi olarak işaretlendikten sonra sıradaki bölümü hesaplayan
/// saf fonksiyon. Dış bağımlılığı yoktur, doğrudan test edilebilir.
///
/// Dizi tamamen bittiyse (`currentSeason == totalSeasons` ve
/// `currentEpisode == episodesInCurrentSeason`) `null` döner.
({int season, int episode})? computeNextEpisode({
  required int currentSeason,
  required int currentEpisode,
  required int episodesInCurrentSeason,
  required int totalSeasons,
}) {
  if (currentEpisode < episodesInCurrentSeason) {
    return (season: currentSeason, episode: currentEpisode + 1);
  }
  if (currentSeason < totalSeasons) {
    return (season: currentSeason + 1, episode: 1);
  }
  return null;
}
