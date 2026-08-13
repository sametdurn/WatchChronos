// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watch_entry_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WatchEntryStats {

@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'completed_count') int get completedCount;@JsonKey(name: 'completed_movies_count') int get completedMoviesCount;@JsonKey(name: 'completed_tv_count') int get completedTvCount;@JsonKey(name: 'watching_count') int get watchingCount;@JsonKey(name: 'planned_count') int get plannedCount;@JsonKey(name: 'favorites_count') int get favoritesCount;@JsonKey(name: 'average_rating') double? get averageRating;@JsonKey(name: 'episodes_watched_count') int get episodesWatchedCount;
/// Create a copy of WatchEntryStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchEntryStatsCopyWith<WatchEntryStats> get copyWith => _$WatchEntryStatsCopyWithImpl<WatchEntryStats>(this as WatchEntryStats, _$identity);

  /// Serializes this WatchEntryStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchEntryStats&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.completedMoviesCount, completedMoviesCount) || other.completedMoviesCount == completedMoviesCount)&&(identical(other.completedTvCount, completedTvCount) || other.completedTvCount == completedTvCount)&&(identical(other.watchingCount, watchingCount) || other.watchingCount == watchingCount)&&(identical(other.plannedCount, plannedCount) || other.plannedCount == plannedCount)&&(identical(other.favoritesCount, favoritesCount) || other.favoritesCount == favoritesCount)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.episodesWatchedCount, episodesWatchedCount) || other.episodesWatchedCount == episodesWatchedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,completedCount,completedMoviesCount,completedTvCount,watchingCount,plannedCount,favoritesCount,averageRating,episodesWatchedCount);

@override
String toString() {
  return 'WatchEntryStats(userId: $userId, completedCount: $completedCount, completedMoviesCount: $completedMoviesCount, completedTvCount: $completedTvCount, watchingCount: $watchingCount, plannedCount: $plannedCount, favoritesCount: $favoritesCount, averageRating: $averageRating, episodesWatchedCount: $episodesWatchedCount)';
}


}

/// @nodoc
abstract mixin class $WatchEntryStatsCopyWith<$Res>  {
  factory $WatchEntryStatsCopyWith(WatchEntryStats value, $Res Function(WatchEntryStats) _then) = _$WatchEntryStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'completed_count') int completedCount,@JsonKey(name: 'completed_movies_count') int completedMoviesCount,@JsonKey(name: 'completed_tv_count') int completedTvCount,@JsonKey(name: 'watching_count') int watchingCount,@JsonKey(name: 'planned_count') int plannedCount,@JsonKey(name: 'favorites_count') int favoritesCount,@JsonKey(name: 'average_rating') double? averageRating,@JsonKey(name: 'episodes_watched_count') int episodesWatchedCount
});




}
/// @nodoc
class _$WatchEntryStatsCopyWithImpl<$Res>
    implements $WatchEntryStatsCopyWith<$Res> {
  _$WatchEntryStatsCopyWithImpl(this._self, this._then);

  final WatchEntryStats _self;
  final $Res Function(WatchEntryStats) _then;

/// Create a copy of WatchEntryStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? completedCount = null,Object? completedMoviesCount = null,Object? completedTvCount = null,Object? watchingCount = null,Object? plannedCount = null,Object? favoritesCount = null,Object? averageRating = freezed,Object? episodesWatchedCount = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,completedMoviesCount: null == completedMoviesCount ? _self.completedMoviesCount : completedMoviesCount // ignore: cast_nullable_to_non_nullable
as int,completedTvCount: null == completedTvCount ? _self.completedTvCount : completedTvCount // ignore: cast_nullable_to_non_nullable
as int,watchingCount: null == watchingCount ? _self.watchingCount : watchingCount // ignore: cast_nullable_to_non_nullable
as int,plannedCount: null == plannedCount ? _self.plannedCount : plannedCount // ignore: cast_nullable_to_non_nullable
as int,favoritesCount: null == favoritesCount ? _self.favoritesCount : favoritesCount // ignore: cast_nullable_to_non_nullable
as int,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,episodesWatchedCount: null == episodesWatchedCount ? _self.episodesWatchedCount : episodesWatchedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchEntryStats].
extension WatchEntryStatsPatterns on WatchEntryStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchEntryStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchEntryStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchEntryStats value)  $default,){
final _that = this;
switch (_that) {
case _WatchEntryStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchEntryStats value)?  $default,){
final _that = this;
switch (_that) {
case _WatchEntryStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'completed_count')  int completedCount, @JsonKey(name: 'completed_movies_count')  int completedMoviesCount, @JsonKey(name: 'completed_tv_count')  int completedTvCount, @JsonKey(name: 'watching_count')  int watchingCount, @JsonKey(name: 'planned_count')  int plannedCount, @JsonKey(name: 'favorites_count')  int favoritesCount, @JsonKey(name: 'average_rating')  double? averageRating, @JsonKey(name: 'episodes_watched_count')  int episodesWatchedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchEntryStats() when $default != null:
return $default(_that.userId,_that.completedCount,_that.completedMoviesCount,_that.completedTvCount,_that.watchingCount,_that.plannedCount,_that.favoritesCount,_that.averageRating,_that.episodesWatchedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'completed_count')  int completedCount, @JsonKey(name: 'completed_movies_count')  int completedMoviesCount, @JsonKey(name: 'completed_tv_count')  int completedTvCount, @JsonKey(name: 'watching_count')  int watchingCount, @JsonKey(name: 'planned_count')  int plannedCount, @JsonKey(name: 'favorites_count')  int favoritesCount, @JsonKey(name: 'average_rating')  double? averageRating, @JsonKey(name: 'episodes_watched_count')  int episodesWatchedCount)  $default,) {final _that = this;
switch (_that) {
case _WatchEntryStats():
return $default(_that.userId,_that.completedCount,_that.completedMoviesCount,_that.completedTvCount,_that.watchingCount,_that.plannedCount,_that.favoritesCount,_that.averageRating,_that.episodesWatchedCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'completed_count')  int completedCount, @JsonKey(name: 'completed_movies_count')  int completedMoviesCount, @JsonKey(name: 'completed_tv_count')  int completedTvCount, @JsonKey(name: 'watching_count')  int watchingCount, @JsonKey(name: 'planned_count')  int plannedCount, @JsonKey(name: 'favorites_count')  int favoritesCount, @JsonKey(name: 'average_rating')  double? averageRating, @JsonKey(name: 'episodes_watched_count')  int episodesWatchedCount)?  $default,) {final _that = this;
switch (_that) {
case _WatchEntryStats() when $default != null:
return $default(_that.userId,_that.completedCount,_that.completedMoviesCount,_that.completedTvCount,_that.watchingCount,_that.plannedCount,_that.favoritesCount,_that.averageRating,_that.episodesWatchedCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WatchEntryStats implements WatchEntryStats {
  const _WatchEntryStats({@JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'completed_count') this.completedCount = 0, @JsonKey(name: 'completed_movies_count') this.completedMoviesCount = 0, @JsonKey(name: 'completed_tv_count') this.completedTvCount = 0, @JsonKey(name: 'watching_count') this.watchingCount = 0, @JsonKey(name: 'planned_count') this.plannedCount = 0, @JsonKey(name: 'favorites_count') this.favoritesCount = 0, @JsonKey(name: 'average_rating') this.averageRating, @JsonKey(name: 'episodes_watched_count') this.episodesWatchedCount = 0});
  factory _WatchEntryStats.fromJson(Map<String, dynamic> json) => _$WatchEntryStatsFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'completed_count') final  int completedCount;
@override@JsonKey(name: 'completed_movies_count') final  int completedMoviesCount;
@override@JsonKey(name: 'completed_tv_count') final  int completedTvCount;
@override@JsonKey(name: 'watching_count') final  int watchingCount;
@override@JsonKey(name: 'planned_count') final  int plannedCount;
@override@JsonKey(name: 'favorites_count') final  int favoritesCount;
@override@JsonKey(name: 'average_rating') final  double? averageRating;
@override@JsonKey(name: 'episodes_watched_count') final  int episodesWatchedCount;

/// Create a copy of WatchEntryStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchEntryStatsCopyWith<_WatchEntryStats> get copyWith => __$WatchEntryStatsCopyWithImpl<_WatchEntryStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchEntryStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchEntryStats&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.completedMoviesCount, completedMoviesCount) || other.completedMoviesCount == completedMoviesCount)&&(identical(other.completedTvCount, completedTvCount) || other.completedTvCount == completedTvCount)&&(identical(other.watchingCount, watchingCount) || other.watchingCount == watchingCount)&&(identical(other.plannedCount, plannedCount) || other.plannedCount == plannedCount)&&(identical(other.favoritesCount, favoritesCount) || other.favoritesCount == favoritesCount)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.episodesWatchedCount, episodesWatchedCount) || other.episodesWatchedCount == episodesWatchedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,completedCount,completedMoviesCount,completedTvCount,watchingCount,plannedCount,favoritesCount,averageRating,episodesWatchedCount);

@override
String toString() {
  return 'WatchEntryStats(userId: $userId, completedCount: $completedCount, completedMoviesCount: $completedMoviesCount, completedTvCount: $completedTvCount, watchingCount: $watchingCount, plannedCount: $plannedCount, favoritesCount: $favoritesCount, averageRating: $averageRating, episodesWatchedCount: $episodesWatchedCount)';
}


}

/// @nodoc
abstract mixin class _$WatchEntryStatsCopyWith<$Res> implements $WatchEntryStatsCopyWith<$Res> {
  factory _$WatchEntryStatsCopyWith(_WatchEntryStats value, $Res Function(_WatchEntryStats) _then) = __$WatchEntryStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'completed_count') int completedCount,@JsonKey(name: 'completed_movies_count') int completedMoviesCount,@JsonKey(name: 'completed_tv_count') int completedTvCount,@JsonKey(name: 'watching_count') int watchingCount,@JsonKey(name: 'planned_count') int plannedCount,@JsonKey(name: 'favorites_count') int favoritesCount,@JsonKey(name: 'average_rating') double? averageRating,@JsonKey(name: 'episodes_watched_count') int episodesWatchedCount
});




}
/// @nodoc
class __$WatchEntryStatsCopyWithImpl<$Res>
    implements _$WatchEntryStatsCopyWith<$Res> {
  __$WatchEntryStatsCopyWithImpl(this._self, this._then);

  final _WatchEntryStats _self;
  final $Res Function(_WatchEntryStats) _then;

/// Create a copy of WatchEntryStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? completedCount = null,Object? completedMoviesCount = null,Object? completedTvCount = null,Object? watchingCount = null,Object? plannedCount = null,Object? favoritesCount = null,Object? averageRating = freezed,Object? episodesWatchedCount = null,}) {
  return _then(_WatchEntryStats(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,completedMoviesCount: null == completedMoviesCount ? _self.completedMoviesCount : completedMoviesCount // ignore: cast_nullable_to_non_nullable
as int,completedTvCount: null == completedTvCount ? _self.completedTvCount : completedTvCount // ignore: cast_nullable_to_non_nullable
as int,watchingCount: null == watchingCount ? _self.watchingCount : watchingCount // ignore: cast_nullable_to_non_nullable
as int,plannedCount: null == plannedCount ? _self.plannedCount : plannedCount // ignore: cast_nullable_to_non_nullable
as int,favoritesCount: null == favoritesCount ? _self.favoritesCount : favoritesCount // ignore: cast_nullable_to_non_nullable
as int,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,episodesWatchedCount: null == episodesWatchedCount ? _self.episodesWatchedCount : episodesWatchedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
