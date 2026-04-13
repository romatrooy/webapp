// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MasterCitiesTable extends MasterCities
    with TableInfo<$MasterCitiesTable, MasterCity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MasterCitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'master_cities';
  @override
  VerificationContext validateIntegrity(
    Insertable<MasterCity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MasterCity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MasterCity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $MasterCitiesTable createAlias(String alias) {
    return $MasterCitiesTable(attachedDatabase, alias);
  }
}

class MasterCity extends DataClass implements Insertable<MasterCity> {
  final int id;
  final String name;
  const MasterCity({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  MasterCitiesCompanion toCompanion(bool nullToAbsent) {
    return MasterCitiesCompanion(id: Value(id), name: Value(name));
  }

  factory MasterCity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MasterCity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  MasterCity copyWith({int? id, String? name}) =>
      MasterCity(id: id ?? this.id, name: name ?? this.name);
  MasterCity copyWithCompanion(MasterCitiesCompanion data) {
    return MasterCity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MasterCity(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MasterCity && other.id == this.id && other.name == this.name);
}

class MasterCitiesCompanion extends UpdateCompanion<MasterCity> {
  final Value<int> id;
  final Value<String> name;
  const MasterCitiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  MasterCitiesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<MasterCity> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  MasterCitiesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return MasterCitiesCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MasterCitiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $UserCitiesTable extends UserCities
    with TableInfo<$UserCitiesTable, UserCity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserCitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _masterCityIdMeta = const VerificationMeta(
    'masterCityId',
  );
  @override
  late final GeneratedColumn<int> masterCityId = GeneratedColumn<int>(
    'master_city_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES master_cities (id)',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    masterCityId,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_cities';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserCity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('master_city_id')) {
      context.handle(
        _masterCityIdMeta,
        masterCityId.isAcceptableOrUnknown(
          data['master_city_id']!,
          _masterCityIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_masterCityIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserCity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserCity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      masterCityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}master_city_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserCitiesTable createAlias(String alias) {
    return $UserCitiesTable(attachedDatabase, alias);
  }
}

class UserCity extends DataClass implements Insertable<UserCity> {
  final int id;
  final int masterCityId;
  final int sortOrder;
  final DateTime createdAt;
  const UserCity({
    required this.id,
    required this.masterCityId,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['master_city_id'] = Variable<int>(masterCityId);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserCitiesCompanion toCompanion(bool nullToAbsent) {
    return UserCitiesCompanion(
      id: Value(id),
      masterCityId: Value(masterCityId),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory UserCity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserCity(
      id: serializer.fromJson<int>(json['id']),
      masterCityId: serializer.fromJson<int>(json['masterCityId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'masterCityId': serializer.toJson<int>(masterCityId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserCity copyWith({
    int? id,
    int? masterCityId,
    int? sortOrder,
    DateTime? createdAt,
  }) => UserCity(
    id: id ?? this.id,
    masterCityId: masterCityId ?? this.masterCityId,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  UserCity copyWithCompanion(UserCitiesCompanion data) {
    return UserCity(
      id: data.id.present ? data.id.value : this.id,
      masterCityId: data.masterCityId.present
          ? data.masterCityId.value
          : this.masterCityId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserCity(')
          ..write('id: $id, ')
          ..write('masterCityId: $masterCityId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, masterCityId, sortOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserCity &&
          other.id == this.id &&
          other.masterCityId == this.masterCityId &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class UserCitiesCompanion extends UpdateCompanion<UserCity> {
  final Value<int> id;
  final Value<int> masterCityId;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  const UserCitiesCompanion({
    this.id = const Value.absent(),
    this.masterCityId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UserCitiesCompanion.insert({
    this.id = const Value.absent(),
    required int masterCityId,
    required int sortOrder,
    this.createdAt = const Value.absent(),
  }) : masterCityId = Value(masterCityId),
       sortOrder = Value(sortOrder);
  static Insertable<UserCity> custom({
    Expression<int>? id,
    Expression<int>? masterCityId,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (masterCityId != null) 'master_city_id': masterCityId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UserCitiesCompanion copyWith({
    Value<int>? id,
    Value<int>? masterCityId,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
  }) {
    return UserCitiesCompanion(
      id: id ?? this.id,
      masterCityId: masterCityId ?? this.masterCityId,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (masterCityId.present) {
      map['master_city_id'] = Variable<int>(masterCityId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserCitiesCompanion(')
          ..write('id: $id, ')
          ..write('masterCityId: $masterCityId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MasterCitiesTable masterCities = $MasterCitiesTable(this);
  late final $UserCitiesTable userCities = $UserCitiesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    masterCities,
    userCities,
  ];
}

typedef $$MasterCitiesTableCreateCompanionBuilder =
    MasterCitiesCompanion Function({Value<int> id, required String name});
typedef $$MasterCitiesTableUpdateCompanionBuilder =
    MasterCitiesCompanion Function({Value<int> id, Value<String> name});

final class $$MasterCitiesTableReferences
    extends BaseReferences<_$AppDatabase, $MasterCitiesTable, MasterCity> {
  $$MasterCitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserCitiesTable, List<UserCity>>
  _userCitiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userCities,
    aliasName: $_aliasNameGenerator(
      db.masterCities.id,
      db.userCities.masterCityId,
    ),
  );

  $$UserCitiesTableProcessedTableManager get userCitiesRefs {
    final manager = $$UserCitiesTableTableManager(
      $_db,
      $_db.userCities,
    ).filter((f) => f.masterCityId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_userCitiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MasterCitiesTableFilterComposer
    extends Composer<_$AppDatabase, $MasterCitiesTable> {
  $$MasterCitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> userCitiesRefs(
    Expression<bool> Function($$UserCitiesTableFilterComposer f) f,
  ) {
    final $$UserCitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userCities,
      getReferencedColumn: (t) => t.masterCityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCitiesTableFilterComposer(
            $db: $db,
            $table: $db.userCities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MasterCitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $MasterCitiesTable> {
  $$MasterCitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MasterCitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MasterCitiesTable> {
  $$MasterCitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> userCitiesRefs<T extends Object>(
    Expression<T> Function($$UserCitiesTableAnnotationComposer a) f,
  ) {
    final $$UserCitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userCities,
      getReferencedColumn: (t) => t.masterCityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.userCities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MasterCitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MasterCitiesTable,
          MasterCity,
          $$MasterCitiesTableFilterComposer,
          $$MasterCitiesTableOrderingComposer,
          $$MasterCitiesTableAnnotationComposer,
          $$MasterCitiesTableCreateCompanionBuilder,
          $$MasterCitiesTableUpdateCompanionBuilder,
          (MasterCity, $$MasterCitiesTableReferences),
          MasterCity,
          PrefetchHooks Function({bool userCitiesRefs})
        > {
  $$MasterCitiesTableTableManager(_$AppDatabase db, $MasterCitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MasterCitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MasterCitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MasterCitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => MasterCitiesCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  MasterCitiesCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MasterCitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userCitiesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (userCitiesRefs) db.userCities],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userCitiesRefs)
                    await $_getPrefetchedData<
                      MasterCity,
                      $MasterCitiesTable,
                      UserCity
                    >(
                      currentTable: table,
                      referencedTable: $$MasterCitiesTableReferences
                          ._userCitiesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MasterCitiesTableReferences(
                            db,
                            table,
                            p0,
                          ).userCitiesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.masterCityId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MasterCitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MasterCitiesTable,
      MasterCity,
      $$MasterCitiesTableFilterComposer,
      $$MasterCitiesTableOrderingComposer,
      $$MasterCitiesTableAnnotationComposer,
      $$MasterCitiesTableCreateCompanionBuilder,
      $$MasterCitiesTableUpdateCompanionBuilder,
      (MasterCity, $$MasterCitiesTableReferences),
      MasterCity,
      PrefetchHooks Function({bool userCitiesRefs})
    >;
typedef $$UserCitiesTableCreateCompanionBuilder =
    UserCitiesCompanion Function({
      Value<int> id,
      required int masterCityId,
      required int sortOrder,
      Value<DateTime> createdAt,
    });
typedef $$UserCitiesTableUpdateCompanionBuilder =
    UserCitiesCompanion Function({
      Value<int> id,
      Value<int> masterCityId,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
    });

final class $$UserCitiesTableReferences
    extends BaseReferences<_$AppDatabase, $UserCitiesTable, UserCity> {
  $$UserCitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MasterCitiesTable _masterCityIdTable(_$AppDatabase db) =>
      db.masterCities.createAlias(
        $_aliasNameGenerator(db.userCities.masterCityId, db.masterCities.id),
      );

  $$MasterCitiesTableProcessedTableManager get masterCityId {
    final $_column = $_itemColumn<int>('master_city_id')!;

    final manager = $$MasterCitiesTableTableManager(
      $_db,
      $_db.masterCities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_masterCityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserCitiesTableFilterComposer
    extends Composer<_$AppDatabase, $UserCitiesTable> {
  $$UserCitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MasterCitiesTableFilterComposer get masterCityId {
    final $$MasterCitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.masterCityId,
      referencedTable: $db.masterCities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MasterCitiesTableFilterComposer(
            $db: $db,
            $table: $db.masterCities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserCitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserCitiesTable> {
  $$UserCitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MasterCitiesTableOrderingComposer get masterCityId {
    final $$MasterCitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.masterCityId,
      referencedTable: $db.masterCities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MasterCitiesTableOrderingComposer(
            $db: $db,
            $table: $db.masterCities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserCitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserCitiesTable> {
  $$UserCitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MasterCitiesTableAnnotationComposer get masterCityId {
    final $$MasterCitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.masterCityId,
      referencedTable: $db.masterCities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MasterCitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.masterCities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserCitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserCitiesTable,
          UserCity,
          $$UserCitiesTableFilterComposer,
          $$UserCitiesTableOrderingComposer,
          $$UserCitiesTableAnnotationComposer,
          $$UserCitiesTableCreateCompanionBuilder,
          $$UserCitiesTableUpdateCompanionBuilder,
          (UserCity, $$UserCitiesTableReferences),
          UserCity,
          PrefetchHooks Function({bool masterCityId})
        > {
  $$UserCitiesTableTableManager(_$AppDatabase db, $UserCitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserCitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserCitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserCitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> masterCityId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UserCitiesCompanion(
                id: id,
                masterCityId: masterCityId,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int masterCityId,
                required int sortOrder,
                Value<DateTime> createdAt = const Value.absent(),
              }) => UserCitiesCompanion.insert(
                id: id,
                masterCityId: masterCityId,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserCitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({masterCityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (masterCityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.masterCityId,
                                referencedTable: $$UserCitiesTableReferences
                                    ._masterCityIdTable(db),
                                referencedColumn: $$UserCitiesTableReferences
                                    ._masterCityIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserCitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserCitiesTable,
      UserCity,
      $$UserCitiesTableFilterComposer,
      $$UserCitiesTableOrderingComposer,
      $$UserCitiesTableAnnotationComposer,
      $$UserCitiesTableCreateCompanionBuilder,
      $$UserCitiesTableUpdateCompanionBuilder,
      (UserCity, $$UserCitiesTableReferences),
      UserCity,
      PrefetchHooks Function({bool masterCityId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MasterCitiesTableTableManager get masterCities =>
      $$MasterCitiesTableTableManager(_db, _db.masterCities);
  $$UserCitiesTableTableManager get userCities =>
      $$UserCitiesTableTableManager(_db, _db.userCities);
}
