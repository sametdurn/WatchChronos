import 'package:freezed_annotation/freezed_annotation.dart';

part 'watch_entry_stats.freezed.dart';
part 'watch_entry_stats.g.dart';

@freezed
sealed class WatchEntryStats with _$WatchEntryStats {
  const factory WatchEntryStats({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'completed_count') @Default(0) int completedCount,
    @JsonKey(name: 'completed_movies_count')
    @Default(0)
    int completedMoviesCount,
    @JsonKey(name: 'completed_tv_count') @Default(0) int completedTvCount,
    @JsonKey(name: 'watching_count') @Default(0) int watchingCount,
    @JsonKey(name: 'planned_count') @Default(0) int plannedCount,
    @JsonKey(name: 'favorites_count') @Default(0) int favoritesCount,
    @JsonKey(name: 'average_rating') double? averageRating,
    @JsonKey(name: 'episodes_watched_count')
    @Default(0)
    int episodesWatchedCount,
  }) = _WatchEntryStats;

  factory WatchEntryStats.fromJson(Map<String, dynamic> json) =>
      _$WatchEntryStatsFromJson(json);
}