// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedResponseModel<T> _$PaginatedResponseModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _PaginatedResponseModel<T>(
  page: (json['page'] as num).toInt(),
  results: (json['results'] as List<dynamic>).map(fromJsonT).toList(),
  totalPages: (json['total_pages'] as num).toInt(),
  totalResults: (json['total_results'] as num).toInt(),
);

Map<String, dynamic> _$PaginatedResponseModelToJson<T>(
  _PaginatedResponseModel<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'page': instance.page,
  'results': instance.results.map(toJsonT).toList(),
  'total_pages': instance.totalPages,
  'total_results': instance.totalResults,
};
