import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_response_model.freezed.dart';
part 'paginated_response_model.g.dart';

@Freezed(genericArgumentFactories: true)
sealed class PaginatedResponseModel<T> with _$PaginatedResponseModel<T> {
  const factory PaginatedResponseModel({
    required int page,
    required List<T> results,
    required int totalPages,
    required int totalResults,
  }) = _PaginatedResponseModel<T>;

  factory PaginatedResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginatedResponseModelFromJson(json, fromJsonT);
}