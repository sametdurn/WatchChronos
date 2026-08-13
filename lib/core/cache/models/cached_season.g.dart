// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_season.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCachedSeasonCollection on Isar {
  IsarCollection<CachedSeason> get cachedSeasons => this.collection();
}

const CachedSeasonSchema = CollectionSchema(
  name: r'CachedSeason',
  id: -2974745383696949431,
  properties: {
    r'cachedAt': PropertySchema(
      id: 0,
      name: r'cachedAt',
      type: IsarType.dateTime,
    ),
    r'episodes': PropertySchema(
      id: 1,
      name: r'episodes',
      type: IsarType.objectList,

      target: r'CachedEpisode',
    ),
    r'seasonNumber': PropertySchema(
      id: 2,
      name: r'seasonNumber',
      type: IsarType.long,
    ),
    r'tvId': PropertySchema(id: 3, name: r'tvId', type: IsarType.long),
  },

  estimateSize: _cachedSeasonEstimateSize,
  serialize: _cachedSeasonSerialize,
  deserialize: _cachedSeasonDeserialize,
  deserializeProp: _cachedSeasonDeserializeProp,
  idName: r'id',
  indexes: {
    r'tvId_seasonNumber': IndexSchema(
      id: -7655145890713255717,
      name: r'tvId_seasonNumber',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tvId',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'seasonNumber',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {r'CachedEpisode': CachedEpisodeSchema},

  getId: _cachedSeasonGetId,
  getLinks: _cachedSeasonGetLinks,
  attach: _cachedSeasonAttach,
  version: '3.3.2',
);

int _cachedSeasonEstimateSize(
  CachedSeason object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.episodes.length * 3;
  {
    final offsets = allOffsets[CachedEpisode]!;
    for (var i = 0; i < object.episodes.length; i++) {
      final value = object.episodes[i];
      bytesCount += CachedEpisodeSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  return bytesCount;
}

void _cachedSeasonSerialize(
  CachedSeason object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.cachedAt);
  writer.writeObjectList<CachedEpisode>(
    offsets[1],
    allOffsets,
    CachedEpisodeSchema.serialize,
    object.episodes,
  );
  writer.writeLong(offsets[2], object.seasonNumber);
  writer.writeLong(offsets[3], object.tvId);
}

CachedSeason _cachedSeasonDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CachedSeason();
  object.cachedAt = reader.readDateTime(offsets[0]);
  object.episodes =
      reader.readObjectList<CachedEpisode>(
        offsets[1],
        CachedEpisodeSchema.deserialize,
        allOffsets,
        CachedEpisode(),
      ) ??
      [];
  object.id = id;
  object.seasonNumber = reader.readLong(offsets[2]);
  object.tvId = reader.readLong(offsets[3]);
  return object;
}

P _cachedSeasonDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readObjectList<CachedEpisode>(
                offset,
                CachedEpisodeSchema.deserialize,
                allOffsets,
                CachedEpisode(),
              ) ??
              [])
          as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cachedSeasonGetId(CachedSeason object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cachedSeasonGetLinks(CachedSeason object) {
  return [];
}

void _cachedSeasonAttach(
  IsarCollection<dynamic> col,
  Id id,
  CachedSeason object,
) {
  object.id = id;
}

extension CachedSeasonByIndex on IsarCollection<CachedSeason> {
  Future<CachedSeason?> getByTvIdSeasonNumber(int tvId, int seasonNumber) {
    return getByIndex(r'tvId_seasonNumber', [tvId, seasonNumber]);
  }

  CachedSeason? getByTvIdSeasonNumberSync(int tvId, int seasonNumber) {
    return getByIndexSync(r'tvId_seasonNumber', [tvId, seasonNumber]);
  }

  Future<bool> deleteByTvIdSeasonNumber(int tvId, int seasonNumber) {
    return deleteByIndex(r'tvId_seasonNumber', [tvId, seasonNumber]);
  }

  bool deleteByTvIdSeasonNumberSync(int tvId, int seasonNumber) {
    return deleteByIndexSync(r'tvId_seasonNumber', [tvId, seasonNumber]);
  }

  Future<List<CachedSeason?>> getAllByTvIdSeasonNumber(
    List<int> tvIdValues,
    List<int> seasonNumberValues,
  ) {
    final len = tvIdValues.length;
    assert(
      seasonNumberValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tvIdValues[i], seasonNumberValues[i]]);
    }

    return getAllByIndex(r'tvId_seasonNumber', values);
  }

  List<CachedSeason?> getAllByTvIdSeasonNumberSync(
    List<int> tvIdValues,
    List<int> seasonNumberValues,
  ) {
    final len = tvIdValues.length;
    assert(
      seasonNumberValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tvIdValues[i], seasonNumberValues[i]]);
    }

    return getAllByIndexSync(r'tvId_seasonNumber', values);
  }

  Future<int> deleteAllByTvIdSeasonNumber(
    List<int> tvIdValues,
    List<int> seasonNumberValues,
  ) {
    final len = tvIdValues.length;
    assert(
      seasonNumberValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tvIdValues[i], seasonNumberValues[i]]);
    }

    return deleteAllByIndex(r'tvId_seasonNumber', values);
  }

  int deleteAllByTvIdSeasonNumberSync(
    List<int> tvIdValues,
    List<int> seasonNumberValues,
  ) {
    final len = tvIdValues.length;
    assert(
      seasonNumberValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tvIdValues[i], seasonNumberValues[i]]);
    }

    return deleteAllByIndexSync(r'tvId_seasonNumber', values);
  }

  Future<Id> putByTvIdSeasonNumber(CachedSeason object) {
    return putByIndex(r'tvId_seasonNumber', object);
  }

  Id putByTvIdSeasonNumberSync(CachedSeason object, {bool saveLinks = true}) {
    return putByIndexSync(r'tvId_seasonNumber', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTvIdSeasonNumber(List<CachedSeason> objects) {
    return putAllByIndex(r'tvId_seasonNumber', objects);
  }

  List<Id> putAllByTvIdSeasonNumberSync(
    List<CachedSeason> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(
      r'tvId_seasonNumber',
      objects,
      saveLinks: saveLinks,
    );
  }
}

extension CachedSeasonQueryWhereSort
    on QueryBuilder<CachedSeason, CachedSeason, QWhere> {
  QueryBuilder<CachedSeason, CachedSeason, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterWhere> anyTvIdSeasonNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'tvId_seasonNumber'),
      );
    });
  }
}

extension CachedSeasonQueryWhere
    on QueryBuilder<CachedSeason, CachedSeason, QWhereClause> {
  QueryBuilder<CachedSeason, CachedSeason, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<CachedSeason, CachedSeason, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterWhereClause> idBetween(
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

  QueryBuilder<CachedSeason, CachedSeason, QAfterWhereClause>
  tvIdEqualToAnySeasonNumber(int tvId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'tvId_seasonNumber',
          value: [tvId],
        ),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterWhereClause>
  tvIdNotEqualToAnySeasonNumber(int tvId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tvId_seasonNumber',
                lower: [],
                upper: [tvId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tvId_seasonNumber',
                lower: [tvId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tvId_seasonNumber',
                lower: [tvId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tvId_seasonNumber',
                lower: [],
                upper: [tvId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterWhereClause>
  tvIdGreaterThanAnySeasonNumber(int tvId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tvId_seasonNumber',
          lower: [tvId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterWhereClause>
  tvIdLessThanAnySeasonNumber(int tvId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tvId_seasonNumber',
          lower: [],
          upper: [tvId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterWhereClause>
  tvIdBetweenAnySeasonNumber(
    int lowerTvId,
    int upperTvId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tvId_seasonNumber',
          lower: [lowerTvId],
          includeLower: includeLower,
          upper: [upperTvId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterWhereClause>
  tvIdSeasonNumberEqualTo(int tvId, int seasonNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'tvId_seasonNumber',
          value: [tvId, seasonNumber],
        ),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterWhereClause>
  tvIdEqualToSeasonNumberNotEqualTo(int tvId, int seasonNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tvId_seasonNumber',
                lower: [tvId],
                upper: [tvId, seasonNumber],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tvId_seasonNumber',
                lower: [tvId, seasonNumber],
                includeLower: false,
                upper: [tvId],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tvId_seasonNumber',
                lower: [tvId, seasonNumber],
                includeLower: false,
                upper: [tvId],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tvId_seasonNumber',
                lower: [tvId],
                upper: [tvId, seasonNumber],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterWhereClause>
  tvIdEqualToSeasonNumberGreaterThan(
    int tvId,
    int seasonNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tvId_seasonNumber',
          lower: [tvId, seasonNumber],
          includeLower: include,
          upper: [tvId],
        ),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterWhereClause>
  tvIdEqualToSeasonNumberLessThan(
    int tvId,
    int seasonNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tvId_seasonNumber',
          lower: [tvId],
          upper: [tvId, seasonNumber],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterWhereClause>
  tvIdEqualToSeasonNumberBetween(
    int tvId,
    int lowerSeasonNumber,
    int upperSeasonNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tvId_seasonNumber',
          lower: [tvId, lowerSeasonNumber],
          includeLower: includeLower,
          upper: [tvId, upperSeasonNumber],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension CachedSeasonQueryFilter
    on QueryBuilder<CachedSeason, CachedSeason, QFilterCondition> {
  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
  cachedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cachedAt', value: value),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
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

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
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

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
  cachedAtBetween(
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

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
  episodesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'episodes', length, true, length, true);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
  episodesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'episodes', 0, true, 0, true);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
  episodesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'episodes', 0, false, 999999, true);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
  episodesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'episodes', 0, true, length, include);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
  episodesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'episodes', length, include, 999999, true);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
  episodesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'episodes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
  seasonNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'seasonNumber', value: value),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
  seasonNumberGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'seasonNumber',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
  seasonNumberLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'seasonNumber',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
  seasonNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'seasonNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition> tvIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tvId', value: value),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
  tvIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tvId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition> tvIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tvId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition> tvIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tvId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension CachedSeasonQueryObject
    on QueryBuilder<CachedSeason, CachedSeason, QFilterCondition> {
  QueryBuilder<CachedSeason, CachedSeason, QAfterFilterCondition>
  episodesElement(FilterQuery<CachedEpisode> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'episodes');
    });
  }
}

extension CachedSeasonQueryLinks
    on QueryBuilder<CachedSeason, CachedSeason, QFilterCondition> {}

extension CachedSeasonQuerySortBy
    on QueryBuilder<CachedSeason, CachedSeason, QSortBy> {
  QueryBuilder<CachedSeason, CachedSeason, QAfterSortBy> sortByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterSortBy> sortByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterSortBy> sortBySeasonNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonNumber', Sort.asc);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterSortBy>
  sortBySeasonNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonNumber', Sort.desc);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterSortBy> sortByTvId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvId', Sort.asc);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterSortBy> sortByTvIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvId', Sort.desc);
    });
  }
}

extension CachedSeasonQuerySortThenBy
    on QueryBuilder<CachedSeason, CachedSeason, QSortThenBy> {
  QueryBuilder<CachedSeason, CachedSeason, QAfterSortBy> thenByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterSortBy> thenByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterSortBy> thenBySeasonNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonNumber', Sort.asc);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterSortBy>
  thenBySeasonNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonNumber', Sort.desc);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterSortBy> thenByTvId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvId', Sort.asc);
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QAfterSortBy> thenByTvIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvId', Sort.desc);
    });
  }
}

extension CachedSeasonQueryWhereDistinct
    on QueryBuilder<CachedSeason, CachedSeason, QDistinct> {
  QueryBuilder<CachedSeason, CachedSeason, QDistinct> distinctByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAt');
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QDistinct> distinctBySeasonNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seasonNumber');
    });
  }

  QueryBuilder<CachedSeason, CachedSeason, QDistinct> distinctByTvId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tvId');
    });
  }
}

extension CachedSeasonQueryProperty
    on QueryBuilder<CachedSeason, CachedSeason, QQueryProperty> {
  QueryBuilder<CachedSeason, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CachedSeason, DateTime, QQueryOperations> cachedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAt');
    });
  }

  QueryBuilder<CachedSeason, List<CachedEpisode>, QQueryOperations>
  episodesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodes');
    });
  }

  QueryBuilder<CachedSeason, int, QQueryOperations> seasonNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seasonNumber');
    });
  }

  QueryBuilder<CachedSeason, int, QQueryOperations> tvIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tvId');
    });
  }
}
