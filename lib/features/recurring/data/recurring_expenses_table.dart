import 'package:drift/drift.dart';

class RecurringExpenses extends Table {
  TextColumn get id => text()();

  TextColumn get householdId => text()();

  TextColumn get name => text()();

  IntColumn get defaultAmount => integer()();

  TextColumn get categoryId => text()();

  TextColumn get defaultAccountId => text().nullable()();

  IntColumn get dueDay => integer().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get createdBy => text()();

  TextColumn get updatedBy => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
