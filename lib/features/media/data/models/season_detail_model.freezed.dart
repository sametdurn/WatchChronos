// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'season_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SeasonDetailModel {

 int get id; int get seasonNumber; String get name; String get overview; String? get posterPath; String? get airDate; List<EpisodeModel> get episodes;
/// Create a copy of SeasonDetailModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonDetailModelCopyWith<SeasonDetailModel> get copyWith => _$SeasonDetailModelCopyWithImpl<SeasonDetailModel>(this as SeasonDetailModel, _$identity);

  /// Serializes this SeasonDetailModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonDetailModel&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.airDate, airDate) || other.airDate == airDate)&&const DeepCollectionEquality().equals(other.episodes, episodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonNumber,name,overview,posterPath,airDate,const DeepCollectionEquality().hash(episodes));

@override
String toString() {
  return 'SeasonDetailModel(id: $id, seasonNumber: $seasonNumber, name: $name, overview: $overview, posterPath: $posterPath, airDate: $airDate, episodes: $episodes)';
}


}

/// @nodoc
abstract mixin class $SeasonDetailModelCopyWith<$Res>  {
  factory $SeasonDetailModelCopyWith(SeasonDetailModel value, $Res Function(SeasonDetailModel) _then) = _$SeasonDetailModelCopyWithImpl;
@useResult
$Res call({
 int id, int seasonNumber, String name, String overview, String? posterPath, String? airDate, List<EpisodeModel> episodes
});




}
/// @nodoc
class _$SeasonDetailModelCopyWithImpl<$Res>
    implements $SeasonDetailModelCopyWith<$Res> {
  _$SeasonDetailModelCopyWithImpl(this._self, this._then);

  final SeasonDetailModel _self;
  final $Res Function(SeasonDetailModel) _then;

/// Create a copy of SeasonDetailModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seasonNumber = null,Object? name = null,Object? overview = null,Object? posterPath = freezed,Object? airDate = freezed,Object? episodes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<EpisodeModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [SeasonDetailModel].
extension SeasonDetailModelPatterns on SeasonDetailModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonDetailModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonDetailModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonDetailModel value)  $default,){
final _that = this;
switch (_that) {
case _SeasonDetailModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonDetailModel value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonDetailModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int seasonNumber,  String name,  String overview,  String? posterPath,  String? airDate,  List<EpisodeModel> episodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonDetailModel() when $default != null:
return $default(_that.id,_that.seasonNumber,_that.name,_that.overview,_that.posterPath,_that.airDate,_that.episodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int seasonNumber,  String name,  String overview,  String? posterPath,  String? airDate,  List<EpisodeModel> episodes)  $default,) {final _that = this;
switch (_that) {
case _SeasonDetailModel():
return $default(_that.id,_that.seasonNumber,_that.name,_that.overview,_that.posterPath,_that.airDate,_that.episodes);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int seasonNumber,  String name,  String overview,  String? posterPath,  String? airDate,  List<EpisodeModel> episodes)?  $default,) {final _that = this;
switch (_that) {
case _SeasonDetailModel() when $default != null:
return $default(_that.id,_that.seasonNumber,_that.name,_that.overview,_that.posterPath,_that.airDate,_that.episodes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeasonDetailModel implements SeasonDetailModel {
  const _SeasonDetailModel({required this.id, this.seasonNumber = 0, this.name = '', this.overview = '', this.posterPath, this.airDate, final  List<EpisodeModel> episodes = const <EpisodeModel>[]}): _episodes = episodes;
  factory _SeasonDetailModel.fromJson(Map<String, dynamic> json) => _$SeasonDetailModelFromJson(json);

@override final  int id;
@override@JsonKey() final  int seasonNumber;
@override@JsonKey() final  String name;
@override@JsonKey() final  String overview;
@override final  String? posterPath;
@override final  String? airDate;
 final  List<EpisodeModel> _episodes;
@override@JsonKey() List<EpisodeModel> get episodes {
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodes);
}


/// Create a copy of SeasonDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonDetailModelCopyWith<_SeasonDetailModel> get copyWith => __$SeasonDetailModelCopyWithImpl<_SeasonDetailModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeasonDetailModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonDetailModel&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.airDate, airDate) || other.airDate == airDate)&&const DeepCollectionEquality().equals(other._episodes, _episodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonNumber,name,overview,posterPath,airDate,const DeepCollectionEquality().hash(_episodes));

@override
String toString() {
  return 'SeasonDetailModel(id: $id, seasonNumber: $seasonNumber, name: $name, overview: $overview, posterPath: $posterPath, airDate: $airDate, episodes: $episodes)';
}


}

/// @nodoc
abstract mixin class _$SeasonDetailModelCopyWith<$Res> implements $SeasonDetailModelCopyWith<$Res> {
  factory _$SeasonDetailModelCopyWith(_SeasonDetailModel value, $Res Function(_SeasonDetailModel) _then) = __$SeasonDetailModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int seasonNumber, String name, String overview, String? posterPath, String? airDate, List<EpisodeModel> episodes
});




}
/// @nodoc
class __$SeasonDetailModelCopyWithImpl<$Res>
    implements _$SeasonDetailModelCopyWith<$Res> {
  __$SeasonDetailModelCopyWithImpl(this._self, this._then);

  final _SeasonDetailModel _self;
  final $Res Function(_SeasonDetailModel) _then;

/// Create a copy of SeasonDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seasonNumber = null,Object? name = null,Object? overview = null,Object? posterPath = freezed,Object? airDate = freezed,Object? episodes = null,}) {
  return _then(_SeasonDetailModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,episodes: null == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<EpisodeModel>,
  ));
}


}

// dart format on
