import '../data/media_repository.dart';
import 'aired_episodes.dart';

/// Kullanıcının, bir dizinin `currentSeason`/`currentEpisode` ile
/// işaretlenen konumundan itibaren, TMDB'de fiilen YAYINLANMIŞ tüm
/// bölümleri izleyip izlemediğini hesaplar. Bkz. `tv_entry_classification.dart`
/// içindeki `reachedEndOfAiredEpisodes` parametresi ve
/// `next_episode_calculator.dart` — ikisi de aynı tanımı paylaşır.
///
/// Yaygın durum: kullanıcının `currentSeason`'ı, TMDB'nin bildirdiği son
/// sezondan (`numberOfSeasons`) tam olarak bir geride. Bu, ya kullanıcı
/// gerçekten bir sonraki sezona henüz geçmediği (normal "İzleniyor" durumu)
/// ya da TMDB'nin onaylanan yeni sezonu bölümler yayınlanmadan ÖNCE sezon
/// nesnesi olarak eklediği (bu durumda kullanıcı fiilen dizinin sonundadır,
/// "Devamı Gelecek"e düşmeli) anlamına gelebilir. Bu iki durumu ayırt etmek
/// için o "sonraki" sezonun gerçekten hiç bölümü yayınlanıp yayınlanmadığına
/// bakılır.
Future<bool> hasReachedEndOfAiredTvEpisodes({
  required int tmdbId,
  required int? currentSeason,
  required int? currentEpisode,
  required int? numberOfSeasons,
  required MediaRepository mediaRepository,
}) async {
  final declaredFinalSeason = numberOfSeasons;
  if (currentSeason == null ||
      currentEpisode == null ||
      declaredFinalSeason == null) {
    return false;
  }

  Future<int?> airedCountOf(int seasonNumber) async {
    try {
      final season = await mediaRepository.getSeasonDetail(
        tvId: tmdbId,
        seasonNumber: seasonNumber,
      );
      return airedEpisodeCount(season);
    } catch (_) {
      return null;
    }
  }

  if (currentSeason == declaredFinalSeason) {
    final aired = await airedCountOf(currentSeason);
    return aired != null && aired > 0 && currentEpisode >= aired;
  }

  if (currentSeason == declaredFinalSeason - 1) {
    final nextAired = await airedCountOf(declaredFinalSeason);
    if (nextAired != null && nextAired > 0) {
      // Sonraki sezon gerçekten başlamış; kullanıcı henüz ona geçmedi,
      // normal "İzleniyor" durumu.
      return false;
    }
    // Sonraki sezon TMDB'de "var" ama hiç bölümü yayınlanmamış: kullanıcı
    // fiilen son yayınlanan sezondadır.
    final aired = await airedCountOf(currentSeason);
    return aired != null && aired > 0 && currentEpisode >= aired;
  }

  // Kullanıcı iki veya daha fazla sezon geride (ör. henüz izlemeye devam
  // ediyor); bu fonksiyonun kapsamı dışında, normal akışa bırakılır.
  return false;
}
