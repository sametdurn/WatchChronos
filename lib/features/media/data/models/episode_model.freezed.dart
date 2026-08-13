// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EpisodeModel {

 int get id; int get episodeNumber; int get seasonNumber; String get name; String get overview; String? get stillPath; String? get airDate; double get voteAverage; int get voteCount; int? get runtime;
/// Create a copy of EpisodeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeModelCopyWith<EpisodeModel> get copyWith => _$EpisodeModelCopyWithImpl<EpisodeModel>(this as EpisodeModel, _$identity);

  /// Serializes this EpisodeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpisodeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.stillPath, stillPath) || other.stillPath == stillPath)&&(identical(other.airDate, airDate) || other.airDate == airDate)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.runtime, runtime) || other.runtime == runtime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,episodeNumber,seasonNumber,name,overview,stillPath,airDate,voteAverage,voteCount,runtime);

@override
String toString() {
  return 'EpisodeModel(id: $id, episodeNumber: $episodeNumber, seasonNumber: $seasonNumber, name: $name, overview: $overview, stillPath: $stillPath, airDate: $airDate, voteAverage: $voteAverage, voteCount: $voteCount, runtime: $runtime)';
}


}

/// @nodoc
abstract mixin class $EpisodeModelCopyWith<$Res>  {
  factory $EpisodeModelCopyWith(EpisodeModel value, $Res Function(EpisodeModel) _then) = _$EpisodeModelCopyWithImpl;
@useResult
$Res call({
 int id, int episodeNumber, int seasonNumber, String name, String overview, String? stillPath, String? airDate, double voteAverage, int voteCount, int? runtime
});




}
/// @nodoc
class _$EpisodeModelCopyWithImpl<$Res>
    implements $EpisodeModelCopyWith<$Res> {
  _$EpisodeModelCopyWithImpl(this._self, this._then);

  final EpisodeModel _self;
  final $Res Function(EpisodeModel) _then;

/// Create a copy of EpisodeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? episodeNumber = null,Object? seasonNumber = null,Object? name = null,Object? overview = null,Object? stillPath = freezed,Object? airDate = freezed,Object? voteAverage = null,Object? voteCount = null,Object? runtime = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,stillPath: freezed == stillPath ? _self.stillPath : stillPath // ignore: cast_nullable_to_non_nullable
as String?,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [EpisodeModel].
extension EpisodeModelPatterns on EpisodeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpisodeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpisodeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpisodeModel value)  $default,){
final _that = this;
switch (_that) {
case _EpisodeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpisodeModel value)?  $default,){
final _that = this;
switch (_that) {
case _EpisodeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int episodeNumber,  int seasonNumber,  String name,  String overview,  String? stillPath,  String? airDate,  double voteAverage,  int voteCount,  int? runtime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpisodeModel() when $default != null:
return $default(_that.id,_that.episodeNumber,_that.seasonNumber,_that.name,_that.overview,_that.stillPath,_that.airDate,_that.voteAverage,_that.voteCount,_that.runtime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int episodeNumber,  int seasonNumber,  String name,  String overview,  String? stillPath,  String? airDate,  double voteAverage,  int voteCount,  int? runtime)  $default,) {final _that = this;
switch (_that) {
case _EpisodeModel():
return $default(_that.id,_that.episodeNumber,_that.seasonNumber,_that.name,_that.overview,_that.stillPath,_that.airDate,_that.voteAverage,_that.voteCount,_that.runtime);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int episodeNumber,  int seasonNumber,  String name,  String overview,  String? stillPath,  String? airDate,  double voteAverage,  int voteCount,  int? runtime)?  $default,) {final _that = this;
switch (_that) {
case _EpisodeModel() when $default != null:
return $default(_that.id,_that.episodeNumber,_that.seasonNumber,_that.name,_that.overview,_that.stillPath,_that.airDate,_that.voteAverage,_that.voteCount,_that.runtime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EpisodeModel implements EpisodeModel {
  const _EpisodeModel({required this.id, this.episodeNumber = 0, this.seasonNumber = 0, this.name = '', this.overview = '', this.stillPath, this.airDate, this.voteAverage = 0, this.voteCount = 0, this.runtime});
  factory _EpisodeModel.fromJson(Map<String, dynamic> json) => _$EpisodeModelFromJson(json);

@override final  int id;
@override@JsonKey() final  int episodeNumber;
@override@JsonKey() final  int seasonNumber;
@override@JsonKey() final  String name;
@override@JsonKey() final  String overview;
@override final  String? stillPath;
@override final  String? airDate;
@override@JsonKey() final  double voteAverage;
@override@JsonKey() final  int voteCount;
@override final  int? runtime;

/// Create a copy of EpisodeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeModelCopyWith<_EpisodeModel> get copyWith => __$EpisodeModelCopyWithImpl<_EpisodeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EpisodeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpisodeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.stillPath, stillPath) || other.stillPath == stillPath)&&(identical(other.airDate, airDate) || other.airDate == airDate)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.runtime, runtime) || other.runtime == runtime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,episodeNumber,seasonNumber,name,overview,stillPath,airDate,voteAverage,voteCount,runtime);

@override
String toString() {
  return 'EpisodeModel(id: $id, episodeNumber: $episodeNumber, seasonNumber: $seasonNumber, name: $name, overview: $overview, stillPath: $stillPath, airDate: $airDate, voteAverage: $voteAverage, voteCount: $voteCount, runtime: $runtime)';
}


}

/// @nodoc
abstract mixin class _$EpisodeModelCopyWith<$Res> implements $EpisodeModelCopyWith<$Res> {
  factory _$EpisodeModelCopyWith(_EpisodeModel value, $Res Function(_EpisodeModel) _then) = __$EpisodeModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int episodeNumber, int seasonNumber, String name, String overview, String? stillPath, String? airDate, double voteAverage, int voteCount, int? runtime
});




}
/// @nodoc
class __$EpisodeModelCopyWithImpl<$Res>
    implements _$EpisodeModelCopyWith<$Res> {
  __$EpisodeModelCopyWithImpl(this._self, this._then);

  final _EpisodeModel _self;
  final $Res Function(_EpisodeModel) _then;

/// Create a copy of EpisodeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? episodeNumber = null,Object? seasonNumber = null,Object? name = null,Object? overview = null,Object? stillPath = freezed,Object? airDate = freezed,Object? voteAverage = null,Object? voteCount = null,Object? runtime = freezed,}) {
  return _then(_EpisodeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,stillPath: freezed == stillPath ? _self.stillPath : stillPath // ignore: cast_nullable_to_non_nullable
as String?,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
