// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_show_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TvShowModel {

 int get id; String get name; String get originalName; String get overview; String? get posterPath; String? get backdropPath; String get firstAirDate; double get voteAverage; int get voteCount; double get popularity; String? get originalLanguage; List<String> get originCountry; List<int> get genreIds;
/// Create a copy of TvShowModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvShowModelCopyWith<TvShowModel> get copyWith => _$TvShowModelCopyWithImpl<TvShowModel>(this as TvShowModel, _$identity);

  /// Serializes this TvShowModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvShowModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&const DeepCollectionEquality().equals(other.originCountry, originCountry)&&const DeepCollectionEquality().equals(other.genreIds, genreIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,originalName,overview,posterPath,backdropPath,firstAirDate,voteAverage,voteCount,popularity,originalLanguage,const DeepCollectionEquality().hash(originCountry),const DeepCollectionEquality().hash(genreIds));

@override
String toString() {
  return 'TvShowModel(id: $id, name: $name, originalName: $originalName, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, firstAirDate: $firstAirDate, voteAverage: $voteAverage, voteCount: $voteCount, popularity: $popularity, originalLanguage: $originalLanguage, originCountry: $originCountry, genreIds: $genreIds)';
}


}

/// @nodoc
abstract mixin class $TvShowModelCopyWith<$Res>  {
  factory $TvShowModelCopyWith(TvShowModel value, $Res Function(TvShowModel) _then) = _$TvShowModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String originalName, String overview, String? posterPath, String? backdropPath, String firstAirDate, double voteAverage, int voteCount, double popularity, String? originalLanguage, List<String> originCountry, List<int> genreIds
});




}
/// @nodoc
class _$TvShowModelCopyWithImpl<$Res>
    implements $TvShowModelCopyWith<$Res> {
  _$TvShowModelCopyWithImpl(this._self, this._then);

  final TvShowModel _self;
  final $Res Function(TvShowModel) _then;

/// Create a copy of TvShowModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? originalName = null,Object? overview = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? firstAirDate = null,Object? voteAverage = null,Object? voteCount = null,Object? popularity = null,Object? originalLanguage = freezed,Object? originCountry = null,Object? genreIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: null == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: null == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,originCountry: null == originCountry ? _self.originCountry : originCountry // ignore: cast_nullable_to_non_nullable
as List<String>,genreIds: null == genreIds ? _self.genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [TvShowModel].
extension TvShowModelPatterns on TvShowModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvShowModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvShowModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvShowModel value)  $default,){
final _that = this;
switch (_that) {
case _TvShowModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvShowModel value)?  $default,){
final _that = this;
switch (_that) {
case _TvShowModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String originalName,  String overview,  String? posterPath,  String? backdropPath,  String firstAirDate,  double voteAverage,  int voteCount,  double popularity,  String? originalLanguage,  List<String> originCountry,  List<int> genreIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvShowModel() when $default != null:
return $default(_that.id,_that.name,_that.originalName,_that.overview,_that.posterPath,_that.backdropPath,_that.firstAirDate,_that.voteAverage,_that.voteCount,_that.popularity,_that.originalLanguage,_that.originCountry,_that.genreIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String originalName,  String overview,  String? posterPath,  String? backdropPath,  String firstAirDate,  double voteAverage,  int voteCount,  double popularity,  String? originalLanguage,  List<String> originCountry,  List<int> genreIds)  $default,) {final _that = this;
switch (_that) {
case _TvShowModel():
return $default(_that.id,_that.name,_that.originalName,_that.overview,_that.posterPath,_that.backdropPath,_that.firstAirDate,_that.voteAverage,_that.voteCount,_that.popularity,_that.originalLanguage,_that.originCountry,_that.genreIds);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String originalName,  String overview,  String? posterPath,  String? backdropPath,  String firstAirDate,  double voteAverage,  int voteCount,  double popularity,  String? originalLanguage,  List<String> originCountry,  List<int> genreIds)?  $default,) {final _that = this;
switch (_that) {
case _TvShowModel() when $default != null:
return $default(_that.id,_that.name,_that.originalName,_that.overview,_that.posterPath,_that.backdropPath,_that.firstAirDate,_that.voteAverage,_that.voteCount,_that.popularity,_that.originalLanguage,_that.originCountry,_that.genreIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TvShowModel implements TvShowModel {
  const _TvShowModel({required this.id, this.name = '', this.originalName = '', this.overview = '', this.posterPath, this.backdropPath, this.firstAirDate = '', this.voteAverage = 0, this.voteCount = 0, this.popularity = 0, this.originalLanguage, final  List<String> originCountry = const <String>[], final  List<int> genreIds = const <int>[]}): _originCountry = originCountry,_genreIds = genreIds;
  factory _TvShowModel.fromJson(Map<String, dynamic> json) => _$TvShowModelFromJson(json);

@override final  int id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String originalName;
@override@JsonKey() final  String overview;
@override final  String? posterPath;
@override final  String? backdropPath;
@override@JsonKey() final  String firstAirDate;
@override@JsonKey() final  double voteAverage;
@override@JsonKey() final  int voteCount;
@override@JsonKey() final  double popularity;
@override final  String? originalLanguage;
 final  List<String> _originCountry;
@override@JsonKey() List<String> get originCountry {
  if (_originCountry is EqualUnmodifiableListView) return _originCountry;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_originCountry);
}

 final  List<int> _genreIds;
@override@JsonKey() List<int> get genreIds {
  if (_genreIds is EqualUnmodifiableListView) return _genreIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genreIds);
}


/// Create a copy of TvShowModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvShowModelCopyWith<_TvShowModel> get copyWith => __$TvShowModelCopyWithImpl<_TvShowModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TvShowModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvShowModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&const DeepCollectionEquality().equals(other._originCountry, _originCountry)&&const DeepCollectionEquality().equals(other._genreIds, _genreIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,originalName,overview,posterPath,backdropPath,firstAirDate,voteAverage,voteCount,popularity,originalLanguage,const DeepCollectionEquality().hash(_originCountry),const DeepCollectionEquality().hash(_genreIds));

@override
String toString() {
  return 'TvShowModel(id: $id, name: $name, originalName: $originalName, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, firstAirDate: $firstAirDate, voteAverage: $voteAverage, voteCount: $voteCount, popularity: $popularity, originalLanguage: $originalLanguage, originCountry: $originCountry, genreIds: $genreIds)';
}


}

/// @nodoc
abstract mixin class _$TvShowModelCopyWith<$Res> implements $TvShowModelCopyWith<$Res> {
  factory _$TvShowModelCopyWith(_TvShowModel value, $Res Function(_TvShowModel) _then) = __$TvShowModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String originalName, String overview, String? posterPath, String? backdropPath, String firstAirDate, double voteAverage, int voteCount, double popularity, String? originalLanguage, List<String> originCountry, List<int> genreIds
});




}
/// @nodoc
class __$TvShowModelCopyWithImpl<$Res>
    implements _$TvShowModelCopyWith<$Res> {
  __$TvShowModelCopyWithImpl(this._self, this._then);

  final _TvShowModel _self;
  final $Res Function(_TvShowModel) _then;

/// Create a copy of TvShowModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? originalName = null,Object? overview = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? firstAirDate = null,Object? voteAverage = null,Object? voteCount = null,Object? popularity = null,Object? originalLanguage = freezed,Object? originCountry = null,Object? genreIds = null,}) {
  return _then(_TvShowModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: null == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: null == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,originCountry: null == originCountry ? _self._originCountry : originCountry // ignore: cast_nullable_to_non_nullable
as List<String>,genreIds: null == genreIds ? _self._genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
