// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSettingsEntityCollection on Isar {
  IsarCollection<SettingsEntity> get settingsEntitys => this.collection();
}

const SettingsEntitySchema = CollectionSchema(
  name: r'SettingsEntity',
  id: -7271317039764597112,
  properties: {
    r'fitMode': PropertySchema(
      id: 0,
      name: r'fitMode',
      type: IsarType.long,
    ),
    r'prefetchNextPage': PropertySchema(
      id: 1,
      name: r'prefetchNextPage',
      type: IsarType.bool,
    ),
    r'tapZones': PropertySchema(
      id: 2,
      name: r'tapZones',
      type: IsarType.bool,
    ),
    r'wifiOnlyStreaming': PropertySchema(
      id: 3,
      name: r'wifiOnlyStreaming',
      type: IsarType.bool,
    )
  },
  estimateSize: _settingsEntityEstimateSize,
  serialize: _settingsEntitySerialize,
  deserialize: _settingsEntityDeserialize,
  deserializeProp: _settingsEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _settingsEntityGetId,
  getLinks: _settingsEntityGetLinks,
  attach: _settingsEntityAttach,
  version: '3.1.0+1',
);

int _settingsEntityEstimateSize(
  SettingsEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _settingsEntitySerialize(
  SettingsEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.fitMode);
  writer.writeBool(offsets[1], object.prefetchNextPage);
  writer.writeBool(offsets[2], object.tapZones);
  writer.writeBool(offsets[3], object.wifiOnlyStreaming);
}

SettingsEntity _settingsEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SettingsEntity(
    fitMode: reader.readLongOrNull(offsets[0]) ?? 1,
    prefetchNextPage: reader.readBoolOrNull(offsets[1]) ?? true,
    tapZones: reader.readBoolOrNull(offsets[2]) ?? true,
    wifiOnlyStreaming: reader.readBoolOrNull(offsets[3]) ?? true,
  );
  object.id = id;
  return object;
}

P _settingsEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _settingsEntityGetId(SettingsEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _settingsEntityGetLinks(SettingsEntity object) {
  return [];
}

void _settingsEntityAttach(
    IsarCollection<dynamic> col, Id id, SettingsEntity object) {
  object.id = id;
}

extension SettingsEntityQueryWhereSort
    on QueryBuilder<SettingsEntity, SettingsEntity, QWhere> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SettingsEntityQueryWhere
    on QueryBuilder<SettingsEntity, SettingsEntity, QWhereClause> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idBetween(
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

extension SettingsEntityQueryFilter
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      fitModeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fitMode',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      fitModeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fitMode',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      fitModeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fitMode',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      fitModeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fitMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      prefetchNextPageEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prefetchNextPage',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      tapZonesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tapZones',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      wifiOnlyStreamingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wifiOnlyStreaming',
        value: value,
      ));
    });
  }
}

extension SettingsEntityQueryObject
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {}

extension SettingsEntityQueryLinks
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {}

extension SettingsEntityQuerySortBy
    on QueryBuilder<SettingsEntity, SettingsEntity, QSortBy> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> sortByFitMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fitMode', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByFitModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fitMode', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByPrefetchNextPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prefetchNextPage', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByPrefetchNextPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prefetchNextPage', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> sortByTapZones() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapZones', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByTapZonesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapZones', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByWifiOnlyStreaming() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiOnlyStreaming', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByWifiOnlyStreamingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiOnlyStreaming', Sort.desc);
    });
  }
}

extension SettingsEntityQuerySortThenBy
    on QueryBuilder<SettingsEntity, SettingsEntity, QSortThenBy> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenByFitMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fitMode', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByFitModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fitMode', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByPrefetchNextPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prefetchNextPage', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByPrefetchNextPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prefetchNextPage', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenByTapZones() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapZones', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByTapZonesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapZones', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByWifiOnlyStreaming() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiOnlyStreaming', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByWifiOnlyStreamingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiOnlyStreaming', Sort.desc);
    });
  }
}

extension SettingsEntityQueryWhereDistinct
    on QueryBuilder<SettingsEntity, SettingsEntity, QDistinct> {
  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct> distinctByFitMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fitMode');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByPrefetchNextPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prefetchNextPage');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct> distinctByTapZones() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tapZones');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByWifiOnlyStreaming() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wifiOnlyStreaming');
    });
  }
}

extension SettingsEntityQueryProperty
    on QueryBuilder<SettingsEntity, SettingsEntity, QQueryProperty> {
  QueryBuilder<SettingsEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SettingsEntity, int, QQueryOperations> fitModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fitMode');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
      prefetchNextPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prefetchNextPage');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations> tapZonesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tapZones');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
      wifiOnlyStreamingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wifiOnlyStreaming');
    });
  }
}
