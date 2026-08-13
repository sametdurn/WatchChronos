// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_season_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TvSeasonSummaryModel _$TvSeasonSummaryModelFromJson(
  Map<String, dynamic> json,
) => _TvSeasonSummaryModel(
  id: (json['id'] as num).toInt(),
  seasonNumber: (json['season_number'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  overview: json['overview'] as String? ?? '',
  posterPath: json['poster_path'] as String?,
  airDate: json['air_date'] as String?,
  episodeCount: (json['episode_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TvSeasonSummaryModelToJson(
  _TvSeasonSummaryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'season_number': instance.seasonNumber,
  'name': instance.name,
  'overview': instance.overview,
  'poster_path': instance.posterPath,
  'air_date': instance.airDate,
  'episode_count': instance.episodeCount,
};
