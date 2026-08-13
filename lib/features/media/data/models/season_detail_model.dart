import 'package:freezed_annotation/freezed_annotation.dart';

import 'episode_model.dart';

part 'season_detail_model.freezed.dart';
part 'season_detail_model.g.dart';

@freezed
sealed class SeasonDetailModel with _$SeasonDetailModel {
  const factory SeasonDetailModel({
    required int id,
    @Default(0) int seasonNumber,
    @Default('') String name,
    @Default('') String overview,
    String? posterPath,
    String? airDate,
    @Default(<EpisodeModel>[]) List<EpisodeModel> episodes,
  }) = _SeasonDetailModel;

  factory SeasonDetailModel.fromJson(Map<String, dynamic> json) =>
      _$SeasonDetailModelFromJson(json);
}