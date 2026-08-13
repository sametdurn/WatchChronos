// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watch_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WatchEntry {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'tmdb_id') int get tmdbId;@JsonKey(name: 'media_type') MediaType get mediaType; WatchStatus get status;@JsonKey(name: 'is_favorite') bool get isFavorite;@JsonKey(name: 'favorited_at') DateTime? get favoritedAt;// Kütüphaneden kaldırılan kayıtlar SİLİNMEZ (izlenme geçmişi/rating
// korunsun diye); sadece bu bayrak false yapılır. Kütüphane listeleri
// (Diziler/Filmler/Tamamlandı/Favoriler) hep `inLibrary == true` olan
// kayıtları gösterir; `getEntry` (detay sayfası) ise bu bayraktan
// bağımsız çalışır ki kaldırılmış bir kayda ait geçmiş yine görülebilsin.
@JsonKey(name: 'in_library') bool get inLibrary; double? get rating; String? get notes;@JsonKey(name: 'started_at') DateTime? get startedAt;@JsonKey(name: 'finished_at') DateTime? get finishedAt;@JsonKey(name: 'current_season') int? get currentSeason;@JsonKey(name: 'current_episode') int? get currentEpisode;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of WatchEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchEntryCopyWith<WatchEntry> get copyWith => _$WatchEntryCopyWithImpl<WatchEntry>(this as WatchEntry, _$identity);

  /// Serializes this WatchEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.favoritedAt, favoritedAt) || other.favoritedAt == favoritedAt)&&(identical(other.inLibrary, inLibrary) || other.inLibrary == inLibrary)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.currentSeason, currentSeason) || other.currentSeason == currentSeason)&&(identical(other.currentEpisode, currentEpisode) || other.currentEpisode == currentEpisode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,tmdbId,mediaType,status,isFavorite,favoritedAt,inLibrary,rating,notes,startedAt,finishedAt,currentSeason,currentEpisode,createdAt,updatedAt);

@override
String toString() {
  return 'WatchEntry(id: $id, userId: $userId, tmdbId: $tmdbId, mediaType: $mediaType, status: $status, isFavorite: $isFavorite, favoritedAt: $favoritedAt, inLibrary: $inLibrary, rating: $rating, notes: $notes, startedAt: $startedAt, finishedAt: $finishedAt, currentSeason: $currentSeason, currentEpisode: $currentEpisode, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $WatchEntryCopyWith<$Res>  {
  factory $WatchEntryCopyWith(WatchEntry value, $Res Function(WatchEntry) _then) = _$WatchEntryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'tmdb_id') int tmdbId,@JsonKey(name: 'media_type') MediaType mediaType, WatchStatus status,@JsonKey(name: 'is_favorite') bool isFavorite,@JsonKey(name: 'favorited_at') DateTime? favoritedAt,@JsonKey(name: 'in_library') bool inLibrary, double? rating, String? notes,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'finished_at') DateTime? finishedAt,@JsonKey(name: 'current_season') int? currentSeason,@JsonKey(name: 'current_episode') int? currentEpisode,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$WatchEntryCopyWithImpl<$Res>
    implements $WatchEntryCopyWith<$Res> {
  _$WatchEntryCopyWithImpl(this._self, this._then);

  final WatchEntry _self;
  final $Res Function(WatchEntry) _then;

/// Create a copy of WatchEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? tmdbId = null,Object? mediaType = null,Object? status = null,Object? isFavorite = null,Object? favoritedAt = freezed,Object? inLibrary = null,Object? rating = freezed,Object? notes = freezed,Object? startedAt = freezed,Object? finishedAt = freezed,Object? currentSeason = freezed,Object? currentEpisode = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WatchStatus,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,favoritedAt: freezed == favoritedAt ? _self.favoritedAt : favoritedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,inLibrary: null == inLibrary ? _self.inLibrary : inLibrary // ignore: cast_nullable_to_non_nullable
as bool,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,currentSeason: freezed == currentSeason ? _self.currentSeason : currentSeason // ignore: cast_nullable_to_non_nullable
as int?,currentEpisode: freezed == currentEpisode ? _self.currentEpisode : currentEpisode // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchEntry].
extension WatchEntryPatterns on WatchEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchEntry value)  $default,){
final _that = this;
switch (_that) {
case _WatchEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchEntry value)?  $default,){
final _that = this;
switch (_that) {
case _WatchEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'tmdb_id')  int tmdbId, @JsonKey(name: 'media_type')  MediaType mediaType,  WatchStatus status, @JsonKey(name: 'is_favorite')  bool isFavorite, @JsonKey(name: 'favorited_at')  DateTime? favoritedAt, @JsonKey(name: 'in_library')  bool inLibrary,  double? rating,  String? notes, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'finished_at')  DateTime? finishedAt, @JsonKey(name: 'current_season')  int? currentSeason, @JsonKey(name: 'current_episode')  int? currentEpisode, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchEntry() when $default != null:
return $default(_that.id,_that.userId,_that.tmdbId,_that.mediaType,_that.status,_that.isFavorite,_that.favoritedAt,_that.inLibrary,_that.rating,_that.notes,_that.startedAt,_that.finishedAt,_that.currentSeason,_that.currentEpisode,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'tmdb_id')  int tmdbId, @JsonKey(name: 'media_type')  MediaType mediaType,  WatchStatus status, @JsonKey(name: 'is_favorite')  bool isFavorite, @JsonKey(name: 'favorited_at')  DateTime? favoritedAt, @JsonKey(name: 'in_library')  bool inLibrary,  double? rating,  String? notes, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'finished_at')  DateTime? finishedAt, @JsonKey(name: 'current_season')  int? currentSeason, @JsonKey(name: 'current_episode')  int? currentEpisode, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _WatchEntry():
return $default(_that.id,_that.userId,_that.tmdbId,_that.mediaType,_that.status,_that.isFavorite,_that.favoritedAt,_that.inLibrary,_that.rating,_that.notes,_that.startedAt,_that.finishedAt,_that.currentSeason,_that.currentEpisode,_that.createdAt,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'tmdb_id')  int tmdbId, @JsonKey(name: 'media_type')  MediaType mediaType,  WatchStatus status, @JsonKey(name: 'is_favorite')  bool isFavorite, @JsonKey(name: 'favorited_at')  DateTime? favoritedAt, @JsonKey(name: 'in_library')  bool inLibrary,  double? rating,  String? notes, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'finished_at')  DateTime? finishedAt, @JsonKey(name: 'current_season')  int? currentSeason, @JsonKey(name: 'current_episode')  int? currentEpisode, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _WatchEntry() when $default != null:
return $default(_that.id,_that.userId,_that.tmdbId,_that.mediaType,_that.status,_that.isFavorite,_that.favoritedAt,_that.inLibrary,_that.rating,_that.notes,_that.startedAt,_that.finishedAt,_that.currentSeason,_that.currentEpisode,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WatchEntry implements WatchEntry {
  const _WatchEntry({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'tmdb_id') required this.tmdbId, @JsonKey(name: 'media_type') required this.mediaType, this.status = WatchStatus.planned, @JsonKey(name: 'is_favorite') this.isFavorite = false, @JsonKey(name: 'favorited_at') this.favoritedAt, @JsonKey(name: 'in_library') this.inLibrary = true, this.rating, this.notes, @JsonKey(name: 'started_at') this.startedAt, @JsonKey(name: 'finished_at') this.finishedAt, @JsonKey(name: 'current_season') this.currentSeason, @JsonKey(name: 'current_episode') this.currentEpisode, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _WatchEntry.fromJson(Map<String, dynamic> json) => _$WatchEntryFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'tmdb_id') final  int tmdbId;
@override@JsonKey(name: 'media_type') final  MediaType mediaType;
@override@JsonKey() final  WatchStatus status;
@override@JsonKey(name: 'is_favorite') final  bool isFavorite;
@override@JsonKey(name: 'favorited_at') final  DateTime? favoritedAt;
// Kütüphaneden kaldırılan kayıtlar SİLİNMEZ (izlenme geçmişi/rating
// korunsun diye); sadece bu bayrak false yapılır. Kütüphane listeleri
// (Diziler/Filmler/Tamamlandı/Favoriler) hep `inLibrary == true` olan
// kayıtları gösterir; `getEntry` (detay sayfası) ise bu bayraktan
// bağımsız çalışır ki kaldırılmış bir kayda ait geçmiş yine görülebilsin.
@override@JsonKey(name: 'in_library') final  bool inLibrary;
@override final  double? rating;
@override final  String? notes;
@override@JsonKey(name: 'started_at') final  DateTime? startedAt;
@override@JsonKey(name: 'finished_at') final  DateTime? finishedAt;
@override@JsonKey(name: 'current_season') final  int? currentSeason;
@override@JsonKey(name: 'current_episode') final  int? currentEpisode;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of WatchEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchEntryCopyWith<_WatchEntry> get copyWith => __$WatchEntryCopyWithImpl<_WatchEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.favoritedAt, favoritedAt) || other.favoritedAt == favoritedAt)&&(identical(other.inLibrary, inLibrary) || other.inLibrary == inLibrary)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.currentSeason, currentSeason) || other.currentSeason == currentSeason)&&(identical(other.currentEpisode, currentEpisode) || other.currentEpisode == currentEpisode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,tmdbId,mediaType,status,isFavorite,favoritedAt,inLibrary,rating,notes,startedAt,finishedAt,currentSeason,currentEpisode,createdAt,updatedAt);

@override
String toString() {
  return 'WatchEntry(id: $id, userId: $userId, tmdbId: $tmdbId, mediaType: $mediaType, status: $status, isFavorite: $isFavorite, favoritedAt: $favoritedAt, inLibrary: $inLibrary, rating: $rating, notes: $notes, startedAt: $startedAt, finishedAt: $finishedAt, currentSeason: $currentSeason, currentEpisode: $currentEpisode, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WatchEntryCopyWith<$Res> implements $WatchEntryCopyWith<$Res> {
  factory _$WatchEntryCopyWith(_WatchEntry value, $Res Function(_WatchEntry) _then) = __$WatchEntryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'tmdb_id') int tmdbId,@JsonKey(name: 'media_type') MediaType mediaType, WatchStatus status,@JsonKey(name: 'is_favorite') bool isFavorite,@JsonKey(name: 'favorited_at') DateTime? favoritedAt,@JsonKey(name: 'in_library') bool inLibrary, double? rating, String? notes,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'finished_at') DateTime? finishedAt,@JsonKey(name: 'current_season') int? currentSeason,@JsonKey(name: 'current_episode') int? currentEpisode,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$WatchEntryCopyWithImpl<$Res>
    implements _$WatchEntryCopyWith<$Res> {
  __$WatchEntryCopyWithImpl(this._self, this._then);

  final _WatchEntry _self;
  final $Res Function(_WatchEntry) _then;

/// Create a copy of WatchEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? tmdbId = null,Object? mediaType = null,Object? status = null,Object? isFavorite = null,Object? favoritedAt = freezed,Object? inLibrary = null,Object? rating = freezed,Object? notes = freezed,Object? startedAt = freezed,Object? finishedAt = freezed,Object? currentSeason = freezed,Object? currentEpisode = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_WatchEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WatchStatus,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,favoritedAt: freezed == favoritedAt ? _self.favoritedAt : favoritedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,inLibrary: null == inLibrary ? _self.inLibrary : inLibrary // ignore: cast_nullable_to_non_nullable
as bool,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,currentSeason: freezed == currentSeason ? _self.currentSeason : currentSeason // ignore: cast_nullable_to_non_nullable
as int?,currentEpisode: freezed == currentEpisode ? _self.currentEpisode : currentEpisode // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
