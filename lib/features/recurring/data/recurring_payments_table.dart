import 'package:drift/drift.dart';

import '../domain/recurring_payment_status.dart';

import '../../household/data/households_table.dart';
import '../../transaction/data/transactions_table.dart';

import 'recurring_expenses_table.dart';

class RecurringPayments extends Table {
  TextColumn get id => text()();

  TextColumn get householdId => text().references(Households, #id)();

  TextColumn get recurringExpenseId =>
      text().references(RecurringExpenses, #id)();

  IntColumn get periodYear => integer()();

  IntColumn get periodMonth => integer()();

  TextColumn get status => textEnum<RecurringPaymentStatus>()();

  TextColumn get transactionId =>
      text().nullable().references(Transactions, #id)();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get createdBy => text()();

  TextColumn get updatedBy => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {
          recurringExpenseId,
          periodYear,
          periodMonth,
        },
      ];
}
