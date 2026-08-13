import 'package:freezed_annotation/freezed_annotation.dart';

enum MediaType {
  @JsonValue('movie')
  movie,
  @JsonValue('tv')
  tv,
}