import 'sync_repository.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../database/app_database.dart';
import '../firebase/firestore_repository.dart';
import '../../features/auth/data/session_bootstrap.dart';
import '../../features/auth/domain/app_session.dart';

import '../../features/transaction/domain/sync_status.dart';

class FirebaseSyncRepository implements SyncRepository {
  FirebaseSyncRepository(
    this._database,
    this._firestoreRepository,
    this._sessionBootstrap,
    this._session,
  );

  final AppDatabase _database;
  final FirestoreRepository _firestoreRepository;
  final SessionBootstrap _sessionBootstrap;
  final AppSession? _session;

  @override
  Future<void> uploadPendingAccounts() async {}

  @override
  Future<void> uploadAccounts() async {
    final accounts = await _database.select(_database.accounts).get();

    for (final account in accounts) {
      try {
        await _firestoreRepository.upsertAccount(
          id: account.id,
          account: {
            'id': account.id,
            'householdId': account.householdId,
            'name': account.name,
            'type': account.type.name,
            'purpose': account.purpose.name,
            'initialBalance': account.initialBalance,
            'isArchived': account.isArchived,
            'createdAt': account.createdAt,
            'updatedAt': account.updatedAt,
            'createdBy': account.createdBy,
            'updatedBy': account.updatedBy,
          },
        );
      } catch (error) {
        debugPrint(
          'Account upload failed (${account.id}): $error',
        );
      }
    }
  }

  @override
  Future<void> uploadCategories() async {
    final categories = await _database.select(_database.categories).get();

    for (final category in categories) {
      await _firestoreRepository.upsertCategory(
        id: category.id,
        category: {
          'id': category.id,
          'householdId': category.householdId,
          'name': category.name,
          'type': category.type.name,
          'iconKey': category.iconKey,
          'isDefault': category.isDefault,
          'isArchived': category.isArchived,
          'createdAt': category.createdAt,
          'updatedAt': category.updatedAt,
          'createdBy': category.createdBy,
          'updatedBy': category.updatedBy,
        },
      );
    }
  }

  @override
  Future<void> uploadRecurringExpenses() async {
    debugPrint('Recurring expense upload started');

    final recurringExpenses =
        await _database.select(_database.recurringExpenses).get();

    debugPrint(
      'Local recurring expenses found: ${recurringExpenses.length}',
    );

    for (final recurringExpense in recurringExpenses) {
      debugPrint(
        'Uploading recurring expense: '
        'id=${recurringExpense.id}, '
        'householdId=${recurringExpense.householdId}, '
        'name=${recurringExpense.name}',
      );

      await _firestoreRepository.upsertRecurringExpense(
        id: recurringExpense.id,
        recurringExpense: {
          'id': recurringExpense.id,
          'householdId': recurringExpense.householdId,
          'name': recurringExpense.name,
          'defaultAmount': recurringExpense.defaultAmount,
          'categoryId': recurringExpense.categoryId,
          'defaultAccountId': recurringExpense.defaultAccountId,
          'dueDay': recurringExpense.dueDay,
          'isActive': recurringExpense.isActive,
          'createdAt': recurringExpense.createdAt,
          'updatedAt': recurringExpense.updatedAt,
          'createdBy': recurringExpense.createdBy,
          'updatedBy': recurringExpense.updatedBy,
        },
      );

      debugPrint(
        'Recurring expense upload success: ${recurringExpense.id}',
      );
    }
  }

  @override
  Future<void> uploadRecurringPayments() async {
    final recurringPayments =
        await _database.select(_database.recurringPayments).get();

    for (final recurringPayment in recurringPayments) {
      await _firestoreRepository.upsertRecurringPayment(
        id: recurringPayment.id,
        recurringPayment: {
          'id': recurringPayment.id,
          'householdId': recurringPayment.householdId,
          'recurringExpenseId': recurringPayment.recurringExpenseId,
          'periodYear': recurringPayment.periodYear,
          'periodMonth': recurringPayment.periodMonth,
          'status': recurringPayment.status.name,
          'transactionId': recurringPayment.transactionId,
          'createdAt': recurringPayment.createdAt,
          'updatedAt': recurringPayment.updatedAt,
          'createdBy': recurringPayment.createdBy,
          'updatedBy': recurringPayment.updatedBy,
        },
      );
    }
  }

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

    for (final transaction in pendingTransactions) {
      try {
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

        await (_database.update(_database.transactions)
              ..where((row) => row.id.equals(transaction.id)))
            .write(
              TransactionsCompanion(
                syncStatus: const Value(SyncStatus.synced),
              ),
            );
      } catch (error) {
        debugPrint(
          'Transaction upload failed (${transaction.id}): $error',
        );
      }
    }

    debugPrint(
      'Pending Transactions : ${pendingTransactions.length}',
    );
  }

  @override
  Future<void> syncAll() async {
    await uploadAccounts();
    await uploadCategories();
    await uploadPendingTransactions();
    await uploadRecurringExpenses();
    await uploadRecurringPayments();

    final session = _session;

    if (session == null) {
      throw StateError('Cannot sync without an active session.');
    }

    await _sessionBootstrap.bootstrap(
      userId: session.userId,
      email: session.email,
      displayName: session.displayName,
    );
  }
}





