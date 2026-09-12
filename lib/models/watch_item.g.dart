// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWatchItemCollection on Isar {
  IsarCollection<WatchItem> get watchItems => this.collection();
}

const WatchItemSchema = CollectionSchema(
  name: r'WatchItem',
  id: 5203928110918731371,
  properties: {
    r'dateAdded': PropertySchema(
      id: 0,
      name: r'dateAdded',
      type: IsarType.dateTime,
    ),
    r'dateCompleted': PropertySchema(
      id: 1,
      name: r'dateCompleted',
      type: IsarType.dateTime,
    ),
    r'genres': PropertySchema(
      id: 2,
      name: r'genres',
      type: IsarType.stringList,
    ),
    r'notes': PropertySchema(id: 3, name: r'notes', type: IsarType.string),
    r'posterPath': PropertySchema(
      id: 4,
      name: r'posterPath',
      type: IsarType.string,
    ),
    r'progressCurrent': PropertySchema(
      id: 5,
      name: r'progressCurrent',
      type: IsarType.long,
    ),
    r'progressTotal': PropertySchema(
      id: 6,
      name: r'progressTotal',
      type: IsarType.long,
    ),
    r'rating': PropertySchema(id: 7, name: r'rating', type: IsarType.double),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.byte,
      enumMap: _WatchItemstatusEnumValueMap,
    ),
    r'title': PropertySchema(id: 9, name: r'title', type: IsarType.string),
    r'type': PropertySchema(
      id: 10,
      name: r'type',
      type: IsarType.byte,
      enumMap: _WatchItemtypeEnumValueMap,
    ),
    r'uuid': PropertySchema(id: 11, name: r'uuid', type: IsarType.string),
    r'year': PropertySchema(id: 12, name: r'year', type: IsarType.long),
  },

  estimateSize: _watchItemEstimateSize,
  serialize: _watchItemSerialize,
  deserialize: _watchItemDeserialize,
  deserializeProp: _watchItemDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'title': IndexSchema(
      id: -7636685945352118059,
      name: r'title',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'title',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'dateAdded': IndexSchema(
      id: 7425792204428031576,
      name: r'dateAdded',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateAdded',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _watchItemGetId,
  getLinks: _watchItemGetLinks,
  attach: _watchItemAttach,
  version: '3.3.2',
);

int _watchItemEstimateSize(
  WatchItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.genres.length * 3;
  {
    for (var i = 0; i < object.genres.length; i++) {
      final value = object.genres[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.notes;
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
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _watchItemSerialize(
  WatchItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dateAdded);
  writer.writeDateTime(offsets[1], object.dateCompleted);
  writer.writeStringList(offsets[2], object.genres);
  writer.writeString(offsets[3], object.notes);
  writer.writeString(offsets[4], object.posterPath);
  writer.writeLong(offsets[5], object.progressCurrent);
  writer.writeLong(offsets[6], object.progressTotal);
  writer.writeDouble(offsets[7], object.rating);
  writer.writeByte(offsets[8], object.status.index);
  writer.writeString(offsets[9], object.title);
  writer.writeByte(offsets[10], object.type.index);
  writer.writeString(offsets[11], object.uuid);
  writer.writeLong(offsets[12], object.year);
}

WatchItem _watchItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WatchItem();
  object.dateAdded = reader.readDateTime(offsets[0]);
  object.dateCompleted = reader.readDateTimeOrNull(offsets[1]);
  object.genres = reader.readStringList(offsets[2]) ?? [];
  object.id = id;
  object.notes = reader.readStringOrNull(offsets[3]);
  object.posterPath = reader.readStringOrNull(offsets[4]);
  object.progressCurrent = reader.readLongOrNull(offsets[5]);
  object.progressTotal = reader.readLongOrNull(offsets[6]);
  object.rating = reader.readDoubleOrNull(offsets[7]);
  object.status =
      _WatchItemstatusValueEnumMap[reader.readByteOrNull(offsets[8])] ??
      WatchStatus.planToWatch;
  object.title = reader.readString(offsets[9]);
  object.type =
      _WatchItemtypeValueEnumMap[reader.readByteOrNull(offsets[10])] ??
      ItemType.anime;
  object.uuid = reader.readString(offsets[11]);
  object.year = reader.readLongOrNull(offsets[12]);
  return object;
}

P _watchItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (_WatchItemstatusValueEnumMap[reader.readByteOrNull(offset)] ??
              WatchStatus.planToWatch)
          as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (_WatchItemtypeValueEnumMap[reader.readByteOrNull(offset)] ??
              ItemType.anime)
          as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _WatchItemstatusEnumValueMap = {
  'planToWatch': 0,
  'watching': 1,
  'completed': 2,
};
const _WatchItemstatusValueEnumMap = {
  0: WatchStatus.planToWatch,
  1: WatchStatus.watching,
  2: WatchStatus.completed,
};
const _WatchItemtypeEnumValueMap = {
  'anime': 0,
  'movie': 1,
  'series': 2,
  'reading': 3,
};
const _WatchItemtypeValueEnumMap = {
  0: ItemType.anime,
  1: ItemType.movie,
  2: ItemType.series,
  3: ItemType.reading,
};

Id _watchItemGetId(WatchItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _watchItemGetLinks(WatchItem object) {
  return [];
}

void _watchItemAttach(IsarCollection<dynamic> col, Id id, WatchItem object) {
  object.id = id;
}

extension WatchItemByIndex on IsarCollection<WatchItem> {
  Future<WatchItem?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  WatchItem? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<WatchItem?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<WatchItem?> getAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uuid', values);
  }

  Future<int> deleteAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uuid', values);
  }

  int deleteAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uuid', values);
  }

  Future<Id> putByUuid(WatchItem object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(WatchItem object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<WatchItem> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(List<WatchItem> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension WatchItemQueryWhereSort
    on QueryBuilder<WatchItem, WatchItem, QWhere> {
  QueryBuilder<WatchItem, WatchItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhere> anyStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'status'),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhere> anyDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateAdded'),
      );
    });
  }
}

extension WatchItemQueryWhere
    on QueryBuilder<WatchItem, WatchItem, QWhereClause> {
  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> idBetween(
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

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> uuidEqualTo(
    String uuid,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'uuid', value: [uuid]),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> uuidNotEqualTo(
    String uuid,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [],
                upper: [uuid],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [uuid],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [uuid],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [],
                upper: [uuid],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> titleEqualTo(
    String title,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'title', value: [title]),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> titleNotEqualTo(
    String title,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'title',
                lower: [],
                upper: [title],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'title',
                lower: [title],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'title',
                lower: [title],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'title',
                lower: [],
                upper: [title],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> statusEqualTo(
    WatchStatus status,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'status', value: [status]),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> statusNotEqualTo(
    WatchStatus status,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> statusGreaterThan(
    WatchStatus status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'status',
          lower: [status],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> statusLessThan(
    WatchStatus status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'status',
          lower: [],
          upper: [status],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> statusBetween(
    WatchStatus lowerStatus,
    WatchStatus upperStatus, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'status',
          lower: [lowerStatus],
          includeLower: includeLower,
          upper: [upperStatus],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> dateAddedEqualTo(
    DateTime dateAdded,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'dateAdded', value: [dateAdded]),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> dateAddedNotEqualTo(
    DateTime dateAdded,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateAdded',
                lower: [],
                upper: [dateAdded],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateAdded',
                lower: [dateAdded],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateAdded',
                lower: [dateAdded],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateAdded',
                lower: [],
                upper: [dateAdded],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> dateAddedGreaterThan(
    DateTime dateAdded, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateAdded',
          lower: [dateAdded],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> dateAddedLessThan(
    DateTime dateAdded, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateAdded',
          lower: [],
          upper: [dateAdded],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterWhereClause> dateAddedBetween(
    DateTime lowerDateAdded,
    DateTime upperDateAdded, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateAdded',
          lower: [lowerDateAdded],
          includeLower: includeLower,
          upper: [upperDateAdded],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension WatchItemQueryFilter
    on QueryBuilder<WatchItem, WatchItem, QFilterCondition> {
  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> dateAddedEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateAdded', value: value),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  dateAddedGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateAdded',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> dateAddedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateAdded',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> dateAddedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateAdded',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  dateCompletedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dateCompleted'),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  dateCompletedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dateCompleted'),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  dateCompletedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateCompleted', value: value),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  dateCompletedGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateCompleted',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  dateCompletedLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateCompleted',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  dateCompletedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateCompleted',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  genresElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'genres', value: ''),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  genresElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'genres', value: ''),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> genresLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', length, true, length, true);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> genresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', 0, true, 0, true);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> genresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', 0, false, 999999, true);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  genresLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', 0, true, length, include);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  genresLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', length, include, 999999, true);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> genresLengthBetween(
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'notes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> notesContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> notesMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'notes',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> posterPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'posterPath'),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  posterPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'posterPath'),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> posterPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> posterPathLessThan(
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> posterPathBetween(
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> posterPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> posterPathContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> posterPathMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  posterPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'posterPath', value: ''),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  posterPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'posterPath', value: ''),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  progressCurrentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'progressCurrent'),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  progressCurrentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'progressCurrent'),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  progressCurrentEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'progressCurrent', value: value),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  progressCurrentGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'progressCurrent',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  progressCurrentLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'progressCurrent',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  progressCurrentBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'progressCurrent',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  progressTotalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'progressTotal'),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  progressTotalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'progressTotal'),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  progressTotalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'progressTotal', value: value),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  progressTotalGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'progressTotal',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  progressTotalLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'progressTotal',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition>
  progressTotalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'progressTotal',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> ratingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'rating'),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> ratingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'rating'),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> ratingEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rating',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> ratingGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rating',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> ratingLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rating',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> ratingBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rating',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> statusEqualTo(
    WatchStatus value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: value),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> statusGreaterThan(
    WatchStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> statusLessThan(
    WatchStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> statusBetween(
    WatchStatus lower,
    WatchStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> titleEqualTo(
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> titleGreaterThan(
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> titleLessThan(
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> titleBetween(
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> titleStartsWith(
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> titleEndsWith(
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> titleContains(
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> titleMatches(
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

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> typeEqualTo(
    ItemType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> typeGreaterThan(
    ItemType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> typeLessThan(
    ItemType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> typeBetween(
    ItemType lower,
    ItemType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'uuid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> uuidContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> uuidMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'uuid',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> yearIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'year'),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> yearIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'year'),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> yearEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'year', value: value),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> yearGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'year',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> yearLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'year',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterFilterCondition> yearBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'year',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension WatchItemQueryObject
    on QueryBuilder<WatchItem, WatchItem, QFilterCondition> {}

extension WatchItemQueryLinks
    on QueryBuilder<WatchItem, WatchItem, QFilterCondition> {}

extension WatchItemQuerySortBy on QueryBuilder<WatchItem, WatchItem, QSortBy> {
  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByDateAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByDateCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCompleted', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByDateCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCompleted', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByPosterPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByPosterPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByProgressCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressCurrent', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByProgressCurrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressCurrent', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByProgressTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressTotal', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByProgressTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressTotal', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension WatchItemQuerySortThenBy
    on QueryBuilder<WatchItem, WatchItem, QSortThenBy> {
  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByDateAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByDateCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCompleted', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByDateCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCompleted', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByPosterPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByPosterPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByProgressCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressCurrent', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByProgressCurrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressCurrent', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByProgressTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressTotal', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByProgressTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressTotal', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QAfterSortBy> thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension WatchItemQueryWhereDistinct
    on QueryBuilder<WatchItem, WatchItem, QDistinct> {
  QueryBuilder<WatchItem, WatchItem, QDistinct> distinctByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateAdded');
    });
  }

  QueryBuilder<WatchItem, WatchItem, QDistinct> distinctByDateCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateCompleted');
    });
  }

  QueryBuilder<WatchItem, WatchItem, QDistinct> distinctByGenres() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genres');
    });
  }

  QueryBuilder<WatchItem, WatchItem, QDistinct> distinctByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QDistinct> distinctByPosterPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QDistinct> distinctByProgressCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progressCurrent');
    });
  }

  QueryBuilder<WatchItem, WatchItem, QDistinct> distinctByProgressTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progressTotal');
    });
  }

  QueryBuilder<WatchItem, WatchItem, QDistinct> distinctByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rating');
    });
  }

  QueryBuilder<WatchItem, WatchItem, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<WatchItem, WatchItem, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<WatchItem, WatchItem, QDistinct> distinctByUuid({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchItem, WatchItem, QDistinct> distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }
}

extension WatchItemQueryProperty
    on QueryBuilder<WatchItem, WatchItem, QQueryProperty> {
  QueryBuilder<WatchItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WatchItem, DateTime, QQueryOperations> dateAddedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateAdded');
    });
  }

  QueryBuilder<WatchItem, DateTime?, QQueryOperations> dateCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateCompleted');
    });
  }

  QueryBuilder<WatchItem, List<String>, QQueryOperations> genresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genres');
    });
  }

  QueryBuilder<WatchItem, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<WatchItem, String?, QQueryOperations> posterPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterPath');
    });
  }

  QueryBuilder<WatchItem, int?, QQueryOperations> progressCurrentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progressCurrent');
    });
  }

  QueryBuilder<WatchItem, int?, QQueryOperations> progressTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progressTotal');
    });
  }

  QueryBuilder<WatchItem, double?, QQueryOperations> ratingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rating');
    });
  }

  QueryBuilder<WatchItem, WatchStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<WatchItem, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<WatchItem, ItemType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<WatchItem, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<WatchItem, int?, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }
}
