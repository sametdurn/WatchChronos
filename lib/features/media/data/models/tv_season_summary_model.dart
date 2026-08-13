import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_season_summary_model.freezed.dart';
part 'tv_season_summary_model.g.dart';

@freezed
sealed class TvSeasonSummaryModel with _$TvSeasonSummaryModel {
  const factory TvSeasonSummaryModel({
    required int id,
    @Default(0) int seasonNumber,
    @Default('') String name,
    @Default('') String overview,
    String? posterPath,
    String? airDate,
    @Default(0) int episodeCount,
  }) = _TvSeasonSummaryModel;

  factory TvSeasonSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$TvSeasonSummaryModelFromJson(json);
}