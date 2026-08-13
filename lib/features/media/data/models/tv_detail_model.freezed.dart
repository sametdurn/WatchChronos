// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TvDetailModel {

 int get id; String get name; String get originalName; String get overview; String get tagline; String? get posterPath; String? get backdropPath; String get firstAirDate; String? get lastAirDate; int get numberOfSeasons; int get numberOfEpisodes; double get voteAverage; int get voteCount; double get popularity; String? get originalLanguage; String get status; List<GenreModel> get genres; List<TvSeasonSummaryModel> get seasons;
/// Create a copy of TvDetailModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvDetailModelCopyWith<TvDetailModel> get copyWith => _$TvDetailModelCopyWithImpl<TvDetailModel>(this as TvDetailModel, _$identity);

  /// Serializes this TvDetailModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvDetailModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.lastAirDate, lastAirDate) || other.lastAirDate == lastAirDate)&&(identical(other.numberOfSeasons, numberOfSeasons) || other.numberOfSeasons == numberOfSeasons)&&(identical(other.numberOfEpisodes, numberOfEpisodes) || other.numberOfEpisodes == numberOfEpisodes)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.genres, genres)&&const DeepCollectionEquality().equals(other.seasons, seasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,originalName,overview,tagline,posterPath,backdropPath,firstAirDate,lastAirDate,numberOfSeasons,numberOfEpisodes,voteAverage,voteCount,popularity,originalLanguage,status,const DeepCollectionEquality().hash(genres),const DeepCollectionEquality().hash(seasons));

@override
String toString() {
  return 'TvDetailModel(id: $id, name: $name, originalName: $originalName, overview: $overview, tagline: $tagline, posterPath: $posterPath, backdropPath: $backdropPath, firstAirDate: $firstAirDate, lastAirDate: $lastAirDate, numberOfSeasons: $numberOfSeasons, numberOfEpisodes: $numberOfEpisodes, voteAverage: $voteAverage, voteCount: $voteCount, popularity: $popularity, originalLanguage: $originalLanguage, status: $status, genres: $genres, seasons: $seasons)';
}


}

/// @nodoc
abstract mixin class $TvDetailModelCopyWith<$Res>  {
  factory $TvDetailModelCopyWith(TvDetailModel value, $Res Function(TvDetailModel) _then) = _$TvDetailModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String originalName, String overview, String tagline, String? posterPath, String? backdropPath, String firstAirDate, String? lastAirDate, int numberOfSeasons, int numberOfEpisodes, double voteAverage, int voteCount, double popularity, String? originalLanguage, String status, List<GenreModel> genres, List<TvSeasonSummaryModel> seasons
});




}
/// @nodoc
class _$TvDetailModelCopyWithImpl<$Res>
    implements $TvDetailModelCopyWith<$Res> {
  _$TvDetailModelCopyWithImpl(this._self, this._then);

  final TvDetailModel _self;
  final $Res Function(TvDetailModel) _then;

/// Create a copy of TvDetailModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? originalName = null,Object? overview = null,Object? tagline = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? firstAirDate = null,Object? lastAirDate = freezed,Object? numberOfSeasons = null,Object? numberOfEpisodes = null,Object? voteAverage = null,Object? voteCount = null,Object? popularity = null,Object? originalLanguage = freezed,Object? status = null,Object? genres = null,Object? seasons = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: null == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: null == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String,lastAirDate: freezed == lastAirDate ? _self.lastAirDate : lastAirDate // ignore: cast_nullable_to_non_nullable
as String?,numberOfSeasons: null == numberOfSeasons ? _self.numberOfSeasons : numberOfSeasons // ignore: cast_nullable_to_non_nullable
as int,numberOfEpisodes: null == numberOfEpisodes ? _self.numberOfEpisodes : numberOfEpisodes // ignore: cast_nullable_to_non_nullable
as int,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreModel>,seasons: null == seasons ? _self.seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<TvSeasonSummaryModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [TvDetailModel].
extension TvDetailModelPatterns on TvDetailModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvDetailModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvDetailModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvDetailModel value)  $default,){
final _that = this;
switch (_that) {
case _TvDetailModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvDetailModel value)?  $default,){
final _that = this;
switch (_that) {
case _TvDetailModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String originalName,  String overview,  String tagline,  String? posterPath,  String? backdropPath,  String firstAirDate,  String? lastAirDate,  int numberOfSeasons,  int numberOfEpisodes,  double voteAverage,  int voteCount,  double popularity,  String? originalLanguage,  String status,  List<GenreModel> genres,  List<TvSeasonSummaryModel> seasons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvDetailModel() when $default != null:
return $default(_that.id,_that.name,_that.originalName,_that.overview,_that.tagline,_that.posterPath,_that.backdropPath,_that.firstAirDate,_that.lastAirDate,_that.numberOfSeasons,_that.numberOfEpisodes,_that.voteAverage,_that.voteCount,_that.popularity,_that.originalLanguage,_that.status,_that.genres,_that.seasons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String originalName,  String overview,  String tagline,  String? posterPath,  String? backdropPath,  String firstAirDate,  String? lastAirDate,  int numberOfSeasons,  int numberOfEpisodes,  double voteAverage,  int voteCount,  double popularity,  String? originalLanguage,  String status,  List<GenreModel> genres,  List<TvSeasonSummaryModel> seasons)  $default,) {final _that = this;
switch (_that) {
case _TvDetailModel():
return $default(_that.id,_that.name,_that.originalName,_that.overview,_that.tagline,_that.posterPath,_that.backdropPath,_that.firstAirDate,_that.lastAirDate,_that.numberOfSeasons,_that.numberOfEpisodes,_that.voteAverage,_that.voteCount,_that.popularity,_that.originalLanguage,_that.status,_that.genres,_that.seasons);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String originalName,  String overview,  String tagline,  String? posterPath,  String? backdropPath,  String firstAirDate,  String? lastAirDate,  int numberOfSeasons,  int numberOfEpisodes,  double voteAverage,  int voteCount,  double popularity,  String? originalLanguage,  String status,  List<GenreModel> genres,  List<TvSeasonSummaryModel> seasons)?  $default,) {final _that = this;
switch (_that) {
case _TvDetailModel() when $default != null:
return $default(_that.id,_that.name,_that.originalName,_that.overview,_that.tagline,_that.posterPath,_that.backdropPath,_that.firstAirDate,_that.lastAirDate,_that.numberOfSeasons,_that.numberOfEpisodes,_that.voteAverage,_that.voteCount,_that.popularity,_that.originalLanguage,_that.status,_that.genres,_that.seasons);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TvDetailModel implements TvDetailModel {
  const _TvDetailModel({required this.id, this.name = '', this.originalName = '', this.overview = '', this.tagline = '', this.posterPath, this.backdropPath, this.firstAirDate = '', this.lastAirDate, this.numberOfSeasons = 0, this.numberOfEpisodes = 0, this.voteAverage = 0, this.voteCount = 0, this.popularity = 0, this.originalLanguage, this.status = '', final  List<GenreModel> genres = const <GenreModel>[], final  List<TvSeasonSummaryModel> seasons = const <TvSeasonSummaryModel>[]}): _genres = genres,_seasons = seasons;
  factory _TvDetailModel.fromJson(Map<String, dynamic> json) => _$TvDetailModelFromJson(json);

@override final  int id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String originalName;
@override@JsonKey() final  String overview;
@override@JsonKey() final  String tagline;
@override final  String? posterPath;
@override final  String? backdropPath;
@override@JsonKey() final  String firstAirDate;
@override final  String? lastAirDate;
@override@JsonKey() final  int numberOfSeasons;
@override@JsonKey() final  int numberOfEpisodes;
@override@JsonKey() final  double voteAverage;
@override@JsonKey() final  int voteCount;
@override@JsonKey() final  double popularity;
@override final  String? originalLanguage;
@override@JsonKey() final  String status;
 final  List<GenreModel> _genres;
@override@JsonKey() List<GenreModel> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

 final  List<TvSeasonSummaryModel> _seasons;
@override@JsonKey() List<TvSeasonSummaryModel> get seasons {
  if (_seasons is EqualUnmodifiableListView) return _seasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seasons);
}


/// Create a copy of TvDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvDetailModelCopyWith<_TvDetailModel> get copyWith => __$TvDetailModelCopyWithImpl<_TvDetailModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TvDetailModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvDetailModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.lastAirDate, lastAirDate) || other.lastAirDate == lastAirDate)&&(identical(other.numberOfSeasons, numberOfSeasons) || other.numberOfSeasons == numberOfSeasons)&&(identical(other.numberOfEpisodes, numberOfEpisodes) || other.numberOfEpisodes == numberOfEpisodes)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._genres, _genres)&&const DeepCollectionEquality().equals(other._seasons, _seasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,originalName,overview,tagline,posterPath,backdropPath,firstAirDate,lastAirDate,numberOfSeasons,numberOfEpisodes,voteAverage,voteCount,popularity,originalLanguage,status,const DeepCollectionEquality().hash(_genres),const DeepCollectionEquality().hash(_seasons));

@override
String toString() {
  return 'TvDetailModel(id: $id, name: $name, originalName: $originalName, overview: $overview, tagline: $tagline, posterPath: $posterPath, backdropPath: $backdropPath, firstAirDate: $firstAirDate, lastAirDate: $lastAirDate, numberOfSeasons: $numberOfSeasons, numberOfEpisodes: $numberOfEpisodes, voteAverage: $voteAverage, voteCount: $voteCount, popularity: $popularity, originalLanguage: $originalLanguage, status: $status, genres: $genres, seasons: $seasons)';
}


}

/// @nodoc
abstract mixin class _$TvDetailModelCopyWith<$Res> implements $TvDetailModelCopyWith<$Res> {
  factory _$TvDetailModelCopyWith(_TvDetailModel value, $Res Function(_TvDetailModel) _then) = __$TvDetailModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String originalName, String overview, String tagline, String? posterPath, String? backdropPath, String firstAirDate, String? lastAirDate, int numberOfSeasons, int numberOfEpisodes, double voteAverage, int voteCount, double popularity, String? originalLanguage, String status, List<GenreModel> genres, List<TvSeasonSummaryModel> seasons
});




}
/// @nodoc
class __$TvDetailModelCopyWithImpl<$Res>
    implements _$TvDetailModelCopyWith<$Res> {
  __$TvDetailModelCopyWithImpl(this._self, this._then);

  final _TvDetailModel _self;
  final $Res Function(_TvDetailModel) _then;

/// Create a copy of TvDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? originalName = null,Object? overview = null,Object? tagline = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? firstAirDate = null,Object? lastAirDate = freezed,Object? numberOfSeasons = null,Object? numberOfEpisodes = null,Object? voteAverage = null,Object? voteCount = null,Object? popularity = null,Object? originalLanguage = freezed,Object? status = null,Object? genres = null,Object? seasons = null,}) {
  return _then(_TvDetailModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: null == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: null == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String,lastAirDate: freezed == lastAirDate ? _self.lastAirDate : lastAirDate // ignore: cast_nullable_to_non_nullable
as String?,numberOfSeasons: null == numberOfSeasons ? _self.numberOfSeasons : numberOfSeasons // ignore: cast_nullable_to_non_nullable
as int,numberOfEpisodes: null == numberOfEpisodes ? _self.numberOfEpisodes : numberOfEpisodes // ignore: cast_nullable_to_non_nullable
as int,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreModel>,seasons: null == seasons ? _self._seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<TvSeasonSummaryModel>,
  ));
}


}

// dart format on
