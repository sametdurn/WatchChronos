import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_show_model.freezed.dart';
part 'tv_show_model.g.dart';

@freezed
sealed class TvShowModel with _$TvShowModel {
  const factory TvShowModel({
    required int id,
    @Default('') String name,
    @Default('') String originalName,
    @Default('') String overview,
    String? posterPath,
    String? backdropPath,
    @Default('') String firstAirDate,
    @Default(0) double voteAverage,
    @Default(0) int voteCount,
    @Default(0) double popularity,
    String? originalLanguage,
    @Default(<String>[]) List<String> originCountry,
    @Default(<int>[]) List<int> genreIds,
  }) = _TvShowModel;

  factory TvShowModel.fromJson(Map<String, dynamic> json) =>
      _$TvShowModelFromJson(json);
}