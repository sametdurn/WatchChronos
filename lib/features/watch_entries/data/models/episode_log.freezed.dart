// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EpisodeLog {

 String get id;@JsonKey(name: 'watch_entry_id') String get watchEntryId;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'season_number') int get seasonNumber;@JsonKey(name: 'episode_number') int get episodeNumber;@JsonKey(name: 'watched_at') DateTime get watchedAt;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of EpisodeLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeLogCopyWith<EpisodeLog> get copyWith => _$EpisodeLogCopyWithImpl<EpisodeLog>(this as EpisodeLog, _$identity);

  /// Serializes this EpisodeLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpisodeLog&&(identical(other.id, id) || other.id == id)&&(identical(other.watchEntryId, watchEntryId) || other.watchEntryId == watchEntryId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,watchEntryId,userId,seasonNumber,episodeNumber,watchedAt,createdAt);

@override
String toString() {
  return 'EpisodeLog(id: $id, watchEntryId: $watchEntryId, userId: $userId, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, watchedAt: $watchedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $EpisodeLogCopyWith<$Res>  {
  factory $EpisodeLogCopyWith(EpisodeLog value, $Res Function(EpisodeLog) _then) = _$EpisodeLogCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'watch_entry_id') String watchEntryId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'season_number') int seasonNumber,@JsonKey(name: 'episode_number') int episodeNumber,@JsonKey(name: 'watched_at') DateTime watchedAt,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$EpisodeLogCopyWithImpl<$Res>
    implements $EpisodeLogCopyWith<$Res> {
  _$EpisodeLogCopyWithImpl(this._self, this._then);

  final EpisodeLog _self;
  final $Res Function(EpisodeLog) _then;

/// Create a copy of EpisodeLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? watchEntryId = null,Object? userId = null,Object? seasonNumber = null,Object? episodeNumber = null,Object? watchedAt = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,watchEntryId: null == watchEntryId ? _self.watchEntryId : watchEntryId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,watchedAt: null == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EpisodeLog].
extension EpisodeLogPatterns on EpisodeLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpisodeLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpisodeLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpisodeLog value)  $default,){
final _that = this;
switch (_that) {
case _EpisodeLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpisodeLog value)?  $default,){
final _that = this;
switch (_that) {
case _EpisodeLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'watch_entry_id')  String watchEntryId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'season_number')  int seasonNumber, @JsonKey(name: 'episode_number')  int episodeNumber, @JsonKey(name: 'watched_at')  DateTime watchedAt, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpisodeLog() when $default != null:
return $default(_that.id,_that.watchEntryId,_that.userId,_that.seasonNumber,_that.episodeNumber,_that.watchedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'watch_entry_id')  String watchEntryId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'season_number')  int seasonNumber, @JsonKey(name: 'episode_number')  int episodeNumber, @JsonKey(name: 'watched_at')  DateTime watchedAt, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _EpisodeLog():
return $default(_that.id,_that.watchEntryId,_that.userId,_that.seasonNumber,_that.episodeNumber,_that.watchedAt,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'watch_entry_id')  String watchEntryId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'season_number')  int seasonNumber, @JsonKey(name: 'episode_number')  int episodeNumber, @JsonKey(name: 'watched_at')  DateTime watchedAt, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _EpisodeLog() when $default != null:
return $default(_that.id,_that.watchEntryId,_that.userId,_that.seasonNumber,_that.episodeNumber,_that.watchedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EpisodeLog implements EpisodeLog {
  const _EpisodeLog({required this.id, @JsonKey(name: 'watch_entry_id') required this.watchEntryId, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'season_number') required this.seasonNumber, @JsonKey(name: 'episode_number') required this.episodeNumber, @JsonKey(name: 'watched_at') required this.watchedAt, @JsonKey(name: 'created_at') required this.createdAt});
  factory _EpisodeLog.fromJson(Map<String, dynamic> json) => _$EpisodeLogFromJson(json);

@override final  String id;
@override@JsonKey(name: 'watch_entry_id') final  String watchEntryId;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'season_number') final  int seasonNumber;
@override@JsonKey(name: 'episode_number') final  int episodeNumber;
@override@JsonKey(name: 'watched_at') final  DateTime watchedAt;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of EpisodeLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeLogCopyWith<_EpisodeLog> get copyWith => __$EpisodeLogCopyWithImpl<_EpisodeLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EpisodeLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpisodeLog&&(identical(other.id, id) || other.id == id)&&(identical(other.watchEntryId, watchEntryId) || other.watchEntryId == watchEntryId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,watchEntryId,userId,seasonNumber,episodeNumber,watchedAt,createdAt);

@override
String toString() {
  return 'EpisodeLog(id: $id, watchEntryId: $watchEntryId, userId: $userId, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, watchedAt: $watchedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$EpisodeLogCopyWith<$Res> implements $EpisodeLogCopyWith<$Res> {
  factory _$EpisodeLogCopyWith(_EpisodeLog value, $Res Function(_EpisodeLog) _then) = __$EpisodeLogCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'watch_entry_id') String watchEntryId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'season_number') int seasonNumber,@JsonKey(name: 'episode_number') int episodeNumber,@JsonKey(name: 'watched_at') DateTime watchedAt,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$EpisodeLogCopyWithImpl<$Res>
    implements _$EpisodeLogCopyWith<$Res> {
  __$EpisodeLogCopyWithImpl(this._self, this._then);

  final _EpisodeLog _self;
  final $Res Function(_EpisodeLog) _then;

/// Create a copy of EpisodeLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? watchEntryId = null,Object? userId = null,Object? seasonNumber = null,Object? episodeNumber = null,Object? watchedAt = null,Object? createdAt = null,}) {
  return _then(_EpisodeLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,watchEntryId: null == watchEntryId ? _self.watchEntryId : watchEntryId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,watchedAt: null == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
