import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uangkuh/core/database/app_database.dart';
import 'package:uangkuh/features/account/data/drift_account_repository.dart';
import 'package:uangkuh/features/account/domain/account_purpose.dart';
import 'package:uangkuh/features/account/domain/account_type.dart';
import 'package:uangkuh/features/household/domain/household_role.dart';

import 'package:uangkuh/features/category/domain/category_type.dart';
import 'package:uangkuh/features/transaction/data/drift_transaction_repository.dart';
import 'package:uangkuh/features/transaction/domain/expense_type.dart';

void main() {
  late AppDatabase database;
  late DriftAccountRepository accountRepository;
  late DriftTransactionRepository transactionRepository;

  setUp(() {
    database = AppDatabase.forTesting(
      NativeDatabase.memory(),
    );

    accountRepository = DriftAccountRepository(database);
    transactionRepository = DriftTransactionRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'current balance equals initial balance when account has no transactions',
    () async {
      // Arrange
      const userId = 'user-1';
      const householdId = 'household-1';
      const accountId = 'account-1';

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

      // Act
      final balance = await accountRepository.getCurrentBalance(
        accountId,
      );

      // Assert
      expect(balance, 5000000);
    },
  );

  test(
    'expense decreases balance and income increases balance',
    () async {
      // Arrange
      const userId = 'user-1';
      const householdId = 'household-1';
      const accountId = 'account-1';

      const expenseCategoryId = 'category-expense';
      const incomeCategoryId = 'category-income';

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
              id: expenseCategoryId,
              householdId: householdId,
              name: 'Food',
              type: CategoryType.expense,
              iconKey: 'food',
              createdAt: now,
              updatedAt: now,
              createdBy: userId,
              updatedBy: userId,
            ),
          );

      await database.into(database.categories).insert(
            CategoriesCompanion.insert(
              id: incomeCategoryId,
              householdId: householdId,
              name: 'Salary',
              type: CategoryType.income,
              iconKey: 'salary',
              createdAt: now,
              updatedAt: now,
              createdBy: userId,
              updatedBy: userId,
            ),
          );

      await transactionRepository.createExpense(
        id: 'transaction-expense-1',
        householdId: householdId,
        sourceAccountId: accountId,
        categoryId: expenseCategoryId,
        amount: 100000,
        expenseType: ExpenseType.daily,
        description: 'Lunch',
        transactionDate: now,
        userId: userId,
      );

      await transactionRepository.createIncome(
        id: 'transaction-income-1',
        householdId: householdId,
        destinationAccountId: accountId,
        categoryId: incomeCategoryId,
        amount: 2000000,
        description: 'Salary',
        transactionDate: now,
        userId: userId,
      );

      // Act
      final balance = await accountRepository.getCurrentBalance(
        accountId,
      );

      // Assert
      expect(balance, 6900000);
    },
  );

  test(
    'transfer moves balance between accounts without changing total balance',
    () async {
      // Arrange
      const userId = 'user-1';
      const householdId = 'household-1';

      const sourceAccountId = 'account-bca';
      const destinationAccountId = 'account-gopay';

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
        id: sourceAccountId,
        householdId: householdId,
        name: 'BCA',
        type: AccountType.bank,
        purpose: AccountPurpose.spending,
        initialBalance: 5000000,
        userId: userId,
      );

      await accountRepository.createAccount(
        id: destinationAccountId,
        householdId: householdId,
        name: 'GoPay',
        type: AccountType.eWallet,
        purpose: AccountPurpose.spending,
        initialBalance: 100000,
        userId: userId,
      );

      final totalBefore = await accountRepository.getTotalBalance(
        householdId,
      );

      expect(totalBefore, 5100000);

      await transactionRepository.createTransfer(
        id: 'transaction-transfer-1',
        householdId: householdId,
        sourceAccountId: sourceAccountId,
        destinationAccountId: destinationAccountId,
        amount: 500000,
        description: 'Top up GoPay',
        transactionDate: now,
        userId: userId,
      );

      // Act
      final sourceBalance =
          await accountRepository.getCurrentBalance(sourceAccountId);

      final destinationBalance =
          await accountRepository.getCurrentBalance(destinationAccountId);

      final totalAfter = await accountRepository.getTotalBalance(
        householdId,
      );

      // Assert
      expect(sourceBalance, 4500000);
      expect(destinationBalance, 600000);
      expect(totalAfter, 5100000);
    },
  );

  test(
    'positive and negative adjustments change account balance correctly',
    () async {
      // Arrange
      const userId = 'user-1';
      const householdId = 'household-1';
      const accountId = 'account-bca';

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

      await transactionRepository.createAdjustment(
        id: 'adjustment-positive',
        householdId: householdId,
        accountId: accountId,
        amount: 200000,
        description: 'Balance correction',
        transactionDate: now,
        userId: userId,
      );

      final balanceAfterPositive =
          await accountRepository.getCurrentBalance(accountId);

      expect(balanceAfterPositive, 5200000);

      await transactionRepository.createAdjustment(
        id: 'adjustment-negative',
        householdId: householdId,
        accountId: accountId,
        amount: -50000,
        description: 'Cash difference',
        transactionDate: now,
        userId: userId,
      );

      final balanceAfterNegative =
          await accountRepository.getCurrentBalance(accountId);

      expect(balanceAfterNegative, 5150000);
    },
  );

  test(
    'soft-deleted transaction no longer affects balance but remains stored',
    () async {
      // Arrange
      const userId = 'user-1';
      const householdId = 'household-1';
      const accountId = 'account-bca';
      const categoryId = 'category-food';
      const transactionId = 'expense-1';

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
              name: 'Food',
              type: CategoryType.expense,
              iconKey: 'food',
              createdAt: now,
              updatedAt: now,
              createdBy: userId,
              updatedBy: userId,
            ),
          );

      await transactionRepository.createExpense(
        id: transactionId,
        householdId: householdId,
        sourceAccountId: accountId,
        categoryId: categoryId,
        amount: 100000,
        expenseType: ExpenseType.daily,
        description: 'Lunch',
        transactionDate: now,
        userId: userId,
      );

      final balanceBeforeDelete =
          await accountRepository.getCurrentBalance(accountId);

      expect(balanceBeforeDelete, 4900000);

      await (database.update(database.transactions)
            ..where(
              (transaction) => transaction.id.equals(transactionId),
            ))
          .write(
        TransactionsCompanion(
          isDeleted: const drift.Value(true),
          updatedAt: drift.Value(now),
          updatedBy: const drift.Value(userId),
        ),
      );

      final balanceAfterDelete =
          await accountRepository.getCurrentBalance(accountId);

      expect(balanceAfterDelete, 5000000);

      final storedTransaction =
          await transactionRepository.getTransactionById(transactionId);

      expect(storedTransaction, isNotNull);
      expect(storedTransaction!.isDeleted, isTrue);
      expect(storedTransaction.amount, 100000);
    },
  );
}
