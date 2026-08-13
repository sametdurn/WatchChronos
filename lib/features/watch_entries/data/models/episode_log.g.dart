// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EpisodeLog _$EpisodeLogFromJson(Map<String, dynamic> json) => _EpisodeLog(
  id: json['id'] as String,
  watchEntryId: json['watch_entry_id'] as String,
  userId: json['user_id'] as String,
  seasonNumber: (json['season_number'] as num).toInt(),
  episodeNumber: (json['episode_number'] as num).toInt(),
  watchedAt: DateTime.parse(json['watched_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$EpisodeLogToJson(_EpisodeLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'watch_entry_id': instance.watchEntryId,
      'user_id': instance.userId,
      'season_number': instance.seasonNumber,
      'episode_number': instance.episodeNumber,
      'watched_at': instance.watchedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
