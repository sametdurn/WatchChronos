// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'multi_search_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MultiSearchResultModel {

 int get page; int get totalPages; int get totalResults; List<MovieModel> get movies; List<TvShowModel> get tvShows;
/// Create a copy of MultiSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MultiSearchResultModelCopyWith<MultiSearchResultModel> get copyWith => _$MultiSearchResultModelCopyWithImpl<MultiSearchResultModel>(this as MultiSearchResultModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MultiSearchResultModel&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&const DeepCollectionEquality().equals(other.movies, movies)&&const DeepCollectionEquality().equals(other.tvShows, tvShows));
}


@override
int get hashCode => Object.hash(runtimeType,page,totalPages,totalResults,const DeepCollectionEquality().hash(movies),const DeepCollectionEquality().hash(tvShows));

@override
String toString() {
  return 'MultiSearchResultModel(page: $page, totalPages: $totalPages, totalResults: $totalResults, movies: $movies, tvShows: $tvShows)';
}


}

/// @nodoc
abstract mixin class $MultiSearchResultModelCopyWith<$Res>  {
  factory $MultiSearchResultModelCopyWith(MultiSearchResultModel value, $Res Function(MultiSearchResultModel) _then) = _$MultiSearchResultModelCopyWithImpl;
@useResult
$Res call({
 int page, int totalPages, int totalResults, List<MovieModel> movies, List<TvShowModel> tvShows
});




}
/// @nodoc
class _$MultiSearchResultModelCopyWithImpl<$Res>
    implements $MultiSearchResultModelCopyWith<$Res> {
  _$MultiSearchResultModelCopyWithImpl(this._self, this._then);

  final MultiSearchResultModel _self;
  final $Res Function(MultiSearchResultModel) _then;

/// Create a copy of MultiSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? totalPages = null,Object? totalResults = null,Object? movies = null,Object? tvShows = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,movies: null == movies ? _self.movies : movies // ignore: cast_nullable_to_non_nullable
as List<MovieModel>,tvShows: null == tvShows ? _self.tvShows : tvShows // ignore: cast_nullable_to_non_nullable
as List<TvShowModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [MultiSearchResultModel].
extension MultiSearchResultModelPatterns on MultiSearchResultModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MultiSearchResultModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MultiSearchResultModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MultiSearchResultModel value)  $default,){
final _that = this;
switch (_that) {
case _MultiSearchResultModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MultiSearchResultModel value)?  $default,){
final _that = this;
switch (_that) {
case _MultiSearchResultModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  int totalPages,  int totalResults,  List<MovieModel> movies,  List<TvShowModel> tvShows)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MultiSearchResultModel() when $default != null:
return $default(_that.page,_that.totalPages,_that.totalResults,_that.movies,_that.tvShows);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  int totalPages,  int totalResults,  List<MovieModel> movies,  List<TvShowModel> tvShows)  $default,) {final _that = this;
switch (_that) {
case _MultiSearchResultModel():
return $default(_that.page,_that.totalPages,_that.totalResults,_that.movies,_that.tvShows);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  int totalPages,  int totalResults,  List<MovieModel> movies,  List<TvShowModel> tvShows)?  $default,) {final _that = this;
switch (_that) {
case _MultiSearchResultModel() when $default != null:
return $default(_that.page,_that.totalPages,_that.totalResults,_that.movies,_that.tvShows);case _:
  return null;

}
}

}

/// @nodoc


class _MultiSearchResultModel implements MultiSearchResultModel {
  const _MultiSearchResultModel({this.page = 1, this.totalPages = 0, this.totalResults = 0, final  List<MovieModel> movies = const <MovieModel>[], final  List<TvShowModel> tvShows = const <TvShowModel>[]}): _movies = movies,_tvShows = tvShows;
  

@override@JsonKey() final  int page;
@override@JsonKey() final  int totalPages;
@override@JsonKey() final  int totalResults;
 final  List<MovieModel> _movies;
@override@JsonKey() List<MovieModel> get movies {
  if (_movies is EqualUnmodifiableListView) return _movies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_movies);
}

 final  List<TvShowModel> _tvShows;
@override@JsonKey() List<TvShowModel> get tvShows {
  if (_tvShows is EqualUnmodifiableListView) return _tvShows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tvShows);
}


/// Create a copy of MultiSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MultiSearchResultModelCopyWith<_MultiSearchResultModel> get copyWith => __$MultiSearchResultModelCopyWithImpl<_MultiSearchResultModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MultiSearchResultModel&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&const DeepCollectionEquality().equals(other._movies, _movies)&&const DeepCollectionEquality().equals(other._tvShows, _tvShows));
}


@override
int get hashCode => Object.hash(runtimeType,page,totalPages,totalResults,const DeepCollectionEquality().hash(_movies),const DeepCollectionEquality().hash(_tvShows));

@override
String toString() {
  return 'MultiSearchResultModel(page: $page, totalPages: $totalPages, totalResults: $totalResults, movies: $movies, tvShows: $tvShows)';
}


}

/// @nodoc
abstract mixin class _$MultiSearchResultModelCopyWith<$Res> implements $MultiSearchResultModelCopyWith<$Res> {
  factory _$MultiSearchResultModelCopyWith(_MultiSearchResultModel value, $Res Function(_MultiSearchResultModel) _then) = __$MultiSearchResultModelCopyWithImpl;
@override @useResult
$Res call({
 int page, int totalPages, int totalResults, List<MovieModel> movies, List<TvShowModel> tvShows
});




}
/// @nodoc
class __$MultiSearchResultModelCopyWithImpl<$Res>
    implements _$MultiSearchResultModelCopyWith<$Res> {
  __$MultiSearchResultModelCopyWithImpl(this._self, this._then);

  final _MultiSearchResultModel _self;
  final $Res Function(_MultiSearchResultModel) _then;

/// Create a copy of MultiSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? totalPages = null,Object? totalResults = null,Object? movies = null,Object? tvShows = null,}) {
  return _then(_MultiSearchResultModel(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,movies: null == movies ? _self._movies : movies // ignore: cast_nullable_to_non_nullable
as List<MovieModel>,tvShows: null == tvShows ? _self._tvShows : tvShows // ignore: cast_nullable_to_non_nullable
as List<TvShowModel>,
  ));
}


}

// dart format on
