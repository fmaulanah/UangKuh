import 'sync_repository.dart';
import 'package:flutter/foundation.dart';

import '../database/app_database.dart';
import '../firebase/firestore_repository.dart';

import '../../features/transaction/domain/sync_status.dart';

class FirebaseSyncRepository implements SyncRepository {
  FirebaseSyncRepository(
    this._database,
    this._firestoreRepository,
  );

  final AppDatabase _database;
  final FirestoreRepository _firestoreRepository;

  @override
  Future<void> uploadPendingAccounts() async {}

  @override
  Future<void> uploadPendingTransactions() async {
    final pendingTransactions = await (_database.select(_database.transactions)
          ..where(
            (row) => row.syncStatus.equals(
              SyncStatus.pending.name,
            ),
          ))
        .get();

    if (pendingTransactions.isEmpty) {
      return;
    }

    final transaction = pendingTransactions.first;

    await _firestoreRepository.createTransaction(
      transaction: {
        'id': transaction.id,
        'householdId': transaction.householdId,
        'type': transaction.type.name,
        'expenseType': transaction.expenseType?.name,
        'amount': transaction.amount,
        'sourceAccountId': transaction.sourceAccountId,
        'destinationAccountId': transaction.destinationAccountId,
        'categoryId': transaction.categoryId,
        'description': transaction.description,
        'transactionDate': transaction.transactionDate,
        'createdBy': transaction.createdBy,
        'updatedBy': transaction.updatedBy,
        'createdAt': transaction.createdAt,
        'updatedAt': transaction.updatedAt,
        'syncStatus': transaction.syncStatus.name,
        'isDeleted': transaction.isDeleted,
      },
    );

    debugPrint(
      'Pending Transactions : ${pendingTransactions.length}',
    );
  }
}
