// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_season_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TvSeasonSummaryModel {

 int get id; int get seasonNumber; String get name; String get overview; String? get posterPath; String? get airDate; int get episodeCount;
/// Create a copy of TvSeasonSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvSeasonSummaryModelCopyWith<TvSeasonSummaryModel> get copyWith => _$TvSeasonSummaryModelCopyWithImpl<TvSeasonSummaryModel>(this as TvSeasonSummaryModel, _$identity);

  /// Serializes this TvSeasonSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvSeasonSummaryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.airDate, airDate) || other.airDate == airDate)&&(identical(other.episodeCount, episodeCount) || other.episodeCount == episodeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonNumber,name,overview,posterPath,airDate,episodeCount);

@override
String toString() {
  return 'TvSeasonSummaryModel(id: $id, seasonNumber: $seasonNumber, name: $name, overview: $overview, posterPath: $posterPath, airDate: $airDate, episodeCount: $episodeCount)';
}


}

/// @nodoc
abstract mixin class $TvSeasonSummaryModelCopyWith<$Res>  {
  factory $TvSeasonSummaryModelCopyWith(TvSeasonSummaryModel value, $Res Function(TvSeasonSummaryModel) _then) = _$TvSeasonSummaryModelCopyWithImpl;
@useResult
$Res call({
 int id, int seasonNumber, String name, String overview, String? posterPath, String? airDate, int episodeCount
});




}
/// @nodoc
class _$TvSeasonSummaryModelCopyWithImpl<$Res>
    implements $TvSeasonSummaryModelCopyWith<$Res> {
  _$TvSeasonSummaryModelCopyWithImpl(this._self, this._then);

  final TvSeasonSummaryModel _self;
  final $Res Function(TvSeasonSummaryModel) _then;

/// Create a copy of TvSeasonSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seasonNumber = null,Object? name = null,Object? overview = null,Object? posterPath = freezed,Object? airDate = freezed,Object? episodeCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,episodeCount: null == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TvSeasonSummaryModel].
extension TvSeasonSummaryModelPatterns on TvSeasonSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvSeasonSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvSeasonSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvSeasonSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _TvSeasonSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvSeasonSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _TvSeasonSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int seasonNumber,  String name,  String overview,  String? posterPath,  String? airDate,  int episodeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvSeasonSummaryModel() when $default != null:
return $default(_that.id,_that.seasonNumber,_that.name,_that.overview,_that.posterPath,_that.airDate,_that.episodeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int seasonNumber,  String name,  String overview,  String? posterPath,  String? airDate,  int episodeCount)  $default,) {final _that = this;
switch (_that) {
case _TvSeasonSummaryModel():
return $default(_that.id,_that.seasonNumber,_that.name,_that.overview,_that.posterPath,_that.airDate,_that.episodeCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int seasonNumber,  String name,  String overview,  String? posterPath,  String? airDate,  int episodeCount)?  $default,) {final _that = this;
switch (_that) {
case _TvSeasonSummaryModel() when $default != null:
return $default(_that.id,_that.seasonNumber,_that.name,_that.overview,_that.posterPath,_that.airDate,_that.episodeCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TvSeasonSummaryModel implements TvSeasonSummaryModel {
  const _TvSeasonSummaryModel({required this.id, this.seasonNumber = 0, this.name = '', this.overview = '', this.posterPath, this.airDate, this.episodeCount = 0});
  factory _TvSeasonSummaryModel.fromJson(Map<String, dynamic> json) => _$TvSeasonSummaryModelFromJson(json);

@override final  int id;
@override@JsonKey() final  int seasonNumber;
@override@JsonKey() final  String name;
@override@JsonKey() final  String overview;
@override final  String? posterPath;
@override final  String? airDate;
@override@JsonKey() final  int episodeCount;

/// Create a copy of TvSeasonSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvSeasonSummaryModelCopyWith<_TvSeasonSummaryModel> get copyWith => __$TvSeasonSummaryModelCopyWithImpl<_TvSeasonSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TvSeasonSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvSeasonSummaryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.airDate, airDate) || other.airDate == airDate)&&(identical(other.episodeCount, episodeCount) || other.episodeCount == episodeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonNumber,name,overview,posterPath,airDate,episodeCount);

@override
String toString() {
  return 'TvSeasonSummaryModel(id: $id, seasonNumber: $seasonNumber, name: $name, overview: $overview, posterPath: $posterPath, airDate: $airDate, episodeCount: $episodeCount)';
}


}

/// @nodoc
abstract mixin class _$TvSeasonSummaryModelCopyWith<$Res> implements $TvSeasonSummaryModelCopyWith<$Res> {
  factory _$TvSeasonSummaryModelCopyWith(_TvSeasonSummaryModel value, $Res Function(_TvSeasonSummaryModel) _then) = __$TvSeasonSummaryModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int seasonNumber, String name, String overview, String? posterPath, String? airDate, int episodeCount
});




}
/// @nodoc
class __$TvSeasonSummaryModelCopyWithImpl<$Res>
    implements _$TvSeasonSummaryModelCopyWith<$Res> {
  __$TvSeasonSummaryModelCopyWithImpl(this._self, this._then);

  final _TvSeasonSummaryModel _self;
  final $Res Function(_TvSeasonSummaryModel) _then;

/// Create a copy of TvSeasonSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seasonNumber = null,Object? name = null,Object? overview = null,Object? posterPath = freezed,Object? airDate = freezed,Object? episodeCount = null,}) {
  return _then(_TvSeasonSummaryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,episodeCount: null == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
