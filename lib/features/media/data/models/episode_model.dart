import 'package:freezed_annotation/freezed_annotation.dart';

part 'episode_model.freezed.dart';
part 'episode_model.g.dart';

@freezed
sealed class EpisodeModel with _$EpisodeModel {
  const factory EpisodeModel({
    required int id,
    @Default(0) int episodeNumber,
    @Default(0) int seasonNumber,
    @Default('') String name,
    @Default('') String overview,
    String? stillPath,
    String? airDate,
    @Default(0) double voteAverage,
    @Default(0) int voteCount,
    int? runtime,
  }) = _EpisodeModel;

  factory EpisodeModel.fromJson(Map<String, dynamic> json) =>
      _$EpisodeModelFromJson(json);
}