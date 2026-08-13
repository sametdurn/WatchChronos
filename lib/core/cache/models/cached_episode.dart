import 'package:isar_community/isar.dart';

part 'cached_episode.g.dart';

@embedded
class CachedEpisode {
  int episodeNumber = 0;
  String? name;
  String? overview;
  String? stillPath;
  DateTime? airDate;
}