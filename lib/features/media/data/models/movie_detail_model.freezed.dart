// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieDetailModel {

 int get id; String get title; String get originalTitle; String get overview; String get tagline; String? get posterPath; String? get backdropPath; String get releaseDate; int get runtime; double get voteAverage; int get voteCount; double get popularity; String? get originalLanguage; bool get adult; String get status; List<GenreModel> get genres;
/// Create a copy of MovieDetailModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieDetailModelCopyWith<MovieDetailModel> get copyWith => _$MovieDetailModelCopyWithImpl<MovieDetailModel>(this as MovieDetailModel, _$identity);

  /// Serializes this MovieDetailModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.genres, genres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,originalTitle,overview,tagline,posterPath,backdropPath,releaseDate,runtime,voteAverage,voteCount,popularity,originalLanguage,adult,status,const DeepCollectionEquality().hash(genres));

@override
String toString() {
  return 'MovieDetailModel(id: $id, title: $title, originalTitle: $originalTitle, overview: $overview, tagline: $tagline, posterPath: $posterPath, backdropPath: $backdropPath, releaseDate: $releaseDate, runtime: $runtime, voteAverage: $voteAverage, voteCount: $voteCount, popularity: $popularity, originalLanguage: $originalLanguage, adult: $adult, status: $status, genres: $genres)';
}


}

/// @nodoc
abstract mixin class $MovieDetailModelCopyWith<$Res>  {
  factory $MovieDetailModelCopyWith(MovieDetailModel value, $Res Function(MovieDetailModel) _then) = _$MovieDetailModelCopyWithImpl;
@useResult
$Res call({
 int id, String title, String originalTitle, String overview, String tagline, String? posterPath, String? backdropPath, String releaseDate, int runtime, double voteAverage, int voteCount, double popularity, String? originalLanguage, bool adult, String status, List<GenreModel> genres
});




}
/// @nodoc
class _$MovieDetailModelCopyWithImpl<$Res>
    implements $MovieDetailModelCopyWith<$Res> {
  _$MovieDetailModelCopyWithImpl(this._self, this._then);

  final MovieDetailModel _self;
  final $Res Function(MovieDetailModel) _then;

/// Create a copy of MovieDetailModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? originalTitle = null,Object? overview = null,Object? tagline = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? releaseDate = null,Object? runtime = null,Object? voteAverage = null,Object? voteCount = null,Object? popularity = null,Object? originalLanguage = freezed,Object? adult = null,Object? status = null,Object? genres = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: null == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: null == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String,runtime: null == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieDetailModel].
extension MovieDetailModelPatterns on MovieDetailModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieDetailModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieDetailModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieDetailModel value)  $default,){
final _that = this;
switch (_that) {
case _MovieDetailModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieDetailModel value)?  $default,){
final _that = this;
switch (_that) {
case _MovieDetailModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String originalTitle,  String overview,  String tagline,  String? posterPath,  String? backdropPath,  String releaseDate,  int runtime,  double voteAverage,  int voteCount,  double popularity,  String? originalLanguage,  bool adult,  String status,  List<GenreModel> genres)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieDetailModel() when $default != null:
return $default(_that.id,_that.title,_that.originalTitle,_that.overview,_that.tagline,_that.posterPath,_that.backdropPath,_that.releaseDate,_that.runtime,_that.voteAverage,_that.voteCount,_that.popularity,_that.originalLanguage,_that.adult,_that.status,_that.genres);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String originalTitle,  String overview,  String tagline,  String? posterPath,  String? backdropPath,  String releaseDate,  int runtime,  double voteAverage,  int voteCount,  double popularity,  String? originalLanguage,  bool adult,  String status,  List<GenreModel> genres)  $default,) {final _that = this;
switch (_that) {
case _MovieDetailModel():
return $default(_that.id,_that.title,_that.originalTitle,_that.overview,_that.tagline,_that.posterPath,_that.backdropPath,_that.releaseDate,_that.runtime,_that.voteAverage,_that.voteCount,_that.popularity,_that.originalLanguage,_that.adult,_that.status,_that.genres);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String originalTitle,  String overview,  String tagline,  String? posterPath,  String? backdropPath,  String releaseDate,  int runtime,  double voteAverage,  int voteCount,  double popularity,  String? originalLanguage,  bool adult,  String status,  List<GenreModel> genres)?  $default,) {final _that = this;
switch (_that) {
case _MovieDetailModel() when $default != null:
return $default(_that.id,_that.title,_that.originalTitle,_that.overview,_that.tagline,_that.posterPath,_that.backdropPath,_that.releaseDate,_that.runtime,_that.voteAverage,_that.voteCount,_that.popularity,_that.originalLanguage,_that.adult,_that.status,_that.genres);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MovieDetailModel implements MovieDetailModel {
  const _MovieDetailModel({required this.id, this.title = '', this.originalTitle = '', this.overview = '', this.tagline = '', this.posterPath, this.backdropPath, this.releaseDate = '', this.runtime = 0, this.voteAverage = 0, this.voteCount = 0, this.popularity = 0, this.originalLanguage, this.adult = false, this.status = '', final  List<GenreModel> genres = const <GenreModel>[]}): _genres = genres;
  factory _MovieDetailModel.fromJson(Map<String, dynamic> json) => _$MovieDetailModelFromJson(json);

@override final  int id;
@override@JsonKey() final  String title;
@override@JsonKey() final  String originalTitle;
@override@JsonKey() final  String overview;
@override@JsonKey() final  String tagline;
@override final  String? posterPath;
@override final  String? backdropPath;
@override@JsonKey() final  String releaseDate;
@override@JsonKey() final  int runtime;
@override@JsonKey() final  double voteAverage;
@override@JsonKey() final  int voteCount;
@override@JsonKey() final  double popularity;
@override final  String? originalLanguage;
@override@JsonKey() final  bool adult;
@override@JsonKey() final  String status;
 final  List<GenreModel> _genres;
@override@JsonKey() List<GenreModel> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}


/// Create a copy of MovieDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieDetailModelCopyWith<_MovieDetailModel> get copyWith => __$MovieDetailModelCopyWithImpl<_MovieDetailModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieDetailModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieDetailModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._genres, _genres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,originalTitle,overview,tagline,posterPath,backdropPath,releaseDate,runtime,voteAverage,voteCount,popularity,originalLanguage,adult,status,const DeepCollectionEquality().hash(_genres));

@override
String toString() {
  return 'MovieDetailModel(id: $id, title: $title, originalTitle: $originalTitle, overview: $overview, tagline: $tagline, posterPath: $posterPath, backdropPath: $backdropPath, releaseDate: $releaseDate, runtime: $runtime, voteAverage: $voteAverage, voteCount: $voteCount, popularity: $popularity, originalLanguage: $originalLanguage, adult: $adult, status: $status, genres: $genres)';
}


}

/// @nodoc
abstract mixin class _$MovieDetailModelCopyWith<$Res> implements $MovieDetailModelCopyWith<$Res> {
  factory _$MovieDetailModelCopyWith(_MovieDetailModel value, $Res Function(_MovieDetailModel) _then) = __$MovieDetailModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String originalTitle, String overview, String tagline, String? posterPath, String? backdropPath, String releaseDate, int runtime, double voteAverage, int voteCount, double popularity, String? originalLanguage, bool adult, String status, List<GenreModel> genres
});




}
/// @nodoc
class __$MovieDetailModelCopyWithImpl<$Res>
    implements _$MovieDetailModelCopyWith<$Res> {
  __$MovieDetailModelCopyWithImpl(this._self, this._then);

  final _MovieDetailModel _self;
  final $Res Function(_MovieDetailModel) _then;

/// Create a copy of MovieDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? originalTitle = null,Object? overview = null,Object? tagline = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? releaseDate = null,Object? runtime = null,Object? voteAverage = null,Object? voteCount = null,Object? popularity = null,Object? originalLanguage = freezed,Object? adult = null,Object? status = null,Object? genres = null,}) {
  return _then(_MovieDetailModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: null == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: null == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String,runtime: null == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreModel>,
  ));
}


}

// dart format on
