// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => _MovieModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String? ?? '',
  originalTitle: json['original_title'] as String? ?? '',
  overview: json['overview'] as String? ?? '',
  posterPath: json['poster_path'] as String?,
  backdropPath: json['backdrop_path'] as String?,
  releaseDate: json['release_date'] as String? ?? '',
  voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
  voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
  popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
  originalLanguage: json['original_language'] as String?,
  adult: json['adult'] as bool? ?? false,
  genreIds:
      (json['genre_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
);

Map<String, dynamic> _$MovieModelToJson(_MovieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'release_date': instance.releaseDate,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'popularity': instance.popularity,
      'original_language': instance.originalLanguage,
      'adult': instance.adult,
      'genre_ids': instance.genreIds,
    };
