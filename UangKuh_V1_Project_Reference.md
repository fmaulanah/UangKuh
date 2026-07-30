# UangKuh V1 — Project Reference

> Canonical reference for continuing UangKuh in other ChatGPT chats.
>
> **V1 rule:** Everything marked LOCKED is the agreed contract. Do not redesign, add nice-to-have features, or change architecture unless there is a real technical blocker. Any necessary change must be explained and approved first.

## Product Goal — LOCKED

UangKuh is an Android personal-finance app replacing the existing monthly Google Sheets workflow.

- App becomes the main interface; no need to check Sheets.
- Shared household finance for user + wife.
- Offline-first; sync when internet returns.
- Track balances per account.
- Daily expenses, recurring expenses, income, transfers, adjustments.
- Savings/investments are assets/accounts, not expenses.
- No monthly sheet duplication; month comes from transaction date.
- Portfolio-quality architecture without unnecessary V1 complexity.
- Target: Android only.

## V1 Scope — LOCKED

Included: Authentication, shared Household, Account management, Expense, Income, Transfer, Adjustment, Categories, Recurring Expenses, Transaction History, Dashboard, offline local operation, Firebase sync.

Out of V1: Budgeting, debt management, Google Sheets integration/export, advanced charts, notifications, dark mode, biometrics, receipt scanner, AI, multi-currency, iOS, Web.

Installments such as car payments are ordinary recurring expenses in V1.

## Tech Stack — LOCKED

- Flutter / Dart
- Android
- Riverpod
- GoRouter
- Drift / SQLite
- Firebase Authentication
- Cloud Firestore
- Feature-first + Repository pattern
- Offline-first

Environment initialized with Flutter 3.27.2, Dart 3.6.1, Android SDK 35, Java 21.

Pinned Drift tooling:
- drift: 2.24.0
- drift_dev: 2.24.0
- build_runner: ^2.4.14
- analyzer: 7.3.0

Do not casually upgrade Flutter/Dart/tooling during V1.

## Project Structure — LOCKED

```text
lib/
├── app/
│   ├── app.dart
│   ├── app_shell.dart
│   ├── router.dart
│   └── theme.dart
├── core/
│   ├── database/
│   ├── firebase/
│   ├── sync/
│   └── utils/
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── account/
│   ├── category/
│   ├── transaction/
│   ├── recurring/
│   ├── household/
│   └── profile/
├── shared/widgets/
└── main.dart
```

Each feature:
```text
feature/
├── data/
├── domain/
├── presentation/
└── providers/
```

## Navigation — LOCKED

Material 3 + GoRouter `StatefulShellRoute.indexedStack`.

```text
Home | History | Plan | Me
```

Routes:
- `/` Dashboard
- `/history` Transaction History
- `/plan` Recurring Plan
- `/me` Profile

Add Transaction FAB is planned but only implemented when its real destination exists.

# Domain — LOCKED

## Account V1

```text
id UUID
householdId UUID
name TEXT
type ENUM
purpose ENUM
initialBalance INTEGER
isArchived BOOLEAN
createdAt DATETIME
updatedAt DATETIME
createdBy USER ID
updatedBy USER ID
```

Types: BANK, E_WALLET, CASH, SAVING, INVESTMENT.

Dart:
```dart
enum AccountType { bank, eWallet, cash, saving, investment }
```

Purposes: SPENDING, SAVING, INVESTMENT.

Dart:
```dart
enum AccountPurpose { spending, saving, investment }
```

Balance:
```text
Initial Balance + Income - Expense ± Transfer ± Adjustment = Current Balance
```

`currentBalance` is not a freely editable stored value. Archive old accounts instead of hard-delete.

## Transaction V1

```text
id UUID
householdId UUID
type ENUM
expenseType ENUM / NULL
amount INTEGER
sourceAccountId UUID / NULL
destinationAccountId UUID / NULL
categoryId UUID / NULL
description TEXT / NULL
transactionDate DATETIME
createdBy USER ID
updatedBy USER ID
createdAt DATETIME
updatedAt DATETIME
syncStatus ENUM
isDeleted BOOLEAN
```

Types: EXPENSE, INCOME, TRANSFER, ADJUSTMENT.
Expense types: DAILY, RECURRING.
Sync: PENDING, SYNCED.

Rules:
- EXPENSE: source required, destination null, category required, expenseType required, amount > 0.
- INCOME: source null, destination required, category required, expenseType null, amount > 0.
- TRANSFER: source + destination required, source != destination, no category, amount > 0.
- ADJUSTMENT: exactly one account side; no category/expenseType; signed amount allowed and != 0.

Normal Expense/Income/Transfer amounts are positive integers. Store Rupiah as integer, never formatted strings or floating point.

`transactionDate` is the financial date. Delete uses soft-delete (`isDeleted = true`, `syncStatus = PENDING`) for offline sync.

## Category V1

```text
id UUID
householdId UUID
name TEXT
type ENUM
iconKey TEXT
isDefault BOOLEAN
isArchived BOOLEAN
createdAt DATETIME
updatedAt DATETIME
createdBy USER ID
updatedBy USER ID
```

Types: EXPENSE, INCOME. Transfer/Adjustment have no category.

Default Expense categories: Food & Drink, Transport, Household, Bills, Shopping, Health, Entertainment, Personal, Other.

Default Income categories: Salary, Freelance, Bonus, Other Income.

Categories belong to Household. Custom categories allowed. Archive used categories. Seed defaults when Household is created, not during initial schema construction.

## Recurring Expense V1

```text
id UUID
householdId UUID
name TEXT
defaultAmount INTEGER
categoryId UUID
defaultAccountId UUID / NULL
dueDay INTEGER / NULL
isActive BOOLEAN
createdAt DATETIME
updatedAt DATETIME
createdBy USER ID
updatedBy USER ID
```

`defaultAmount` and `defaultAccountId` are defaults only. Actual monthly payment may differ. `dueDay` may be null. No notifications. Deactivate instead of deleting.

## Recurring Payment V1

```text
id UUID
householdId UUID
recurringExpenseId UUID
periodYear INTEGER
periodMonth INTEGER
status ENUM
transactionId UUID / NULL
createdAt DATETIME
updatedAt DATETIME
createdBy USER ID
updatedBy USER ID
```

Status: UNPAID, PAID.

Constraint:
```text
UNIQUE(recurringExpenseId, periodYear, periodMonth)
```

Payment creates/links a Transaction with `type=EXPENSE`, `expenseType=RECURRING`.

Do not pre-generate every monthly payment row. Active recurring + no row for selected month means UNPAID.

## User V1

```text
id Firebase Auth UID
email TEXT
displayName TEXT
createdAt DATETIME
updatedAt DATETIME
```

Firebase UID is User ID.

## Household V1

```text
id UUID
name TEXT
inviteCode TEXT UNIQUE
createdBy USER ID
createdAt DATETIME
updatedAt DATETIME
```

Finance data belongs to Household, not directly to User.

## Household Member V1

```text
id UUID
householdId UUID
userId Firebase Auth UID
role OWNER / MEMBER
joinedAt DATETIME
```

Both roles can view/add/edit/delete finance data in V1. `UNIQUE(userId)` because V1 is one User = one Household.

Onboarding:
```text
Register → Create User → Create Household OR Join Household by invite code
```

Creating a Household also creates default categories.

# Offline-First — LOCKED

```text
User action
→ write SQLite locally
→ UI works offline
→ syncStatus=PENDING
→ internet available
→ sync Firestore
→ syncStatus=SYNCED
```

Drift/SQLite is local operational DB. Firestore is shared cloud sync layer. Firebase sync comes later; do not jump ahead during local database work.

# Theme V1

Material 3 light theme.

```text
Primary        #4F46E5
Success        #16A34A
Danger         #DC2626
Warning        #F59E0B
Background     #F8FAFC
Surface        #FFFFFF
Text Primary   #0F172A
Text Secondary #64748B
```

No custom font package yet. No dark mode V1.

# Implementation Progress

## Phase 1 — COMPLETE / FROZEN

- Environment check ✓
- Flutter project ✓
- Git + GitHub ✓
- Android baseline ✓
- Riverpod + GoRouter ✓
- Feature-first structure ✓
- Theme V1 ✓
- GoRouter ✓
- Main App Shell ✓

## Phase 2 — Domain + Drift — IN PROGRESS

```text
[✓] Drift dependencies
[✓] Database foundation
[✓] Account model + table
[ ] Category model + table   ← CURRENT
[ ] Transaction model + table
[ ] Recurring tables
[ ] Database generation/schema review
[ ] Repository foundation
[ ] CRUD + balance validation
```

Database foundation:
- `lib/core/database/app_database.dart`
- file: `uangkuh.sqlite`
- `LazyDatabase`
- `getApplicationDocumentsDirectory()`
- `NativeDatabase.createInBackground(...)`
- schemaVersion remains `1` while initial V1 schema is being constructed.

Account implemented:
```text
lib/features/account/domain/account_type.dart
lib/features/account/domain/account_purpose.dart
lib/features/account/data/accounts_table.dart
```

`Accounts` is registered in AppDatabase. Never edit generated `*.g.dart`.

# Current Next Step

Implement Category V1 Drift schema.

Create:
```text
lib/features/category/
├── data/
├── domain/
├── presentation/
└── providers/
```

`category_type.dart`:
```dart
enum CategoryType { expense, income }
```

`categories_table.dart` fields:
```text
id
householdId
name
type
iconKey
isDefault
isArchived
createdAt
updatedAt
createdBy
updatedBy
```

Register `Categories` in AppDatabase. Import `CategoryType` into `app_database.dart` for generated Drift enum visibility.

Run:
```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
```

Expected: `No issues found!`

Do not seed default categories yet.

# Consistency Rules for Future Chats

1. Treat this file as the V1 source of truth.
2. Do not change architecture because another approach is newer/fashionable.
3. Do not add unapproved V1 features.
4. Work step-by-step and validate each checkpoint.
5. Do not jump to Firebase before local Drift/domain work is complete.
6. Never manually edit generated `*.g.dart`.
7. Avoid abstractions for hypothetical future needs.
8. Keep code clean and low-maintenance.
9. A genuine blocker requiring a locked-design change must be explained with the blocker, reason, smallest change, and impact, then wait for approval.
10. Preserve approved product behavior even if implementation details need adjustment.

## Snapshot

```text
UANGKUH V1
================================
DESIGN / BLUEPRINT       🔒 LOCKED
PHASE 1 FOUNDATION       ✅ COMPLETE
PHASE 2 DRIFT            🚧 IN PROGRESS

Account                  ✅
Category                 🚧 CURRENT
Transaction              ⏳ NEXT
Recurring                ⏳
Repository               ⏳
Balance Validation       ⏳
Firebase                 ⏳ LATER
Full Feature UI          ⏳ LATER
```

Continue from Category V1 unless a newer reference records later completed progress.
