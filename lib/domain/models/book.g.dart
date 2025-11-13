// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBookEntityCollection on Isar {
  IsarCollection<BookEntity> get bookEntitys => this.collection();
}

const BookEntitySchema = CollectionSchema(
  name: r'BookEntity',
  id: 8847647309143832400,
  properties: {
    r'currentPageIndex': PropertySchema(
      id: 0,
      name: r'currentPageIndex',
      type: IsarType.long,
    ),
    r'isDownloaded': PropertySchema(
      id: 1,
      name: r'isDownloaded',
      type: IsarType.bool,
    ),
    r'isPinned': PropertySchema(
      id: 2,
      name: r'isPinned',
      type: IsarType.bool,
    ),
    r'komgaId': PropertySchema(
      id: 3,
      name: r'komgaId',
      type: IsarType.string,
    ),
    r'lastOpenedAt': PropertySchema(
      id: 4,
      name: r'lastOpenedAt',
      type: IsarType.dateTime,
    ),
    r'mediaType': PropertySchema(
      id: 5,
      name: r'mediaType',
      type: IsarType.string,
    ),
    r'number': PropertySchema(
      id: 6,
      name: r'number',
      type: IsarType.long,
    ),
    r'pageCount': PropertySchema(
      id: 7,
      name: r'pageCount',
      type: IsarType.long,
    ),
    r'readPageCount': PropertySchema(
      id: 8,
      name: r'readPageCount',
      type: IsarType.long,
    ),
    r'seriesKomgaId': PropertySchema(
      id: 9,
      name: r'seriesKomgaId',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 10,
      name: r'title',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _bookEntityEstimateSize,
  serialize: _bookEntitySerialize,
  deserialize: _bookEntityDeserialize,
  deserializeProp: _bookEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _bookEntityGetId,
  getLinks: _bookEntityGetLinks,
  attach: _bookEntityAttach,
  version: '3.1.0+1',
);

int _bookEntityEstimateSize(
  BookEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.komgaId.length * 3;
  {
    final value = object.mediaType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.seriesKomgaId.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _bookEntitySerialize(
  BookEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currentPageIndex);
  writer.writeBool(offsets[1], object.isDownloaded);
  writer.writeBool(offsets[2], object.isPinned);
  writer.writeString(offsets[3], object.komgaId);
  writer.writeDateTime(offsets[4], object.lastOpenedAt);
  writer.writeString(offsets[5], object.mediaType);
  writer.writeLong(offsets[6], object.number);
  writer.writeLong(offsets[7], object.pageCount);
  writer.writeLong(offsets[8], object.readPageCount);
  writer.writeString(offsets[9], object.seriesKomgaId);
  writer.writeString(offsets[10], object.title);
  writer.writeDateTime(offsets[11], object.updatedAt);
}

BookEntity _bookEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BookEntity(
    currentPageIndex: reader.readLongOrNull(offsets[0]) ?? 0,
    id: id,
    isDownloaded: reader.readBoolOrNull(offsets[1]) ?? false,
    isPinned: reader.readBoolOrNull(offsets[2]) ?? false,
    komgaId: reader.readString(offsets[3]),
    lastOpenedAt: reader.readDateTimeOrNull(offsets[4]),
    mediaType: reader.readStringOrNull(offsets[5]),
    number: reader.readLong(offsets[6]),
    pageCount: reader.readLong(offsets[7]),
    readPageCount: reader.readLongOrNull(offsets[8]) ?? 0,
    seriesKomgaId: reader.readString(offsets[9]),
    title: reader.readString(offsets[10]),
    updatedAt: reader.readDateTime(offsets[11]),
  );
  return object;
}

P _bookEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bookEntityGetId(BookEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bookEntityGetLinks(BookEntity object) {
  return [];
}

void _bookEntityAttach(IsarCollection<dynamic> col, Id id, BookEntity object) {
  object.id = id;
}

extension BookEntityQueryWhereSort
    on QueryBuilder<BookEntity, BookEntity, QWhere> {
  QueryBuilder<BookEntity, BookEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BookEntityQueryWhere
    on QueryBuilder<BookEntity, BookEntity, QWhereClause> {
  QueryBuilder<BookEntity, BookEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<BookEntity, BookEntity, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterWhereClause> idBetween(
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

extension BookEntityQueryFilter
    on QueryBuilder<BookEntity, BookEntity, QFilterCondition> {
  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      currentPageIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentPageIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      currentPageIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentPageIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      currentPageIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentPageIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      currentPageIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentPageIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      isDownloadedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDownloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> isPinnedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPinned',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> komgaIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'komgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      komgaIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'komgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> komgaIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'komgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> komgaIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'komgaId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> komgaIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'komgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> komgaIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'komgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> komgaIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'komgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> komgaIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'komgaId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> komgaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'komgaId',
        value: '',
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      komgaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'komgaId',
        value: '',
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      lastOpenedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastOpenedAt',
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      lastOpenedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastOpenedAt',
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      lastOpenedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastOpenedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      lastOpenedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastOpenedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      lastOpenedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastOpenedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      lastOpenedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastOpenedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      mediaTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mediaType',
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      mediaTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mediaType',
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> mediaTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      mediaTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> mediaTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> mediaTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediaType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      mediaTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> mediaTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> mediaTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> mediaTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mediaType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      mediaTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaType',
        value: '',
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      mediaTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mediaType',
        value: '',
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> numberEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'number',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> numberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'number',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> numberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'number',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> numberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'number',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> pageCountEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageCount',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      pageCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pageCount',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> pageCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pageCount',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> pageCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pageCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      readPageCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readPageCount',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      readPageCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'readPageCount',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      readPageCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'readPageCount',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      readPageCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'readPageCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      seriesKomgaIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seriesKomgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      seriesKomgaIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seriesKomgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      seriesKomgaIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seriesKomgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      seriesKomgaIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seriesKomgaId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      seriesKomgaIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'seriesKomgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      seriesKomgaIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'seriesKomgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      seriesKomgaIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'seriesKomgaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      seriesKomgaIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'seriesKomgaId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      seriesKomgaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seriesKomgaId',
        value: '',
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      seriesKomgaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'seriesKomgaId',
        value: '',
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BookEntityQueryObject
    on QueryBuilder<BookEntity, BookEntity, QFilterCondition> {}

extension BookEntityQueryLinks
    on QueryBuilder<BookEntity, BookEntity, QFilterCondition> {}

extension BookEntityQuerySortBy
    on QueryBuilder<BookEntity, BookEntity, QSortBy> {
  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByCurrentPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPageIndex', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy>
      sortByCurrentPageIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPageIndex', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByIsDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByIsDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByKomgaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'komgaId', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByKomgaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'komgaId', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByLastOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedAt', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByLastOpenedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedAt', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByPageCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageCount', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByPageCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageCount', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByReadPageCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readPageCount', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByReadPageCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readPageCount', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortBySeriesKomgaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesKomgaId', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortBySeriesKomgaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesKomgaId', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension BookEntityQuerySortThenBy
    on QueryBuilder<BookEntity, BookEntity, QSortThenBy> {
  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByCurrentPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPageIndex', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy>
      thenByCurrentPageIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPageIndex', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByIsDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByIsDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByKomgaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'komgaId', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByKomgaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'komgaId', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByLastOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedAt', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByLastOpenedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedAt', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByPageCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageCount', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByPageCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageCount', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByReadPageCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readPageCount', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByReadPageCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readPageCount', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenBySeriesKomgaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesKomgaId', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenBySeriesKomgaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesKomgaId', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension BookEntityQueryWhereDistinct
    on QueryBuilder<BookEntity, BookEntity, QDistinct> {
  QueryBuilder<BookEntity, BookEntity, QDistinct> distinctByCurrentPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentPageIndex');
    });
  }

  QueryBuilder<BookEntity, BookEntity, QDistinct> distinctByIsDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDownloaded');
    });
  }

  QueryBuilder<BookEntity, BookEntity, QDistinct> distinctByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPinned');
    });
  }

  QueryBuilder<BookEntity, BookEntity, QDistinct> distinctByKomgaId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'komgaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QDistinct> distinctByLastOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastOpenedAt');
    });
  }

  QueryBuilder<BookEntity, BookEntity, QDistinct> distinctByMediaType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QDistinct> distinctByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'number');
    });
  }

  QueryBuilder<BookEntity, BookEntity, QDistinct> distinctByPageCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pageCount');
    });
  }

  QueryBuilder<BookEntity, BookEntity, QDistinct> distinctByReadPageCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readPageCount');
    });
  }

  QueryBuilder<BookEntity, BookEntity, QDistinct> distinctBySeriesKomgaId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seriesKomgaId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookEntity, BookEntity, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension BookEntityQueryProperty
    on QueryBuilder<BookEntity, BookEntity, QQueryProperty> {
  QueryBuilder<BookEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BookEntity, int, QQueryOperations> currentPageIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentPageIndex');
    });
  }

  QueryBuilder<BookEntity, bool, QQueryOperations> isDownloadedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDownloaded');
    });
  }

  QueryBuilder<BookEntity, bool, QQueryOperations> isPinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPinned');
    });
  }

  QueryBuilder<BookEntity, String, QQueryOperations> komgaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'komgaId');
    });
  }

  QueryBuilder<BookEntity, DateTime?, QQueryOperations> lastOpenedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastOpenedAt');
    });
  }

  QueryBuilder<BookEntity, String?, QQueryOperations> mediaTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaType');
    });
  }

  QueryBuilder<BookEntity, int, QQueryOperations> numberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'number');
    });
  }

  QueryBuilder<BookEntity, int, QQueryOperations> pageCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pageCount');
    });
  }

  QueryBuilder<BookEntity, int, QQueryOperations> readPageCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readPageCount');
    });
  }

  QueryBuilder<BookEntity, String, QQueryOperations> seriesKomgaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seriesKomgaId');
    });
  }

  QueryBuilder<BookEntity, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<BookEntity, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
