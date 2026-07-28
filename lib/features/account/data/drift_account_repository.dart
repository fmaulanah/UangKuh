import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/account_repository.dart';

class DriftAccountRepository implements AccountRepository {
  DriftAccountRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Account>> getAccounts(String householdId) {
    return (_database.select(_database.accounts)
          ..where(
            (account) =>
                account.householdId.equals(householdId) &
                account.isArchived.equals(false),
          )
          ..orderBy([
            (account) => OrderingTerm.asc(account.name),
          ]))
        .get();
  }
}
