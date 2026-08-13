import 'package:freezed_annotation/freezed_annotation.dart';

enum WatchStatus {
  @JsonValue('planned')
  planned,
  @JsonValue('watching')
  watching,
  @JsonValue('completed')
  completed,
}