import 'package:freezed_annotation/freezed_annotation.dart';

import 'genre_model.dart';
import 'tv_season_summary_model.dart';

part 'tv_detail_model.freezed.dart';
part 'tv_detail_model.g.dart';

@freezed
sealed class TvDetailModel with _$TvDetailModel {
  const factory TvDetailModel({
    required int id,
    @Default('') String name,
    @Default('') String originalName,
    @Default('') String overview,
    @Default('') String tagline,
    String? posterPath,
    String? backdropPath,
    @Default('') String firstAirDate,
    String? lastAirDate,
    @Default(0) int numberOfSeasons,
    @Default(0) int numberOfEpisodes,                                                                           
    @Default(0) double voteAverage,
    @Default(0) int voteCount,
    @Default(0) double popularity,
    String? originalLanguage,
    @Default('') String status,
    @Default(<GenreModel>[]) List<GenreModel> genres,
    @Default(<TvSeasonSummaryModel>[]) List<TvSeasonSummaryModel> seasons,
  }) = _TvDetailModel;

  factory TvDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TvDetailModelFromJson(json);
}                                                                                                                                 