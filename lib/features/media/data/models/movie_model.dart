import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_model.freezed.dart';
part 'movie_model.g.dart';

@freezed
sealed class MovieModel with _$MovieModel {
  const factory MovieModel({
    required int id,
    @Default('') String title,
    @Default('') String originalTitle,
    @Default('') String overview,
    String? posterPath,
    String? backdropPath,
    @Default('') String releaseDate,
    @Default(0) double voteAverage,
    @Default(0) int voteCount,
    @Default(0) double popularity,
    String? originalLanguage,
    @Default(false) bool adult,
    @Default(<int>[]) List<int> genreIds,
  }) = _MovieModel;

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);
}