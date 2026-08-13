// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginatedResponseModel<T> {

 int get page; List<T> get results; int get totalPages; int get totalResults;
/// Create a copy of PaginatedResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedResponseModelCopyWith<T, PaginatedResponseModel<T>> get copyWith => _$PaginatedResponseModelCopyWithImpl<T, PaginatedResponseModel<T>>(this as PaginatedResponseModel<T>, _$identity);

  /// Serializes this PaginatedResponseModel to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedResponseModel<T>&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(results),totalPages,totalResults);

@override
String toString() {
  return 'PaginatedResponseModel<$T>(page: $page, results: $results, totalPages: $totalPages, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class $PaginatedResponseModelCopyWith<T,$Res>  {
  factory $PaginatedResponseModelCopyWith(PaginatedResponseModel<T> value, $Res Function(PaginatedResponseModel<T>) _then) = _$PaginatedResponseModelCopyWithImpl;
@useResult
$Res call({
 int page, List<T> results, int totalPages, int totalResults
});




}
/// @nodoc
class _$PaginatedResponseModelCopyWithImpl<T,$Res>
    implements $PaginatedResponseModelCopyWith<T, $Res> {
  _$PaginatedResponseModelCopyWithImpl(this._self, this._then);

  final PaginatedResponseModel<T> _self;
  final $Res Function(PaginatedResponseModel<T>) _then;

/// Create a copy of PaginatedResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? results = null,Object? totalPages = null,Object? totalResults = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<T>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedResponseModel].
extension PaginatedResponseModelPatterns<T> on PaginatedResponseModel<T> {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedResponseModel<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedResponseModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedResponseModel<T> value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedResponseModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedResponseModel<T> value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedResponseModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  List<T> results,  int totalPages,  int totalResults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedResponseModel() when $default != null:
return $default(_that.page,_that.results,_that.totalPages,_that.totalResults);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  List<T> results,  int totalPages,  int totalResults)  $default,) {final _that = this;
switch (_that) {
case _PaginatedResponseModel():
return $default(_that.page,_that.results,_that.totalPages,_that.totalResults);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  List<T> results,  int totalPages,  int totalResults)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedResponseModel() when $default != null:
return $default(_that.page,_that.results,_that.totalPages,_that.totalResults);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _PaginatedResponseModel<T> implements PaginatedResponseModel<T> {
  const _PaginatedResponseModel({required this.page, required final  List<T> results, required this.totalPages, required this.totalResults}): _results = results;
  factory _PaginatedResponseModel.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$PaginatedResponseModelFromJson(json,fromJsonT);

@override final  int page;
 final  List<T> _results;
@override List<T> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override final  int totalPages;
@override final  int totalResults;

/// Create a copy of PaginatedResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedResponseModelCopyWith<T, _PaginatedResponseModel<T>> get copyWith => __$PaginatedResponseModelCopyWithImpl<T, _PaginatedResponseModel<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$PaginatedResponseModelToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedResponseModel<T>&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(_results),totalPages,totalResults);

@override
String toString() {
  return 'PaginatedResponseModel<$T>(page: $page, results: $results, totalPages: $totalPages, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class _$PaginatedResponseModelCopyWith<T,$Res> implements $PaginatedResponseModelCopyWith<T, $Res> {
  factory _$PaginatedResponseModelCopyWith(_PaginatedResponseModel<T> value, $Res Function(_PaginatedResponseModel<T>) _then) = __$PaginatedResponseModelCopyWithImpl;
@override @useResult
$Res call({
 int page, List<T> results, int totalPages, int totalResults
});




}
/// @nodoc
class __$PaginatedResponseModelCopyWithImpl<T,$Res>
    implements _$PaginatedResponseModelCopyWith<T, $Res> {
  __$PaginatedResponseModelCopyWithImpl(this._self, this._then);

  final _PaginatedResponseModel<T> _self;
  final $Res Function(_PaginatedResponseModel<T>) _then;

/// Create a copy of PaginatedResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? results = null,Object? totalPages = null,Object? totalResults = null,}) {
  return _then(_PaginatedResponseModel<T>(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<T>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
