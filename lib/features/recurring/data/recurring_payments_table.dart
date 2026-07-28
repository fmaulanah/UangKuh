import 'package:drift/drift.dart';

import '../domain/recurring_payment_status.dart';

class RecurringPayments extends Table {
  TextColumn get id => text()();

  TextColumn get householdId => text()();

  TextColumn get recurringExpenseId => text()();

  IntColumn get periodYear => integer()();

  IntColumn get periodMonth => integer()();

  TextColumn get status => textEnum<RecurringPaymentStatus>()();

  TextColumn get transactionId => text().nullable()();

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
