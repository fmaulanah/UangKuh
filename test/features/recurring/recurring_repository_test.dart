import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uangkuh/core/database/app_database.dart';

import 'package:uangkuh/features/account/data/drift_account_repository.dart';
import 'package:uangkuh/features/account/domain/account_purpose.dart';
import 'package:uangkuh/features/account/domain/account_type.dart';

import 'package:uangkuh/features/category/domain/category_type.dart';

import 'package:uangkuh/features/household/domain/household_role.dart';

import 'package:uangkuh/features/recurring/data/drift_recurring_repository.dart';
import 'package:uangkuh/features/recurring/domain/recurring_payment_status.dart';

import 'package:uangkuh/features/transaction/domain/expense_type.dart';
import 'package:uangkuh/features/transaction/domain/transaction_type.dart';

void main() {
  late AppDatabase database;
  late DriftAccountRepository accountRepository;
  late DriftRecurringRepository recurringRepository;

  setUp(() {
    database = AppDatabase.forTesting(
      NativeDatabase.memory(),
    );

    accountRepository = DriftAccountRepository(database);
    recurringRepository = DriftRecurringRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'creates an active recurring expense master',
    () async {
      const userId = 'user-1';
      const householdId = 'household-1';
      const accountId = 'account-bca';
      const categoryId = 'category-bills';
      const recurringId = 'recurring-internet';

      final now = DateTime.now();

      await database.into(database.users).insert(
            UsersCompanion.insert(
              id: userId,
              email: 'test@example.com',
              displayName: 'Test User',
              createdAt: now,
              updatedAt: now,
            ),
          );

      await database.into(database.households).insert(
            HouseholdsCompanion.insert(
              id: householdId,
              name: 'Test Household',
              inviteCode: 'TEST123',
              createdBy: userId,
              createdAt: now,
              updatedAt: now,
            ),
          );

      await database.into(database.householdMembers).insert(
            HouseholdMembersCompanion.insert(
              id: 'member-1',
              householdId: householdId,
              userId: userId,
              role: HouseholdRole.owner,
              joinedAt: now,
            ),
          );

      await accountRepository.createAccount(
        id: accountId,
        householdId: householdId,
        name: 'BCA',
        type: AccountType.bank,
        purpose: AccountPurpose.spending,
        initialBalance: 5000000,
        userId: userId,
      );

      await database.into(database.categories).insert(
            CategoriesCompanion.insert(
              id: categoryId,
              householdId: householdId,
              name: 'Bills',
              type: CategoryType.expense,
              iconKey: 'bills',
              createdAt: now,
              updatedAt: now,
              createdBy: userId,
              updatedBy: userId,
            ),
          );

      await recurringRepository.createRecurringExpense(
        id: recurringId,
        householdId: householdId,
        name: 'Internet',
        defaultAmount: 350000,
        categoryId: categoryId,
        defaultAccountId: accountId,
        dueDay: 10,
        userId: userId,
      );

      final recurring = await recurringRepository.getRecurringExpenseById(
        recurringId,
      );

      expect(recurring, isNotNull);

      expect(recurring!.id, recurringId);
      expect(recurring.householdId, householdId);
      expect(recurring.name, 'Internet');
      expect(recurring.defaultAmount, 350000);
      expect(recurring.categoryId, categoryId);
      expect(recurring.defaultAccountId, accountId);
      expect(recurring.dueDay, 10);
      expect(recurring.isActive, isTrue);
    },
  );

  test(
    'pays recurring expense for a monthly period',
    () async {
      const userId = 'user-1';
      const householdId = 'household-1';
      const accountId = 'account-bca';
      const categoryId = 'category-bills';
      const recurringId = 'recurring-internet';

      const paymentId = 'payment-internet-2026-07';
      const transactionId = 'transaction-internet-2026-07';

      final now = DateTime.now();

      await database.into(database.users).insert(
            UsersCompanion.insert(
              id: userId,
              email: 'test@example.com',
              displayName: 'Test User',
              createdAt: now,
              updatedAt: now,
            ),
          );

      await database.into(database.households).insert(
            HouseholdsCompanion.insert(
              id: householdId,
              name: 'Test Household',
              inviteCode: 'TEST123',
              createdBy: userId,
              createdAt: now,
              updatedAt: now,
            ),
          );

      await database.into(database.householdMembers).insert(
            HouseholdMembersCompanion.insert(
              id: 'member-1',
              householdId: householdId,
              userId: userId,
              role: HouseholdRole.owner,
              joinedAt: now,
            ),
          );

      await accountRepository.createAccount(
        id: accountId,
        householdId: householdId,
        name: 'BCA',
        type: AccountType.bank,
        purpose: AccountPurpose.spending,
        initialBalance: 5000000,
        userId: userId,
      );

      await database.into(database.categories).insert(
            CategoriesCompanion.insert(
              id: categoryId,
              householdId: householdId,
              name: 'Bills',
              type: CategoryType.expense,
              iconKey: 'bills',
              createdAt: now,
              updatedAt: now,
              createdBy: userId,
              updatedBy: userId,
            ),
          );

      await recurringRepository.createRecurringExpense(
        id: recurringId,
        householdId: householdId,
        name: 'Internet',
        defaultAmount: 350000,
        categoryId: categoryId,
        defaultAccountId: accountId,
        dueDay: 10,
        userId: userId,
      );

      await recurringRepository.payRecurringExpense(
        paymentId: paymentId,
        transactionId: transactionId,
        recurringExpenseId: recurringId,
        householdId: householdId,
        periodYear: 2026,
        periodMonth: 7,
        amount: 367500,
        sourceAccountId: accountId,
        description: 'Internet July 2026',
        transactionDate: now,
        userId: userId,
      );

      final payment = await (database.select(database.recurringPayments)
            ..where(
              (payment) => payment.id.equals(paymentId),
            ))
          .getSingleOrNull();

      expect(payment, isNotNull);

      expect(payment!.recurringExpenseId, recurringId);
      expect(payment.householdId, householdId);
      expect(payment.periodYear, 2026);
      expect(payment.periodMonth, 7);
      expect(payment.status, RecurringPaymentStatus.paid);
      expect(payment.transactionId, transactionId);

      final transaction = await (database.select(database.transactions)
            ..where(
              (transaction) => transaction.id.equals(transactionId),
            ))
          .getSingleOrNull();

      expect(transaction, isNotNull);

      expect(transaction!.householdId, householdId);
      expect(transaction.type, TransactionType.expense);
      expect(transaction.expenseType, ExpenseType.recurring);
      expect(transaction.amount, 367500);
      expect(transaction.sourceAccountId, accountId);
      expect(transaction.destinationAccountId, isNull);
      expect(transaction.categoryId, categoryId);
      expect(transaction.isDeleted, isFalse);

      final balance = await accountRepository.getCurrentBalance(accountId);

      expect(balance, 4632500);

      expect(
        () => recurringRepository.payRecurringExpense(
          paymentId: 'payment-internet-2026-07-duplicate',
          transactionId: 'transaction-internet-2026-07-duplicate',
          recurringExpenseId: recurringId,
          householdId: householdId,
          periodYear: 2026,
          periodMonth: 7,
          amount: 367500,
          sourceAccountId: accountId,
          description: 'Duplicate Internet July 2026',
          transactionDate: now,
          userId: userId,
        ),
        throwsStateError,
      );

      final duplicateTransaction = await (database.select(database.transactions)
            ..where(
              (transaction) => transaction.id.equals(
                'transaction-internet-2026-07-duplicate',
              ),
            ))
          .getSingleOrNull();

      expect(duplicateTransaction, isNull);

      final balanceAfterDuplicateAttempt =
          await accountRepository.getCurrentBalance(accountId);

      expect(balanceAfterDuplicateAttempt, 4632500);
    },
  );
}
