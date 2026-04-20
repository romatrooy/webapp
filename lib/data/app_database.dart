import 'package:drift/drift.dart';

import 'connection/connection.dart';

part 'app_database.g.dart';

class MasterCities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get countryCode => text().withLength(min: 0, max: 8).nullable()();
  RealColumn get lat => real().withDefault(const Constant(0))();
  RealColumn get lon => real().withDefault(const Constant(0))();
}

class UserCities extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get masterCityId => integer().references(MasterCities, #id)();
  IntColumn get sortOrder => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class UserCityWithName {
  const UserCityWithName({
    required this.userCityId,
    required this.masterCityId,
    required this.name,
    required this.countryCode,
    required this.lat,
    required this.lon,
    required this.sortOrder,
  });

  final int userCityId;
  final int masterCityId;
  final String name;
  final String? countryCode;
  final double lat;
  final double lon;
  final int sortOrder;
}

@DriftDatabase(tables: [MasterCities, UserCities])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(masterCities, masterCities.countryCode);
            await migrator.addColumn(masterCities, masterCities.lat);
            await migrator.addColumn(masterCities, masterCities.lon);
          }
        },
      );

  Future<void> seedMasterCitiesIfEmpty() async {
    final countExpr = masterCities.id.count();
    final countQuery = selectOnly(masterCities)..addColumns([countExpr]);
    final result = await countQuery.getSingle();
    final count = result.read(countExpr) ?? 0;
    if (count > 0) {
      return;
    }

    const initialCities = [
      'Москва',
      'Красноярск',
      'Екатеринбург',
      'Новосибирск',
      'Иркутск',
      'Омск',
      'Санкт-Петербург',
      'Калининград',
      'Казань',
      'Владивосток',
    ];

    await batch((b) {
      b.insertAll(
        masterCities,
        initialCities
            .map((name) => MasterCitiesCompanion.insert(name: name))
            .toList(),
      );
    });
  }

  Future<List<MasterCity>> searchMasterCities(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return (select(masterCities)
            ..orderBy([(t) => OrderingTerm.asc(t.name)])
            ..limit(10))
          .get();
    }

    return (select(masterCities)
          ..where((t) => t.name.lower().like('%$normalized%'))
          ..orderBy([(t) => OrderingTerm.asc(t.name)])
          ..limit(20))
        .get();
  }

  Future<MasterCity> upsertMasterCity({
    required String name,
    required String? countryCode,
    required double lat,
    required double lon,
  }) async {
    final existing = await (select(masterCities)
          ..where(
            (t) =>
                t.name.lower().equals(name.toLowerCase()) &
                t.lat.equals(lat) &
                t.lon.equals(lon),
          )
          ..limit(1))
        .getSingleOrNull();
    if (existing != null) {
      return existing;
    }

    final id = await into(masterCities).insert(
      MasterCitiesCompanion.insert(
        name: name,
        countryCode: Value(countryCode),
        lat: Value(lat),
        lon: Value(lon),
      ),
    );
    return (select(masterCities)..where((t) => t.id.equals(id))).getSingle();
  }

  Stream<List<UserCityWithName>> watchUserCities() {
    final query = select(userCities).join([
      innerJoin(masterCities, masterCities.id.equalsExp(userCities.masterCityId)),
    ])
      ..orderBy([OrderingTerm.asc(userCities.sortOrder)]);

    return query.watch().map(
          (rows) => rows
              .map(
                (row) => UserCityWithName(
                  userCityId: row.readTable(userCities).id,
                  masterCityId: row.readTable(userCities).masterCityId,
                  name: row.readTable(masterCities).name,
                  countryCode: row.readTable(masterCities).countryCode,
                  lat: row.readTable(masterCities).lat,
                  lon: row.readTable(masterCities).lon,
                  sortOrder: row.readTable(userCities).sortOrder,
                ),
              )
              .toList(),
        );
  }

  Future<void> addUserCity(int masterCityId) async {
    final alreadyExists = await (select(userCities)
          ..where((t) => t.masterCityId.equals(masterCityId))
          ..limit(1))
        .getSingleOrNull();
    if (alreadyExists != null) {
      return;
    }

    final maxSortExpr = userCities.sortOrder.max();
    final maxQuery = selectOnly(userCities)..addColumns([maxSortExpr]);
    final maxRow = await maxQuery.getSingle();
    final nextSort = (maxRow.read(maxSortExpr) ?? -1) + 1;

    await into(userCities).insert(
      UserCitiesCompanion.insert(masterCityId: masterCityId, sortOrder: nextSort),
    );
  }

  Future<void> removeUserCity(int userCityId) {
    return (delete(userCities)..where((t) => t.id.equals(userCityId))).go();
  }

  Future<void> reorderUserCity({
    required int userCityId,
    required int newSortOrder,
  }) {
    return (update(userCities)..where((t) => t.id.equals(userCityId))).write(
      UserCitiesCompanion(sortOrder: Value(newSortOrder)),
    );
  }

  Future<void> reorderUserCities(List<int> orderedUserCityIds) async {
    await transaction(() async {
      for (var i = 0; i < orderedUserCityIds.length; i++) {
        await (update(userCities)..where((t) => t.id.equals(orderedUserCityIds[i]))).write(
          UserCitiesCompanion(sortOrder: Value(i)),
        );
      }
    });
  }
}

LazyDatabase _openConnection() {
  return openConnection();
}
