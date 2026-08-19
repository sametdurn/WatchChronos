import 'package:isar_community/isar.dart';

import '../../../features/watch_entries/data/models/media_type.dart';

part 'cached_media.g.dart';

@collection
class CachedMedia {
  Id id = Isar.autoIncrement;

  @Index(unique: true, composite: [CompositeIndex('mediaType')])
  late int tmdbId;

  @enumerated
  late MediaType mediaType;

  late String title;
  String? posterPath;
  String? backdropPath;
  String? overview;

  DateTime? releaseDate;
  DateTime? firstAirDate;

  double? voteAverage;

  int? runtimeMinutes;
  int? numberOfSeasons;
  int? numberOfEpisodes;

  /// TMDB'nin döndürdüğü ham `status` alanı (dizide "Returning Series",
  /// "Planned", "In Production", "Ended", "Canceled"...; filmde "Rumored",
  /// "Planned", "In Production", "Post Production", "Released"...). Bu alan
  /// kalıcı bir "tamamlandı"/"yayınlanmadı" bayrağı DEĞİLDİR — her medya
  /// yenilendiğinde TMDB'den gelen güncel değerle üzerine yazılır. Hangi
  /// sekmede gösterileceği her zaman bu alandan ANLIK olarak hesaplanır
  /// (bkz. features/media/domain/tv_show_lifecycle.dart ve
  /// features/media/domain/upcoming_classification.dart).
  String? status;

  List<String> genres = [];

  late DateTime cachedAt;
}