import 'package:isar_community/isar.dart';

import 'cached_episode.dart';

part 'cached_season.g.dart';

@collection
class CachedSeason {
  Id id = Isar.autoIncrement;

  @Index(unique: true, composite: [CompositeIndex('seasonNumber')])
  late int tvId;

  late int seasonNumber;

  List<CachedEpisode> episodes = [];

  late DateTime cachedAt;
}