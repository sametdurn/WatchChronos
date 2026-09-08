import '../../../core/cache/models/cached_media.dart';
import '../../watch_entries/data/models/watch_entry.dart';
import '../../watch_entries/data/models/watch_status.dart';
import 'tv_show_lifecycle.dart';

/// Bir dizinin "Diziler" sekmesi içindeki alt grubu ya da "Tamamlandı"
/// sekmesine ait olduğunu ifade eder.
enum TvLibrarySection {
  /// Hiç bölüm izlenmemiş.
  notStarted,

  /// İzlenmeye devam ediliyor (izlenecek bölüm var).
  watching,

  /// Dizi hâlâ devam ediyor/üretimde/planlanan/pilot AMA kullanıcı mevcut
  /// tüm bölümleri izlemiş; yeni bölüm bekleniyor.
  upcoming,

  /// Final yapmış veya iptal edilmiş VE kullanıcı tüm bölümleri izlemiş.
  completed,
}

/// Bir dizi kaydının hangi [TvLibrarySection]'a ait olduğunu hesaplar.
///
/// Bölüm sayısı TMDB'den gelen güncel `media.status` ve
/// `media.numberOfEpisodes` ile yeniden hesaplanır. Böylece:
/// - Final yapmış/iptal edilmiş bir dizi tüm bölümleri izlenene kadar
///   Diziler sekmesinde kalır.
/// - Tüm bölümleri izlenmiş final/iptal bir dizi Tamamlandı'ya düşer.
/// - Tamamlandı'dayken dizi yeniden çekilirse (TMDB status'ü
///   Returning Series/In Production/Planned/Pilot olursa) otomatik olarak
///   "Devamı Gelecek" alt grubuna, oradan da yeni bölüm izlenince
///   "İzleniyor"a geçer.
///
/// ÖNEMLİ: `watchedEpisodesCount >= totalEpisodes` karşılaştırması TMDB'nin
/// özel bölümleri (sezon 0) sayıma dahil edip etmemesi, sonradan eklenen/
/// kaldırılan bölümler gibi nedenlerle bazen hiç tutmayabilir. Ayrıca
/// `totalEpisodes` (media.numberOfEpisodes), TMDB onaylanan bir sonraki
/// sezonu bölümler yayınlanmadan ÖNCE sayıma katabildiği için de şişebilir.
/// Bu yüzden [reachedEndOfAiredEpisodes] — çağıran tarafın, kullanıcının
/// GERÇEKTEN YAYINLANMIŞ tüm bölümleri izleyip izlemediğini (bkz.
/// `aired_episodes.dart` ve kart üzerindeki "sıradaki bölüm" hesaplamasıyla
/// aynı tanım, `next_episode_calculator.dart`) hesaplayıp verdiği bayrak —
/// asıl belirleyicidir; `totalEpisodes` karşılaştırması sadece bu bilgi
/// hesaplanamadıysa (ör. çevrimdışı, ağ hatası) yedek olarak kullanılır.
/// Ayrıca kullanıcı diziyi (TV Time aktarımıyla ya da elle durum
/// seçiciden) açıkça "Tamamlandı" olarak işaretlemişse de doğrudan
/// tamamlanmış kabul edilir.
TvLibrarySection classifyTvEntry({
  required CachedMedia media,
  required WatchEntry entry,
  required int watchedEpisodesCount,
  bool reachedEndOfAiredEpisodes = false,
}) {
  final lifecycle = parseTvShowLifecycle(media.status);
  final totalEpisodes = media.numberOfEpisodes;
  final fullyWatched =
      entry.status == WatchStatus.completed ||
      reachedEndOfAiredEpisodes ||
      (totalEpisodes != null &&
          totalEpisodes > 0 &&
          watchedEpisodesCount >= totalEpisodes);

  if (fullyWatched) {
    return lifecycle.isFinished
        ? TvLibrarySection.completed
        : TvLibrarySection.upcoming;
  }

  // Final yapmış/iptal edilmiş olsa bile hâlâ izlenecek bölüm varsa
  // Diziler sekmesinde kalmaya devam eder.
  return entry.currentSeason == null
      ? TvLibrarySection.notStarted
      : TvLibrarySection.watching;
}
