// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_entry_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WatchEntryStats _$WatchEntryStatsFromJson(
  Map<String, dynamic> json,
) => _WatchEntryStats(
  userId: json['user_id'] as String,
  completedCount: (json['completed_count'] as num?)?.toInt() ?? 0,
  completedMoviesCount: (json['completed_movies_count'] as num?)?.toInt() ?? 0,
  completedTvCount: (json['completed_tv_count'] as num?)?.toInt() ?? 0,
  watchingCount: (json['watching_count'] as num?)?.toInt() ?? 0,
  plannedCount: (json['planned_count'] as num?)?.toInt() ?? 0,
  favoritesCount: (json['favorites_count'] as num?)?.toInt() ?? 0,
  averageRating: (json['average_rating'] as num?)?.toDouble(),
  episodesWatchedCount: (json['episodes_watched_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$WatchEntryStatsToJson(_WatchEntryStats instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'completed_count': instance.completedCount,
      'completed_movies_count': instance.completedMoviesCount,
      'completed_tv_count': instance.completedTvCount,
      'watching_count': instance.watchingCount,
      'planned_count': instance.plannedCount,
      'favorites_count': instance.favoritesCount,
      'average_rating': instance.averageRating,
      'episodes_watched_count': instance.episodesWatchedCount,
    };
