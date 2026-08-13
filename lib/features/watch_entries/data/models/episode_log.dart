import 'package:freezed_annotation/freezed_annotation.dart';

part 'episode_log.freezed.dart';
part 'episode_log.g.dart';

@freezed
sealed class EpisodeLog with _$EpisodeLog {
  const factory EpisodeLog({
    required String id,
    @JsonKey(name: 'watch_entry_id') required String watchEntryId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'season_number') required int seasonNumber,
    @JsonKey(name: 'episode_number') required int episodeNumber,
    @JsonKey(name: 'watched_at') required DateTime watchedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _EpisodeLog;

  factory EpisodeLog.fromJson(Map<String, dynamic> json) =>
      _$EpisodeLogFromJson(json);
}