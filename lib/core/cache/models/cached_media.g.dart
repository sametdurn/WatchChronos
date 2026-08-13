// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_media.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCachedMediaCollection on Isar {
  IsarCollection<CachedMedia> get cachedMedias => this.collection();
}

const CachedMediaSchema = CollectionSchema(
  name: r'CachedMedia',
  id: 8490903306040159956,
  properties: {
    r'backdropPath': PropertySchema(
      id: 0,
      name: r'backdropPath',
      type: IsarType.string,
    ),
    r'cachedAt': PropertySchema(
      id: 1,
      name: r'cachedAt',
      type: IsarType.dateTime,
    ),
    r'firstAirDate': PropertySchema(
      id: 2,
      name: r'firstAirDate',
      type: IsarType.dateTime,
    ),
    r'genres': PropertySchema(
      id: 3,
      name: r'genres',
      type: IsarType.stringList,
    ),
    r'mediaType': PropertySchema(
      id: 4,
      name: r'mediaType',
      type: IsarType.byte,
      enumMap: _CachedMediamediaTypeEnumValueMap,
    ),
    r'numberOfEpisodes': PropertySchema(
      id: 5,
      name: r'numberOfEpisodes',
      type: IsarType.long,
    ),
    r'numberOfSeasons': PropertySchema(
      id: 6,
      name: r'numberOfSeasons',
      type: IsarType.long,
    ),
    r'overview': PropertySchema(
      id: 7,
      name: r'overview',
      type: IsarType.string,
    ),
    r'posterPath': PropertySchema(
      id: 8,
      name: r'posterPath',
      type: IsarType.string,
    ),
    r'releaseDate': PropertySchema(
      id: 9,
      name: r'releaseDate',
      type: IsarType.dateTime,
    ),
    r'runtimeMinutes': PropertySchema(
      id: 10,
      name: r'runtimeMinutes',
      type: IsarType.long,
    ),
    r'status': PropertySchema(id: 11, name: r'status', type: IsarType.string),
    r'title': PropertySchema(id: 12, name: r'title', type: IsarType.string),
    r'tmdbId': PropertySchema(id: 13, name: r'tmdbId', type: IsarType.long),
    r'voteAverage': PropertySchema(
      id: 14,
      name: r'voteAverage',
      type: IsarType.double,
    ),
  },

  estimateSize: _cachedMediaEstimateSize,
  serialize: _cachedMediaSerialize,
  deserialize: _cachedMediaDeserialize,
  deserializeProp: _cachedMediaDeserializeProp,
  idName: r'id',
  indexes: {
    r'tmdbId_mediaType': IndexSchema(
      id: 2073878694496381786,
      name: r'tmdbId_mediaType',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tmdbId',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'mediaType',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _cachedMediaGetId,
  getLinks: _cachedMediaGetLinks,
  attach: _cachedMediaAttach,
  version: '3.3.2',
);

int _cachedMediaEstimateSize(
  CachedMedia object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.backdropPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.genres.length * 3;
  {
    for (var i = 0; i < object.genres.length; i++) {
      final value = object.genres[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.overview;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.posterPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.status;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _cachedMediaSerialize(
  CachedMedia object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.backdropPath);
  writer.writeDateTime(offsets[1], object.cachedAt);
  writer.writeDateTime(offsets[2], object.firstAirDate);
  writer.writeStringList(offsets[3], object.genres);
  writer.writeByte(offsets[4], object.mediaType.index);
  writer.writeLong(offsets[5], object.numberOfEpisodes);
  writer.writeLong(offsets[6], object.numberOfSeasons);
  writer.writeString(offsets[7], object.overview);
  writer.writeString(offsets[8], object.posterPath);
  writer.writeDateTime(offsets[9], object.releaseDate);
  writer.writeLong(offsets[10], object.runtimeMinutes);
  writer.writeString(offsets[11], object.status);
  writer.writeString(offsets[12], object.title);
  writer.writeLong(offsets[13], object.tmdbId);
  writer.writeDouble(offsets[14], object.voteAverage);
}

CachedMedia _cachedMediaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CachedMedia();
  object.backdropPath = reader.readStringOrNull(offsets[0]);
  object.cachedAt = reader.readDateTime(offsets[1]);
  object.firstAirDate = reader.readDateTimeOrNull(offsets[2]);
  object.genres = reader.readStringList(offsets[3]) ?? [];
  object.id = id;
  object.mediaType =
      _CachedMediamediaTypeValueEnumMap[reader.readByteOrNull(offsets[4])] ??
      MediaType.movie;
  object.numberOfEpisodes = reader.readLongOrNull(offsets[5]);
  object.numberOfSeasons = reader.readLongOrNull(offsets[6]);
  object.overview = reader.readStringOrNull(offsets[7]);
  object.posterPath = reader.readStringOrNull(offsets[8]);
  object.releaseDate = reader.readDateTimeOrNull(offsets[9]);
  object.runtimeMinutes = reader.readLongOrNull(offsets[10]);
  object.status = reader.readStringOrNull(offsets[11]);
  object.title = reader.readString(offsets[12]);
  object.tmdbId = reader.readLong(offsets[13]);
  object.voteAverage = reader.readDoubleOrNull(offsets[14]);
  return object;
}

P _cachedMediaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (_CachedMediamediaTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              MediaType.movie)
          as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CachedMediamediaTypeEnumValueMap = {'movie': 0, 'tv': 1};
const _CachedMediamediaTypeValueEnumMap = {0: MediaType.movie, 1: MediaType.tv};

Id _cachedMediaGetId(CachedMedia object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cachedMediaGetLinks(CachedMedia object) {
  return [];
}

void _cachedMediaAttach(
  IsarCollection<dynamic> col,
  Id id,
  CachedMedia object,
) {
  object.id = id;
}

extension CachedMediaByIndex on IsarCollection<CachedMedia> {
  Future<CachedMedia?> getByTmdbIdMediaType(int tmdbId, MediaType mediaType) {
    return getByIndex(r'tmdbId_mediaType', [tmdbId, mediaType]);
  }

  CachedMedia? getByTmdbIdMediaTypeSync(int tmdbId, MediaType mediaType) {
    return getByIndexSync(r'tmdbId_mediaType', [tmdbId, mediaType]);
  }

  Future<bool> deleteByTmdbIdMediaType(int tmdbId, MediaType mediaType) {
    return deleteByIndex(r'tmdbId_mediaType', [tmdbId, mediaType]);
  }

  bool deleteByTmdbIdMediaTypeSync(int tmdbId, MediaType mediaType) {
    return deleteByIndexSync(r'tmdbId_mediaType', [tmdbId, mediaType]);
  }

  Future<List<CachedMedia?>> getAllByTmdbIdMediaType(
    List<int> tmdbIdValues,
    List<MediaType> mediaTypeValues,
  ) {
    final len = tmdbIdValues.length;
    assert(
      mediaTypeValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tmdbIdValues[i], mediaTypeValues[i]]);
    }

    return getAllByIndex(r'tmdbId_mediaType', values);
  }

  List<CachedMedia?> getAllByTmdbIdMediaTypeSync(
    List<int> tmdbIdValues,
    List<MediaType> mediaTypeValues,
  ) {
    final len = tmdbIdValues.length;
    assert(
      mediaTypeValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tmdbIdValues[i], mediaTypeValues[i]]);
    }

    return getAllByIndexSync(r'tmdbId_mediaType', values);
  }

  Future<int> deleteAllByTmdbIdMediaType(
    List<int> tmdbIdValues,
    List<MediaType> mediaTypeValues,
  ) {
    final len = tmdbIdValues.length;
    assert(
      mediaTypeValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tmdbIdValues[i], mediaTypeValues[i]]);
    }

    return deleteAllByIndex(r'tmdbId_mediaType', values);
  }

  int deleteAllByTmdbIdMediaTypeSync(
    List<int> tmdbIdValues,
    List<MediaType> mediaTypeValues,
  ) {
    final len = tmdbIdValues.length;
    assert(
      mediaTypeValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tmdbIdValues[i], mediaTypeValues[i]]);
    }

    return deleteAllByIndexSync(r'tmdbId_mediaType', values);
  }

  Future<Id> putByTmdbIdMediaType(CachedMedia object) {
    return putByIndex(r'tmdbId_mediaType', object);
  }

  Id putByTmdbIdMediaTypeSync(CachedMedia object, {bool saveLinks = true}) {
    return putByIndexSync(r'tmdbId_mediaType', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTmdbIdMediaType(List<CachedMedia> objects) {
    return putAllByIndex(r'tmdbId_mediaType', objects);
  }

  List<Id> putAllByTmdbIdMediaTypeSync(
    List<CachedMedia> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(
      r'tmdbId_mediaType',
      objects,
      saveLinks: saveLinks,
    );
  }
}

extension CachedMediaQueryWhereSort
    on QueryBuilder<CachedMedia, CachedMedia, QWhere> {
  QueryBuilder<CachedMedia, CachedMedia, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterWhere> anyTmdbIdMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'tmdbId_mediaType'),
      );
    });
  }
}

extension CachedMediaQueryWhere
    on QueryBuilder<CachedMedia, CachedMedia, QWhereClause> {
  QueryBuilder<CachedMedia, CachedMedia, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterWhereClause>
  tmdbIdEqualToAnyMediaType(int tmdbId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'tmdbId_mediaType',
          value: [tmdbId],
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterWhereClause>
  tmdbIdNotEqualToAnyMediaType(int tmdbId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tmdbId_mediaType',
                lower: [],
                upper: [tmdbId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tmdbId_mediaType',
                lower: [tmdbId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tmdbId_mediaType',
                lower: [tmdbId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tmdbId_mediaType',
                lower: [],
                upper: [tmdbId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterWhereClause>
  tmdbIdGreaterThanAnyMediaType(int tmdbId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tmdbId_mediaType',
          lower: [tmdbId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterWhereClause>
  tmdbIdLessThanAnyMediaType(int tmdbId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tmdbId_mediaType',
          lower: [],
          upper: [tmdbId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterWhereClause>
  tmdbIdBetweenAnyMediaType(
    int lowerTmdbId,
    int upperTmdbId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tmdbId_mediaType',
          lower: [lowerTmdbId],
          includeLower: includeLower,
          upper: [upperTmdbId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterWhereClause>
  tmdbIdMediaTypeEqualTo(int tmdbId, MediaType mediaType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'tmdbId_mediaType',
          value: [tmdbId, mediaType],
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterWhereClause>
  tmdbIdEqualToMediaTypeNotEqualTo(int tmdbId, MediaType mediaType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tmdbId_mediaType',
                lower: [tmdbId],
                upper: [tmdbId, mediaType],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tmdbId_mediaType',
                lower: [tmdbId, mediaType],
                includeLower: false,
                upper: [tmdbId],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tmdbId_mediaType',
                lower: [tmdbId, mediaType],
                includeLower: false,
                upper: [tmdbId],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tmdbId_mediaType',
                lower: [tmdbId],
                upper: [tmdbId, mediaType],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterWhereClause>
  tmdbIdEqualToMediaTypeGreaterThan(
    int tmdbId,
    MediaType mediaType, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tmdbId_mediaType',
          lower: [tmdbId, mediaType],
          includeLower: include,
          upper: [tmdbId],
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterWhereClause>
  tmdbIdEqualToMediaTypeLessThan(
    int tmdbId,
    MediaType mediaType, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tmdbId_mediaType',
          lower: [tmdbId],
          upper: [tmdbId, mediaType],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterWhereClause>
  tmdbIdEqualToMediaTypeBetween(
    int tmdbId,
    MediaType lowerMediaType,
    MediaType upperMediaType, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tmdbId_mediaType',
          lower: [tmdbId, lowerMediaType],
          includeLower: includeLower,
          upper: [tmdbId, upperMediaType],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension CachedMediaQueryFilter
    on QueryBuilder<CachedMedia, CachedMedia, QFilterCondition> {
  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  backdropPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backdropPath'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  backdropPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backdropPath'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  backdropPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'backdropPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  backdropPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backdropPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  backdropPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backdropPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  backdropPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backdropPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  backdropPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'backdropPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  backdropPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'backdropPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  backdropPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'backdropPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  backdropPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'backdropPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  backdropPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backdropPath', value: ''),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  backdropPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'backdropPath', value: ''),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> cachedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cachedAt', value: value),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  cachedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cachedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  cachedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cachedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> cachedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cachedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  firstAirDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'firstAirDate'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  firstAirDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'firstAirDate'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  firstAirDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'firstAirDate', value: value),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  firstAirDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'firstAirDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  firstAirDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'firstAirDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  firstAirDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'firstAirDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'genres',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'genres',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'genres', value: ''),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'genres', value: ''),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', length, true, length, true);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', 0, true, 0, true);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', 0, false, 999999, true);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', 0, true, length, include);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', length, include, 999999, true);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  genresLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  mediaTypeEqualTo(MediaType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mediaType', value: value),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  mediaTypeGreaterThan(MediaType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mediaType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  mediaTypeLessThan(MediaType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mediaType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  mediaTypeBetween(
    MediaType lower,
    MediaType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mediaType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  numberOfEpisodesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'numberOfEpisodes'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  numberOfEpisodesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'numberOfEpisodes'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  numberOfEpisodesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'numberOfEpisodes', value: value),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  numberOfEpisodesGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'numberOfEpisodes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  numberOfEpisodesLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'numberOfEpisodes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  numberOfEpisodesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'numberOfEpisodes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  numberOfSeasonsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'numberOfSeasons'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  numberOfSeasonsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'numberOfSeasons'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  numberOfSeasonsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'numberOfSeasons', value: value),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  numberOfSeasonsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'numberOfSeasons',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  numberOfSeasonsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'numberOfSeasons',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  numberOfSeasonsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'numberOfSeasons',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  overviewIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'overview'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  overviewIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'overview'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> overviewEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'overview',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  overviewGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'overview',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  overviewLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'overview',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> overviewBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'overview',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  overviewStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'overview',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  overviewEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'overview',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  overviewContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'overview',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> overviewMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'overview',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  overviewIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'overview', value: ''),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  overviewIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'overview', value: ''),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  posterPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'posterPath'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  posterPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'posterPath'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  posterPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'posterPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  posterPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'posterPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  posterPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'posterPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  posterPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'posterPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  posterPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'posterPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  posterPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'posterPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  posterPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'posterPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  posterPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'posterPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  posterPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'posterPath', value: ''),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  posterPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'posterPath', value: ''),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  releaseDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'releaseDate'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  releaseDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'releaseDate'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  releaseDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'releaseDate', value: value),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  releaseDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'releaseDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  releaseDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'releaseDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  releaseDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'releaseDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  runtimeMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'runtimeMinutes'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  runtimeMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'runtimeMinutes'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  runtimeMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'runtimeMinutes', value: value),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  runtimeMinutesGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'runtimeMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  runtimeMinutesLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'runtimeMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  runtimeMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'runtimeMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'status'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'status'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> statusEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  statusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> statusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> statusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  statusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> statusContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> statusMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> titleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> titleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> tmdbIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tmdbId', value: value),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  tmdbIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tmdbId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> tmdbIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tmdbId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition> tmdbIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tmdbId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  voteAverageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'voteAverage'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  voteAverageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'voteAverage'),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  voteAverageEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'voteAverage',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  voteAverageGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'voteAverage',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  voteAverageLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'voteAverage',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterFilterCondition>
  voteAverageBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'voteAverage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension CachedMediaQueryObject
    on QueryBuilder<CachedMedia, CachedMedia, QFilterCondition> {}

extension CachedMediaQueryLinks
    on QueryBuilder<CachedMedia, CachedMedia, QFilterCondition> {}

extension CachedMediaQuerySortBy
    on QueryBuilder<CachedMedia, CachedMedia, QSortBy> {
  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByBackdropPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy>
  sortByBackdropPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByFirstAirDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstAirDate', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy>
  sortByFirstAirDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstAirDate', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy>
  sortByNumberOfEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfEpisodes', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy>
  sortByNumberOfEpisodesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfEpisodes', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByNumberOfSeasons() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfSeasons', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy>
  sortByNumberOfSeasonsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfSeasons', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByOverview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByOverviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByPosterPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByPosterPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByReleaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByReleaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByRuntimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy>
  sortByRuntimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> sortByVoteAverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.desc);
    });
  }
}

extension CachedMediaQuerySortThenBy
    on QueryBuilder<CachedMedia, CachedMedia, QSortThenBy> {
  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByBackdropPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy>
  thenByBackdropPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByFirstAirDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstAirDate', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy>
  thenByFirstAirDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstAirDate', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy>
  thenByNumberOfEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfEpisodes', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy>
  thenByNumberOfEpisodesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfEpisodes', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByNumberOfSeasons() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfSeasons', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy>
  thenByNumberOfSeasonsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfSeasons', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByOverview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByOverviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overview', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByPosterPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByPosterPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByReleaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByReleaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByRuntimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy>
  thenByRuntimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.asc);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QAfterSortBy> thenByVoteAverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.desc);
    });
  }
}

extension CachedMediaQueryWhereDistinct
    on QueryBuilder<CachedMedia, CachedMedia, QDistinct> {
  QueryBuilder<CachedMedia, CachedMedia, QDistinct> distinctByBackdropPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backdropPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QDistinct> distinctByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAt');
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QDistinct> distinctByFirstAirDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstAirDate');
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QDistinct> distinctByGenres() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genres');
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QDistinct> distinctByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaType');
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QDistinct>
  distinctByNumberOfEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numberOfEpisodes');
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QDistinct>
  distinctByNumberOfSeasons() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numberOfSeasons');
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QDistinct> distinctByOverview({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overview', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QDistinct> distinctByPosterPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QDistinct> distinctByReleaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'releaseDate');
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QDistinct> distinctByRuntimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runtimeMinutes');
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QDistinct> distinctByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tmdbId');
    });
  }

  QueryBuilder<CachedMedia, CachedMedia, QDistinct> distinctByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voteAverage');
    });
  }
}

extension CachedMediaQueryProperty
    on QueryBuilder<CachedMedia, CachedMedia, QQueryProperty> {
  QueryBuilder<CachedMedia, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CachedMedia, String?, QQueryOperations> backdropPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backdropPath');
    });
  }

  QueryBuilder<CachedMedia, DateTime, QQueryOperations> cachedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAt');
    });
  }

  QueryBuilder<CachedMedia, DateTime?, QQueryOperations>
  firstAirDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstAirDate');
    });
  }

  QueryBuilder<CachedMedia, List<String>, QQueryOperations> genresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genres');
    });
  }

  QueryBuilder<CachedMedia, MediaType, QQueryOperations> mediaTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaType');
    });
  }

  QueryBuilder<CachedMedia, int?, QQueryOperations> numberOfEpisodesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numberOfEpisodes');
    });
  }

  QueryBuilder<CachedMedia, int?, QQueryOperations> numberOfSeasonsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numberOfSeasons');
    });
  }

  QueryBuilder<CachedMedia, String?, QQueryOperations> overviewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overview');
    });
  }

  QueryBuilder<CachedMedia, String?, QQueryOperations> posterPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterPath');
    });
  }

  QueryBuilder<CachedMedia, DateTime?, QQueryOperations> releaseDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'releaseDate');
    });
  }

  QueryBuilder<CachedMedia, int?, QQueryOperations> runtimeMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runtimeMinutes');
    });
  }

  QueryBuilder<CachedMedia, String?, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<CachedMedia, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<CachedMedia, int, QQueryOperations> tmdbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tmdbId');
    });
  }

  QueryBuilder<CachedMedia, double?, QQueryOperations> voteAverageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voteAverage');
    });
  }
}
