import 'package:drift/drift.dart';

import '../domain/account_purpose.dart';
import '../domain/account_type.dart';

import '../../household/data/households_table.dart';

class Accounts extends Table {
  TextColumn get id => text()();

  TextColumn get householdId => text().references(Households, #id)();

  TextColumn get name => text()();

  TextColumn get type => textEnum<AccountType>()();

  TextColumn get purpose => textEnum<AccountPurpose>()();

  IntColumn get initialBalance => integer()();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get createdBy => text()();

  TextColumn get updatedBy => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
