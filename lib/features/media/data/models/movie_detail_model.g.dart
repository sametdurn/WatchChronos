// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MovieDetailModel _$MovieDetailModelFromJson(Map<String, dynamic> json) =>
    _MovieDetailModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String? ?? '',
      runtime: (json['runtime'] as num?)?.toInt() ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
      originalLanguage: json['original_language'] as String?,
      adult: json['adult'] as bool? ?? false,
      status: json['status'] as String? ?? '',
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GenreModel>[],
    );

Map<String, dynamic> _$MovieDetailModelToJson(_MovieDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'tagline': instance.tagline,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'release_date': instance.releaseDate,
      'runtime': instance.runtime,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'popularity': instance.popularity,
      'original_language': instance.originalLanguage,
      'adult': instance.adult,
      'status': instance.status,
      'genres': instance.genres.map((e) => e.toJson()).toList(),
    };
