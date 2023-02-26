// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_db.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetTransferDatabaseCollection on Isar {
  IsarCollection<TransferDatabase> get transferDatabases => this.collection();
}

const TransferDatabaseSchema = CollectionSchema(
  name: r'Transfer',
  id: 2299428791821287909,
  properties: {
    r'Cancelled At': PropertySchema(
      id: 0,
      name: r'Cancelled At',
      type: IsarType.dateTime,
    ),
    r'End Time': PropertySchema(
      id: 1,
      name: r'End Time',
      type: IsarType.dateTime,
    ),
    r'Files': PropertySchema(
      id: 2,
      name: r'Files',
      type: IsarType.objectList,
      target: r'FileDb',
    ),
    r'Managed By': PropertySchema(
      id: 3,
      name: r'Managed By',
      type: IsarType.byte,
      enumMap: _TransferDatabasemanagedByEnumValueMap,
    ),
    r'Message': PropertySchema(
      id: 4,
      name: r'Message',
      type: IsarType.string,
    ),
    r'Receiver Device': PropertySchema(
      id: 5,
      name: r'Receiver Device',
      type: IsarType.object,
      target: r'DeviceDb',
    ),
    r'Requested At': PropertySchema(
      id: 6,
      name: r'Requested At',
      type: IsarType.dateTime,
    ),
    r'Sender Device': PropertySchema(
      id: 7,
      name: r'Sender Device',
      type: IsarType.object,
      target: r'DeviceDb',
    ),
    r'Start Time': PropertySchema(
      id: 8,
      name: r'Start Time',
      type: IsarType.dateTime,
    ),
    r'Transfer Status': PropertySchema(
      id: 9,
      name: r'Transfer Status',
      type: IsarType.byte,
      enumMap: _TransferDatabasestatusEnumValueMap,
    ),
    r'Transfer Type': PropertySchema(
      id: 10,
      name: r'Transfer Type',
      type: IsarType.byte,
      enumMap: _TransferDatabasetypeEnumValueMap,
    ),
    r'Transfer Unique ID': PropertySchema(
      id: 11,
      name: r'Transfer Unique ID',
      type: IsarType.string,
    )
  },
  estimateSize: _transferDatabaseEstimateSize,
  serialize: _transferDatabaseSerialize,
  deserialize: _transferDatabaseDeserialize,
  deserializeProp: _transferDatabaseDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'DeviceDb': DeviceDbSchema, r'FileDb': FileDbSchema},
  getId: _transferDatabaseGetId,
  getLinks: _transferDatabaseGetLinks,
  attach: _transferDatabaseAttach,
  version: '3.0.5',
);

int _transferDatabaseEstimateSize(
  TransferDatabase object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.files.length * 3;
  {
    final offsets = allOffsets[FileDb]!;
    for (var i = 0; i < object.files.length; i++) {
      final value = object.files[i];
      bytesCount += FileDbSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.message;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 +
      DeviceDbSchema.estimateSize(
          object.receiverDevice, allOffsets[DeviceDb]!, allOffsets);
  bytesCount += 3 +
      DeviceDbSchema.estimateSize(
          object.senderDevice, allOffsets[DeviceDb]!, allOffsets);
  bytesCount += 3 + object.transferUuid.length * 3;
  return bytesCount;
}

void _transferDatabaseSerialize(
  TransferDatabase object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.cancelledAt);
  writer.writeDateTime(offsets[1], object.endedAt);
  writer.writeObjectList<FileDb>(
    offsets[2],
    allOffsets,
    FileDbSchema.serialize,
    object.files,
  );
  writer.writeByte(offsets[3], object.managedBy.index);
  writer.writeString(offsets[4], object.message);
  writer.writeObject<DeviceDb>(
    offsets[5],
    allOffsets,
    DeviceDbSchema.serialize,
    object.receiverDevice,
  );
  writer.writeDateTime(offsets[6], object.requestedAt);
  writer.writeObject<DeviceDb>(
    offsets[7],
    allOffsets,
    DeviceDbSchema.serialize,
    object.senderDevice,
  );
  writer.writeDateTime(offsets[8], object.startedAt);
  writer.writeByte(offsets[9], object.status.index);
  writer.writeByte(offsets[10], object.type.index);
  writer.writeString(offsets[11], object.transferUuid);
}

TransferDatabase _transferDatabaseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TransferDatabase();
  object.cancelledAt = reader.readDateTimeOrNull(offsets[0]);
  object.endedAt = reader.readDateTimeOrNull(offsets[1]);
  object.files = reader.readObjectList<FileDb>(
        offsets[2],
        FileDbSchema.deserialize,
        allOffsets,
        FileDb(),
      ) ??
      [];
  object.managedBy = _TransferDatabasemanagedByValueEnumMap[
          reader.readByteOrNull(offsets[3])] ??
      TransferDbManagedBy.user;
  object.message = reader.readStringOrNull(offsets[4]);
  object.receiverDevice = reader.readObjectOrNull<DeviceDb>(
        offsets[5],
        DeviceDbSchema.deserialize,
        allOffsets,
      ) ??
      DeviceDb();
  object.requestedAt = reader.readDateTime(offsets[6]);
  object.senderDevice = reader.readObjectOrNull<DeviceDb>(
        offsets[7],
        DeviceDbSchema.deserialize,
        allOffsets,
      ) ??
      DeviceDb();
  object.startedAt = reader.readDateTimeOrNull(offsets[8]);
  object.status =
      _TransferDatabasestatusValueEnumMap[reader.readByteOrNull(offsets[9])] ??
          TransferDbStatus.success;
  object.type =
      _TransferDatabasetypeValueEnumMap[reader.readByteOrNull(offsets[10])] ??
          TransferDbType.download;
  object.transferUuid = reader.readString(offsets[11]);
  object.id = id;
  return object;
}

P _transferDatabaseDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readObjectList<FileDb>(
            offset,
            FileDbSchema.deserialize,
            allOffsets,
            FileDb(),
          ) ??
          []) as P;
    case 3:
      return (_TransferDatabasemanagedByValueEnumMap[
              reader.readByteOrNull(offset)] ??
          TransferDbManagedBy.user) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readObjectOrNull<DeviceDb>(
            offset,
            DeviceDbSchema.deserialize,
            allOffsets,
          ) ??
          DeviceDb()) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readObjectOrNull<DeviceDb>(
            offset,
            DeviceDbSchema.deserialize,
            allOffsets,
          ) ??
          DeviceDb()) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (_TransferDatabasestatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          TransferDbStatus.success) as P;
    case 10:
      return (_TransferDatabasetypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          TransferDbType.download) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TransferDatabasemanagedByEnumValueMap = {
  'user': 0,
  'blacklist': 1,
  'ban': 2,
  'automation': 3,
  'thirdParty': 4,
};
const _TransferDatabasemanagedByValueEnumMap = {
  0: TransferDbManagedBy.user,
  1: TransferDbManagedBy.blacklist,
  2: TransferDbManagedBy.ban,
  3: TransferDbManagedBy.automation,
  4: TransferDbManagedBy.thirdParty,
};
const _TransferDatabasestatusEnumValueMap = {
  'success': 0,
  'error': 1,
  'declined': 2,
  'ongoing': 3,
  'pendingForAcceptance': 4,
  'cancelled': 5,
};
const _TransferDatabasestatusValueEnumMap = {
  0: TransferDbStatus.success,
  1: TransferDbStatus.error,
  2: TransferDbStatus.declined,
  3: TransferDbStatus.ongoing,
  4: TransferDbStatus.pendingForAcceptance,
  5: TransferDbStatus.cancelled,
};
const _TransferDatabasetypeEnumValueMap = {
  'download': 0,
  'upload': 1,
};
const _TransferDatabasetypeValueEnumMap = {
  0: TransferDbType.download,
  1: TransferDbType.upload,
};

Id _transferDatabaseGetId(TransferDatabase object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _transferDatabaseGetLinks(TransferDatabase object) {
  return [];
}

void _transferDatabaseAttach(
    IsarCollection<dynamic> col, Id id, TransferDatabase object) {
  object.id = id;
}

extension TransferDatabaseQueryWhereSort
    on QueryBuilder<TransferDatabase, TransferDatabase, QWhere> {
  QueryBuilder<TransferDatabase, TransferDatabase, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TransferDatabaseQueryWhere
    on QueryBuilder<TransferDatabase, TransferDatabase, QWhereClause> {
  QueryBuilder<TransferDatabase, TransferDatabase, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterWhereClause>
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

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterWhereClause> idBetween(
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

extension TransferDatabaseQueryFilter
    on QueryBuilder<TransferDatabase, TransferDatabase, QFilterCondition> {
  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      cancelledAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'Cancelled At',
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      cancelledAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'Cancelled At',
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      cancelledAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'Cancelled At',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      cancelledAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'Cancelled At',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      cancelledAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'Cancelled At',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      cancelledAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'Cancelled At',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      endedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'End Time',
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      endedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'End Time',
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      endedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'End Time',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      endedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'End Time',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      endedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'End Time',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      endedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'End Time',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      filesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'Files',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      filesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'Files',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      filesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'Files',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      filesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'Files',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      filesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'Files',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      filesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'Files',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      managedByEqualTo(TransferDbManagedBy value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'Managed By',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      managedByGreaterThan(
    TransferDbManagedBy value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'Managed By',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      managedByLessThan(
    TransferDbManagedBy value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'Managed By',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      managedByBetween(
    TransferDbManagedBy lower,
    TransferDbManagedBy upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'Managed By',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      messageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'Message',
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      messageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'Message',
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      messageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'Message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      messageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'Message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      messageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'Message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      messageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'Message',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      messageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'Message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      messageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'Message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      messageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'Message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      messageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'Message',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      messageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'Message',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      messageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'Message',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      requestedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'Requested At',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      requestedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'Requested At',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      requestedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'Requested At',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      requestedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'Requested At',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      startedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'Start Time',
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      startedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'Start Time',
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      startedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'Start Time',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      startedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'Start Time',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      startedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'Start Time',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      startedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'Start Time',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      statusEqualTo(TransferDbStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'Transfer Status',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      statusGreaterThan(
    TransferDbStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'Transfer Status',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      statusLessThan(
    TransferDbStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'Transfer Status',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      statusBetween(
    TransferDbStatus lower,
    TransferDbStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'Transfer Status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      typeEqualTo(TransferDbType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'Transfer Type',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      typeGreaterThan(
    TransferDbType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'Transfer Type',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      typeLessThan(
    TransferDbType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'Transfer Type',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      typeBetween(
    TransferDbType lower,
    TransferDbType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'Transfer Type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      transferUuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'Transfer Unique ID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      transferUuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'Transfer Unique ID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      transferUuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'Transfer Unique ID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      transferUuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'Transfer Unique ID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      transferUuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'Transfer Unique ID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      transferUuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'Transfer Unique ID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      transferUuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'Transfer Unique ID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      transferUuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'Transfer Unique ID',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      transferUuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'Transfer Unique ID',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      transferUuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'Transfer Unique ID',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
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

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
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

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
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
}

extension TransferDatabaseQueryObject
    on QueryBuilder<TransferDatabase, TransferDatabase, QFilterCondition> {
  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      filesElement(FilterQuery<FileDb> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'Files');
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      receiverDevice(FilterQuery<DeviceDb> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'Receiver Device');
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterFilterCondition>
      senderDevice(FilterQuery<DeviceDb> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'Sender Device');
    });
  }
}

extension TransferDatabaseQueryLinks
    on QueryBuilder<TransferDatabase, TransferDatabase, QFilterCondition> {}

extension TransferDatabaseQuerySortBy
    on QueryBuilder<TransferDatabase, TransferDatabase, QSortBy> {
  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByCancelledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Cancelled At', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByCancelledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Cancelled At', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByEndedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'End Time', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByEndedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'End Time', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByManagedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Managed By', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByManagedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Managed By', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Message', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Message', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByRequestedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Requested At', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByRequestedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Requested At', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Start Time', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Start Time', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Transfer Status', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Transfer Status', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Transfer Type', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Transfer Type', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByTransferUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Transfer Unique ID', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      sortByTransferUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Transfer Unique ID', Sort.desc);
    });
  }
}

extension TransferDatabaseQuerySortThenBy
    on QueryBuilder<TransferDatabase, TransferDatabase, QSortThenBy> {
  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByCancelledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Cancelled At', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByCancelledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Cancelled At', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByEndedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'End Time', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByEndedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'End Time', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByManagedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Managed By', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByManagedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Managed By', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Message', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Message', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByRequestedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Requested At', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByRequestedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Requested At', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Start Time', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Start Time', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Transfer Status', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Transfer Status', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Transfer Type', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Transfer Type', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByTransferUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Transfer Unique ID', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByTransferUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Transfer Unique ID', Sort.desc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension TransferDatabaseQueryWhereDistinct
    on QueryBuilder<TransferDatabase, TransferDatabase, QDistinct> {
  QueryBuilder<TransferDatabase, TransferDatabase, QDistinct>
      distinctByCancelledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'Cancelled At');
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QDistinct>
      distinctByEndedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'End Time');
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QDistinct>
      distinctByManagedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'Managed By');
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QDistinct> distinctByMessage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'Message', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QDistinct>
      distinctByRequestedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'Requested At');
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QDistinct>
      distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'Start Time');
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'Transfer Status');
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'Transfer Type');
    });
  }

  QueryBuilder<TransferDatabase, TransferDatabase, QDistinct>
      distinctByTransferUuid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'Transfer Unique ID',
          caseSensitive: caseSensitive);
    });
  }
}

extension TransferDatabaseQueryProperty
    on QueryBuilder<TransferDatabase, TransferDatabase, QQueryProperty> {
  QueryBuilder<TransferDatabase, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TransferDatabase, DateTime?, QQueryOperations>
      cancelledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'Cancelled At');
    });
  }

  QueryBuilder<TransferDatabase, DateTime?, QQueryOperations>
      endedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'End Time');
    });
  }

  QueryBuilder<TransferDatabase, List<FileDb>, QQueryOperations>
      filesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'Files');
    });
  }

  QueryBuilder<TransferDatabase, TransferDbManagedBy, QQueryOperations>
      managedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'Managed By');
    });
  }

  QueryBuilder<TransferDatabase, String?, QQueryOperations> messageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'Message');
    });
  }

  QueryBuilder<TransferDatabase, DeviceDb, QQueryOperations>
      receiverDeviceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'Receiver Device');
    });
  }

  QueryBuilder<TransferDatabase, DateTime, QQueryOperations>
      requestedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'Requested At');
    });
  }

  QueryBuilder<TransferDatabase, DeviceDb, QQueryOperations>
      senderDeviceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'Sender Device');
    });
  }

  QueryBuilder<TransferDatabase, DateTime?, QQueryOperations>
      startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'Start Time');
    });
  }

  QueryBuilder<TransferDatabase, TransferDbStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'Transfer Status');
    });
  }

  QueryBuilder<TransferDatabase, TransferDbType, QQueryOperations>
      typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'Transfer Type');
    });
  }

  QueryBuilder<TransferDatabase, String, QQueryOperations>
      transferUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'Transfer Unique ID');
    });
  }
}
