import 'package:drift/drift.dart';

import '../../account/data/accounts_table.dart';
import '../../category/data/categories_table.dart';
import '../../household/data/households_table.dart';

class RecurringExpenses extends Table {
  TextColumn get id => text()();

  TextColumn get householdId => text().references(Households, #id)();

  TextColumn get name => text()();

  IntColumn get defaultAmount => integer()();

  TextColumn get categoryId => text().references(Categories, #id)();

  TextColumn get defaultAccountId =>
      text().nullable().references(Accounts, #id)();

  IntColumn get dueDay => integer().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get createdBy => text()();

  TextColumn get updatedBy => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
