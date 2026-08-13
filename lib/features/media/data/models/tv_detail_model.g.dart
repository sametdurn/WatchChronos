// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TvDetailModel _$TvDetailModelFromJson(Map<String, dynamic> json) =>
    _TvDetailModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      firstAirDate: json['first_air_date'] as String? ?? '',
      lastAirDate: json['last_air_date'] as String?,
      numberOfSeasons: (json['number_of_seasons'] as num?)?.toInt() ?? 0,
      numberOfEpisodes: (json['number_of_episodes'] as num?)?.toInt() ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
      originalLanguage: json['original_language'] as String?,
      status: json['status'] as String? ?? '',
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GenreModel>[],
      seasons:
          (json['seasons'] as List<dynamic>?)
              ?.map(
                (e) => TvSeasonSummaryModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <TvSeasonSummaryModel>[],
    );

Map<String, dynamic> _$TvDetailModelToJson(_TvDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'original_name': instance.originalName,
      'overview': instance.overview,
      'tagline': instance.tagline,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'first_air_date': instance.firstAirDate,
      'last_air_date': instance.lastAirDate,
      'number_of_seasons': instance.numberOfSeasons,
      'number_of_episodes': instance.numberOfEpisodes,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'popularity': instance.popularity,
      'original_language': instance.originalLanguage,
      'status': instance.status,
      'genres': instance.genres.map((e) => e.toJson()).toList(),
      'seasons': instance.seasons.map((e) => e.toJson()).toList(),
    };
