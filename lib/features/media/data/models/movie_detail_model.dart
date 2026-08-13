import 'package:freezed_annotation/freezed_annotation.dart';

import 'genre_model.dart';

part 'movie_detail_model.freezed.dart';
part 'movie_detail_model.g.dart';

@freezed
sealed class MovieDetailModel with _$MovieDetailModel {
  const factory MovieDetailModel({
    required int id,
    @Default('') String title,
    @Default('') String originalTitle,
    @Default('') String overview,
    @Default('') String tagline,
    String? posterPath,
    String? backdropPath,
    @Default('') String releaseDate,
    @Default(0) int runtime,
    @Default(0) double voteAverage,
    @Default(0) int voteCount,
    @Default(0) double popularity,
    String? originalLanguage,
    @Default(false) bool adult,
    @Default('') String status,
    @Default(<GenreModel>[]) List<GenreModel> genres,
  }) = _MovieDetailModel;

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailModelFromJson(json);
}