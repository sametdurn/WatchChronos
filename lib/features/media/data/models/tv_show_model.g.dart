// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_show_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TvShowModel _$TvShowModelFromJson(Map<String, dynamic> json) => _TvShowModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String? ?? '',
  originalName: json['original_name'] as String? ?? '',
  overview: json['overview'] as String? ?? '',
  posterPath: json['poster_path'] as String?,
  backdropPath: json['backdrop_path'] as String?,
  firstAirDate: json['first_air_date'] as String? ?? '',
  voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
  voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
  popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
  originalLanguage: json['original_language'] as String?,
  originCountry:
      (json['origin_country'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  genreIds:
      (json['genre_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
);

Map<String, dynamic> _$TvShowModelToJson(_TvShowModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'original_name': instance.originalName,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'first_air_date': instance.firstAirDate,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'popularity': instance.popularity,
      'original_language': instance.originalLanguage,
      'origin_country': instance.originCountry,
      'genre_ids': instance.genreIds,
    };
