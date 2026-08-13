// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EpisodeModel _$EpisodeModelFromJson(Map<String, dynamic> json) =>
    _EpisodeModel(
      id: (json['id'] as num).toInt(),
      episodeNumber: (json['episode_number'] as num?)?.toInt() ?? 0,
      seasonNumber: (json['season_number'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      stillPath: json['still_path'] as String?,
      airDate: json['air_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      runtime: (json['runtime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EpisodeModelToJson(_EpisodeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'episode_number': instance.episodeNumber,
      'season_number': instance.seasonNumber,
      'name': instance.name,
      'overview': instance.overview,
      'still_path': instance.stillPath,
      'air_date': instance.airDate,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'runtime': instance.runtime,
    };
