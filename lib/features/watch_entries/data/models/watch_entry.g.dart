// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WatchEntry _$WatchEntryFromJson(Map<String, dynamic> json) => _WatchEntry(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  tmdbId: (json['tmdb_id'] as num).toInt(),
  mediaType: $enumDecode(_$MediaTypeEnumMap, json['media_type']),
  status:
      $enumDecodeNullable(_$WatchStatusEnumMap, json['status']) ??
      WatchStatus.planned,
  isFavorite: json['is_favorite'] as bool? ?? false,
  favoritedAt: json['favorited_at'] == null
      ? null
      : DateTime.parse(json['favorited_at'] as String),
  inLibrary: json['in_library'] as bool? ?? true,
  rating: (json['rating'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  finishedAt: json['finished_at'] == null
      ? null
      : DateTime.parse(json['finished_at'] as String),
  currentSeason: (json['current_season'] as num?)?.toInt(),
  currentEpisode: (json['current_episode'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$WatchEntryToJson(_WatchEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'tmdb_id': instance.tmdbId,
      'media_type': _$MediaTypeEnumMap[instance.mediaType]!,
      'status': _$WatchStatusEnumMap[instance.status]!,
      'is_favorite': instance.isFavorite,
      'favorited_at': instance.favoritedAt?.toIso8601String(),
      'in_library': instance.inLibrary,
      'rating': instance.rating,
      'notes': instance.notes,
      'started_at': instance.startedAt?.toIso8601String(),
      'finished_at': instance.finishedAt?.toIso8601String(),
      'current_season': instance.currentSeason,
      'current_episode': instance.currentEpisode,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$MediaTypeEnumMap = {MediaType.movie: 'movie', MediaType.tv: 'tv'};

const _$WatchStatusEnumMap = {
  WatchStatus.planned: 'planned',
  WatchStatus.watching: 'watching',
  WatchStatus.completed: 'completed',
};
