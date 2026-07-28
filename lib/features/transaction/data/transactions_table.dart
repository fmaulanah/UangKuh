import 'package:drift/drift.dart';

import '../domain/expense_type.dart';
import '../domain/sync_status.dart';
import '../domain/transaction_type.dart';

class Transactions extends Table {
  TextColumn get id => text()();

  TextColumn get householdId => text()();

  TextColumn get type => textEnum<TransactionType>()();

  TextColumn get expenseType => textEnum<ExpenseType>().nullable()();

  IntColumn get amount => integer()();

  TextColumn get sourceAccountId => text().nullable()();

  TextColumn get destinationAccountId => text().nullable()();

  TextColumn get categoryId => text().nullable()();

  TextColumn get description => text().nullable()();

  DateTimeColumn get transactionDate => dateTime()();

  TextColumn get createdBy => text()();

  TextColumn get updatedBy => text()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get syncStatus => textEnum<SyncStatus>()();

  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
