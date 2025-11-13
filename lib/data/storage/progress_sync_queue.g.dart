// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_sync_queue.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProgressSyncEntityCollection on Isar {
  IsarCollection<ProgressSyncEntity> get progressSyncEntitys =>
      this.collection();
}

const ProgressSyncEntitySchema = CollectionSchema(
  name: r'ProgressSyncEntity',
  id: 2227653219267542949,
  properties: {
    r'bookKomgaId': PropertySchema(
      id: 0,
      name: r'bookKomgaId',
      type: IsarType.string,
    ),
    r'pageNumber': PropertySchema(
      id: 1,
      name: r'pageNumber',
      type: IsarType.long,
    ),
    r'queuedAt': PropertySchema(
      id: 2,
      name: r'queuedAt',
      type: IsarType.dateTime,
    ),
    r'synced': PropertySchema(
      id: 3,
      name: r'synced',
      type: IsarType.bool,
    )
  },
  estimateSize: _progressSyncEntityEstimateSize,
  serialize: _progressSyncEntitySerialize,
  deserialize: _progressSyncEntityDeserialize,
  deserializeProp: _progressSyncEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _progressSyncEntityGetId,
  getLinks: _progressSyncEntityGetLinks,
  attach: _progressSyncEntityAttach,
  version: '3.1.0+1',
);

int _progressSyncEntityEstimateSize(
  ProgressSyncEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bookKomgaId.length * 3;
  return bytesCount;
}

void _progressSyncEntitySerialize(
  ProgressSyncEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bookKomgaId);
  writer.writeLong(offsets[1], object.pageNumber);
  writer.writeDateTime(offsets[2], object.queuedAt);
  writer.writeBool(offsets[3], object.synced);
}

ProgressSyncEntity _progressSyncEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProgressSyncEntity(
    bookKomgaId: reader.readString(offsets[0]),
    id: id,
    pageNumber: reader.readLong(offsets[1]),
    queuedAt: reader.readDateTime(offsets[2]),
    synced: reader.readBoolOrNull(offsets[3]) ?? false,
  );
  return object;
}

P _progressSyncEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _progressSyncEntityGetId(ProgressSyncEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _progressSyncEntityGetLinks(
    ProgressSyncEntity object) {
  return [];
}

void _progressSyncEntityAttach(
    IsarCollection<dynamic> col, Id id, ProgressSyncEntity object) {
  object.id = id;
}

extension ProgressSyncEntityQueryWhereSort
    on QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QWhere> {
  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProgressSyncEntityQueryWhere
    on QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QWhereClause> {
  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProgressSyncEntityQueryFilter
    on QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QFilterCondition> {
  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      bookKomgaIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookKomgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      bookKomgaIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookKomgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      bookKomgaIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookKomgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      bookKomgaIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookKomgaId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      bookKomgaIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bookKomgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      bookKomgaIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bookKomgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      bookKomgaIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bookKomgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      bookKomgaIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bookKomgaId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      bookKomgaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookKomgaId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      bookKomgaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bookKomgaId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      pageNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      pageNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      pageNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      pageNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pageNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      queuedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'queuedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      queuedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'queuedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      queuedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'queuedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      queuedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'queuedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterFilterCondition>
      syncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'synced',
        value: value,
      ));
    });
  }
}

extension ProgressSyncEntityQueryObject
    on QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QFilterCondition> {}

extension ProgressSyncEntityQueryLinks
    on QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QFilterCondition> {}

extension ProgressSyncEntityQuerySortBy
    on QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QSortBy> {
  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      sortByBookKomgaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookKomgaId', Sort.asc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      sortByBookKomgaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookKomgaId', Sort.desc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      sortByPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.asc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      sortByPageNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.desc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      sortByQueuedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queuedAt', Sort.asc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      sortByQueuedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queuedAt', Sort.desc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      sortBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      sortBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }
}

extension ProgressSyncEntityQuerySortThenBy
    on QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QSortThenBy> {
  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      thenByBookKomgaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookKomgaId', Sort.asc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      thenByBookKomgaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookKomgaId', Sort.desc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      thenByPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.asc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      thenByPageNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.desc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      thenByQueuedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queuedAt', Sort.asc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      thenByQueuedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queuedAt', Sort.desc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      thenBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QAfterSortBy>
      thenBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }
}

extension ProgressSyncEntityQueryWhereDistinct
    on QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QDistinct> {
  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QDistinct>
      distinctByBookKomgaId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookKomgaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QDistinct>
      distinctByPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pageNumber');
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QDistinct>
      distinctByQueuedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'queuedAt');
    });
  }

  QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QDistinct>
      distinctBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'synced');
    });
  }
}

extension ProgressSyncEntityQueryProperty
    on QueryBuilder<ProgressSyncEntity, ProgressSyncEntity, QQueryProperty> {
  QueryBuilder<ProgressSyncEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProgressSyncEntity, String, QQueryOperations>
      bookKomgaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookKomgaId');
    });
  }

  QueryBuilder<ProgressSyncEntity, int, QQueryOperations> pageNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pageNumber');
    });
  }

  QueryBuilder<ProgressSyncEntity, DateTime, QQueryOperations>
      queuedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'queuedAt');
    });
  }

  QueryBuilder<ProgressSyncEntity, bool, QQueryOperations> syncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'synced');
    });
  }
}
