import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/account/data/accounts_table.dart';
import '../../features/account/domain/account_purpose.dart';
import '../../features/account/domain/account_type.dart';

import '../../features/category/data/categories_table.dart';
import '../../features/category/domain/category_type.dart';

import '../../features/transaction/data/transactions_table.dart';
import '../../features/transaction/domain/expense_type.dart';
import '../../features/transaction/domain/sync_status.dart';
import '../../features/transaction/domain/transaction_type.dart';

import '../../features/recurring/data/recurring_expenses_table.dart';
import '../../features/recurring/data/recurring_payments_table.dart';
import '../../features/recurring/domain/recurring_payment_status.dart';

import '../../features/auth/data/users_table.dart';

import '../../features/household/data/household_members_table.dart';
import '../../features/household/data/households_table.dart';
import '../../features/household/domain/household_role.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Households,
    HouseholdMembers,
    Accounts,
    Categories,
    Transactions,
    RecurringExpenses,
    RecurringPayments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(
      p.join(dbFolder.path, 'uangkuh.sqlite'),
    );

    return NativeDatabase.createInBackground(file);
  });
}
