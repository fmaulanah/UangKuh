import 'package:drift/drift.dart';

import '../domain/household_role.dart';

class HouseholdMembers extends Table {
  TextColumn get id => text()();

  TextColumn get householdId => text()();

  TextColumn get userId => text().unique()();

  TextColumn get role => textEnum<HouseholdRole>()();

  DateTimeColumn get joinedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
