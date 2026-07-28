import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uangkuh/core/database/app_database.dart';
import 'package:uangkuh/features/transaction/data/drift_transaction_repository.dart';
import 'package:uangkuh/features/transaction/domain/expense_type.dart';

import 'package:uangkuh/features/account/data/drift_account_repository.dart';
import 'package:uangkuh/features/account/domain/account_purpose.dart';
import 'package:uangkuh/features/account/domain/account_type.dart';
import 'package:uangkuh/features/category/domain/category_type.dart';
import 'package:uangkuh/features/household/domain/household_role.dart';

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
    'expense rejects zero amount',
    () async {
      expect(
        () => transactionRepository.createExpense(
          id: 'expense-1',
          householdId: 'household-1',
          sourceAccountId: 'account-1',
          categoryId: 'category-1',
          amount: 0,
          expenseType: ExpenseType.daily,
          transactionDate: DateTime.now(),
          userId: 'user-1',
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'income rejects negative amount',
    () async {
      expect(
        () => transactionRepository.createIncome(
          id: 'income-1',
          householdId: 'household-1',
          destinationAccountId: 'account-1',
          categoryId: 'category-1',
          amount: -100000,
          transactionDate: DateTime.now(),
          userId: 'user-1',
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'transfer rejects zero amount',
    () async {
      expect(
        () => transactionRepository.createTransfer(
          id: 'transfer-1',
          householdId: 'household-1',
          sourceAccountId: 'account-1',
          destinationAccountId: 'account-2',
          amount: 0,
          transactionDate: DateTime.now(),
          userId: 'user-1',
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'adjustment rejects zero amount',
    () async {
      expect(
        () => transactionRepository.createAdjustment(
          id: 'adjustment-1',
          householdId: 'household-1',
          accountId: 'account-1',
          amount: 0,
          transactionDate: DateTime.now(),
          userId: 'user-1',
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'transfer rejects same source and destination account',
    () async {
      expect(
        () => transactionRepository.createTransfer(
          id: 'transfer-same-account',
          householdId: 'household-1',
          sourceAccountId: 'account-1',
          destinationAccountId: 'account-1',
          amount: 500000,
          transactionDate: DateTime.now(),
          userId: 'user-1',
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'expense rejects income category',
    () async {
      const userId = 'user-1';
      const householdId = 'household-1';
      const accountId = 'account-1';
      const categoryId = 'category-income';

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
              name: 'Salary',
              type: CategoryType.income,
              iconKey: 'salary',
              createdAt: now,
              updatedAt: now,
              createdBy: userId,
              updatedBy: userId,
            ),
          );

      expect(
        () => transactionRepository.createExpense(
          id: 'expense-invalid-category',
          householdId: householdId,
          sourceAccountId: accountId,
          categoryId: categoryId,
          amount: 100000,
          expenseType: ExpenseType.daily,
          transactionDate: now,
          userId: userId,
        ),
        throwsStateError,
      );
    },
  );

  test(
    'income rejects expense category',
    () async {
      const userId = 'user-1';
      const householdId = 'household-1';
      const accountId = 'account-1';
      const categoryId = 'category-expense';

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

      expect(
        () => transactionRepository.createIncome(
          id: 'income-invalid-category',
          householdId: householdId,
          destinationAccountId: accountId,
          categoryId: categoryId,
          amount: 2000000,
          transactionDate: now,
          userId: userId,
        ),
        throwsStateError,
      );
    },
  );

  test(
    'expense rejects account from another household',
    () async {
      const userId = 'user-1';

      const householdAId = 'household-a';
      const householdBId = 'household-b';

      const accountBId = 'account-b';
      const categoryAId = 'category-a';

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
              id: householdAId,
              name: 'Household A',
              inviteCode: 'HOUSEA',
              createdBy: userId,
              createdAt: now,
              updatedAt: now,
            ),
          );

      await database.into(database.households).insert(
            HouseholdsCompanion.insert(
              id: householdBId,
              name: 'Household B',
              inviteCode: 'HOUSEB',
              createdBy: userId,
              createdAt: now,
              updatedAt: now,
            ),
          );

      await accountRepository.createAccount(
        id: accountBId,
        householdId: householdBId,
        name: 'BCA B',
        type: AccountType.bank,
        purpose: AccountPurpose.spending,
        initialBalance: 5000000,
        userId: userId,
      );

      await database.into(database.categories).insert(
            CategoriesCompanion.insert(
              id: categoryAId,
              householdId: householdAId,
              name: 'Food',
              type: CategoryType.expense,
              iconKey: 'food',
              createdAt: now,
              updatedAt: now,
              createdBy: userId,
              updatedBy: userId,
            ),
          );

      expect(
        () => transactionRepository.createExpense(
          id: 'expense-cross-household',
          householdId: householdAId,
          sourceAccountId: accountBId,
          categoryId: categoryAId,
          amount: 100000,
          expenseType: ExpenseType.daily,
          transactionDate: now,
          userId: userId,
        ),
        throwsStateError,
      );
    },
  );

  test(
    'expense rejects archived account',
    () async {
      const userId = 'user-1';
      const householdId = 'household-1';
      const accountId = 'account-1';
      const categoryId = 'category-1';

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

      await accountRepository.createAccount(
        id: accountId,
        householdId: householdId,
        name: 'Old BCA',
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

      await accountRepository.archiveAccount(
        id: accountId,
        userId: userId,
      );

      expect(
        () => transactionRepository.createExpense(
          id: 'expense-archived-account',
          householdId: householdId,
          sourceAccountId: accountId,
          categoryId: categoryId,
          amount: 100000,
          expenseType: ExpenseType.daily,
          transactionDate: now,
          userId: userId,
        ),
        throwsStateError,
      );
    },
  );

  test(
    'expense rejects archived category',
    () async {
      const userId = 'user-1';
      const householdId = 'household-1';
      const accountId = 'account-1';
      const categoryId = 'category-1';

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
              name: 'Old Food',
              type: CategoryType.expense,
              iconKey: 'food',
              createdAt: now,
              updatedAt: now,
              createdBy: userId,
              updatedBy: userId,
            ),
          );

      await (database.update(database.categories)
            ..where(
              (category) => category.id.equals(categoryId),
            ))
          .write(
        CategoriesCompanion(
          isArchived: const drift.Value(true),
          updatedAt: drift.Value(now),
          updatedBy: const drift.Value(userId),
        ),
      );

      expect(
        () => transactionRepository.createExpense(
          id: 'expense-archived-category',
          householdId: householdId,
          sourceAccountId: accountId,
          categoryId: categoryId,
          amount: 100000,
          expenseType: ExpenseType.daily,
          transactionDate: now,
          userId: userId,
        ),
        throwsStateError,
      );
    },
  );
}
