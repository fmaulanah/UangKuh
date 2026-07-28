import 'package:drift/drift.dart';

import '../../auth/data/users_table.dart';
import '../domain/household_role.dart';
import 'households_table.dart';

class HouseholdMembers extends Table {
  TextColumn get id => text()();

  TextColumn get householdId => text().references(Households, #id)();

  TextColumn get userId => text().unique().references(Users, #id)();

  TextColumn get role => textEnum<HouseholdRole>()();

  DateTimeColumn get joinedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
