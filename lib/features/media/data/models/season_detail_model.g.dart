// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SeasonDetailModel _$SeasonDetailModelFromJson(Map<String, dynamic> json) =>
    _SeasonDetailModel(
      id: (json['id'] as num).toInt(),
      seasonNumber: (json['season_number'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      airDate: json['air_date'] as String?,
      episodes:
          (json['episodes'] as List<dynamic>?)
              ?.map((e) => EpisodeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <EpisodeModel>[],
    );

Map<String, dynamic> _$SeasonDetailModelToJson(_SeasonDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'season_number': instance.seasonNumber,
      'name': instance.name,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'air_date': instance.airDate,
      'episodes': instance.episodes.map((e) => e.toJson()).toList(),
    };
