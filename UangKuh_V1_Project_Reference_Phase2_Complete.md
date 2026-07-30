# UangKuh V1 --- Project Reference

> Canonical continuation reference for UangKuh V1.
>
> **V1 rule:** Everything marked LOCKED is an agreed contract. Do not
> redesign it, add nice-to-have features, or change architecture unless
> there is a real technical blocker. Explain any required change and get
> approval first.

# Product Goal --- LOCKED

UangKuh is an Android personal-finance app replacing the existing
monthly Google Sheets workflow.

-   App becomes the main interface; no need to check Sheets.
-   Shared household finance for user + wife.
-   Offline-first; local operation works without internet and syncs
    later.
-   Track balances per account.
-   Daily expenses, recurring expenses, income, transfers, and
    adjustments.
-   Savings/investments are assets/accounts, not expenses.
-   No monthly sheet duplication; period comes from transaction dates.
-   Portfolio-quality architecture without unnecessary V1 complexity.
-   Android only for V1.

# V1 Scope --- LOCKED

Included: Authentication, shared Household, Account management, Expense,
Income, Transfer, Adjustment, Categories, Recurring Expenses,
Transaction History, Dashboard, offline local operation, Firebase sync.

Out of V1: Budgeting, debt management, Google Sheets integration/export,
advanced charts, notifications, dark mode, biometrics, receipt scanner,
AI, multi-currency, iOS, Web.

Installments such as car payments are ordinary recurring expenses in V1.

# Tech Stack --- LOCKED

-   Flutter / Dart
-   Android
-   Riverpod
-   GoRouter
-   Drift / SQLite
-   Firebase Authentication
-   Cloud Firestore
-   Feature-first + Repository pattern
-   Offline-first

Environment baseline: - Flutter 3.27.2 - Dart 3.6.1 - Android SDK 35 -
Java 21

Pinned Drift tooling: - drift: 2.24.0 - drift_dev: 2.24.0 -
build_runner: \^2.4.14 - analyzer: 7.3.0

Do not casually upgrade Flutter/Dart/tooling during V1.

Android note: AGP was upgraded from 8.1.0 to 8.2.1 to resolve the Java
21 `JdkImageTransform/jlink` build issue. Android run/navigation passed
afterward.

# Architecture --- LOCKED

``` text
Presentation
    ↓
Provider
    ↓
Repository contract
    ↓
Drift repository
    ↓
AppDatabase / Drift
    ↓
SQLite
```

Presentation must not access Drift tables directly.

Feature-first structure remains:

``` text
feature/
├── data/
├── domain/
├── presentation/
└── providers/
```

# Navigation --- LOCKED

Material 3 + GoRouter `StatefulShellRoute.indexedStack`.

``` text
Home | History | Plan | Me
```

Routes: - `/` Dashboard - `/history` Transaction History - `/plan`
Recurring Plan - `/me` Profile

Add Transaction FAB is only implemented when its real destination
exists.

# Domain Rules --- LOCKED

## Account

Types:

``` dart
enum AccountType { bank, eWallet, cash, saving, investment }
```

Purposes:

``` dart
enum AccountPurpose { spending, saving, investment }
```

`currentBalance` is derived from the ledger, not stored as a freely
editable value. Accounts use archive instead of hard delete.

## Category

``` dart
enum CategoryType { expense, income }
```

Transfer and Adjustment do not use categories. Custom categories are
allowed. Used categories are archived instead of deleted. Default
categories are seeded when Household is created, not during schema
construction.

## Transaction

Types: EXPENSE, INCOME, TRANSFER, ADJUSTMENT. Expense types: DAILY,
RECURRING. Sync: PENDING, SYNCED.

Rules:

``` text
EXPENSE
source required
destination null
category = EXPENSE
expenseType required
amount > 0

INCOME
source null
destination required
category = INCOME
expenseType null
amount > 0

TRANSFER
source + destination required
source != destination
category null
expenseType null
amount > 0

ADJUSTMENT
adjusted account = destinationAccountId
category null
expenseType null
signed amount allowed
amount != 0
```

Rupiah amounts are integers, never floating point/formatted strings.

Transaction delete is soft-delete with `isDeleted = true`.

## Balance Formula --- LOCKED

``` text
initialBalance
+ Income
- Expense
- Transfer out
+ Transfer in
+ signed Adjustment
────────────────────
= currentBalance
```

Only `isDeleted = false` transactions affect balance.

Transfer must not change total household assets.

`getTotalBalance(householdId)` totals active/non-archived accounts.
Archived accounts remain available for historical balance calculation.

No insufficient-balance rule was added in Phase 2.

## Recurring

Recurring master: - defaultAmount \> 0 - active Expense category from
same household - optional active default account from same household -
dueDay null or 1..31 - default amount/account are suggestions only -
deactivate instead of delete

Recurring Payment:

``` text
UNIQUE(recurringExpenseId, periodYear, periodMonth)
```

Do not pre-generate UNPAID rows.

``` text
active recurring + no payment row for period = UNPAID
```

Paying recurring atomically creates:

``` text
Transaction: EXPENSE + RECURRING
+
RecurringPayment: PAID + transactionId
```

Both inserts commit or rollback together.

Duplicate payment for the same recurring/year/month is rejected before a
duplicate financial transaction is created.

## Household Isolation

Finance data belongs to Household.

Cross-household Account, Category, and Recurring relationships are
rejected by repository validation even when individual foreign keys are
valid.

V1: one User belongs to one Household. OWNER and MEMBER both have
finance CRUD access.

# Database Schema V1 --- LOCKED

Tables:

``` text
Users
Households
HouseholdMembers
Accounts
Categories
Transactions
RecurringExpenses
RecurringPayments
```

Important constraints: - `Households.inviteCode` unique -
`HouseholdMembers.userId` unique -
`RecurringPayments(recurringExpenseId, periodYear, periodMonth)` unique

Lifecycle:

``` text
Account            → archive
Category           → archive
Recurring Expense  → deactivate
Transaction        → soft delete
```

Finance/history relationships do not use cascade delete.

Schema V1 is locked. Future schema changes require migration planning.
Never manually edit generated `*.g.dart`.

# Repository Foundation --- COMPLETE

Implemented: - AppDatabase Riverpod provider - Account repository +
Drift implementation + provider - Category repository + Drift
implementation + provider - Transaction repository + Drift
implementation + provider - Recurring repository + Drift
implementation + provider

Account repository includes CRUD/archive, `getCurrentBalance`, and
`getTotalBalance`.

Transaction repository supports Expense, Income, Transfer, Adjustment,
and lookup.

Recurring repository supports active list, lookup, create, deactivate,
and atomic payment.

Repository validation covers invalid amounts, category types, archived
entities, household ownership, same-account transfer, and duplicate
recurring periods.

Do not add abstractions just to remove small duplicated helpers unless a
real need appears.

# Offline-First --- LOCKED

``` text
User action
→ SQLite local write
→ UI works offline
→ syncStatus = PENDING
→ internet available
→ Firestore sync
→ syncStatus = SYNCED
```

Drift/SQLite is the local operational database. Firestore is the shared
cloud sync layer.

**Firebase synchronization has NOT been implemented yet.**

# Testing Foundation --- COMPLETE

`AppDatabase` now supports injected test execution:

``` dart
AppDatabase.forTesting(
  NativeDatabase.memory(),
)
```

Production remains file-backed.

Automated Phase 2 coverage:

``` text
Database smoke test
Initial account balance
Expense / Income balance
Transfer source/destination
Transfer preserves total assets
Positive / negative adjustment
Soft-delete ignored by balance
Soft-deleted row remains stored
Recurring master
Recurring payment
RecurringPayment ↔ Transaction link
Recurring expense affects balance

Validation:
- invalid Expense/Income/Transfer amounts
- zero Adjustment
- same-account transfer
- wrong category type
- cross-household account
- archived account
- archived category
- duplicate recurring payment
- no duplicate financial transaction
- balance unchanged after duplicate attempt
```

Final Phase 2 validation:

``` text
flutter test     → PASS
flutter analyze  → No issues found
flutter run      → PASS
navigation       → PASS
```

# Phase Progress

## Phase 1 --- Foundation --- COMPLETE / FROZEN

``` text
[✓] Environment
[✓] Flutter Android project
[✓] Git + GitHub
[✓] Riverpod + GoRouter
[✓] Feature-first structure
[✓] Material 3 theme
[✓] Stateful app shell
[✓] Home / History / Plan / Me navigation
```

## Phase 2 --- Data & Domain Foundation --- COMPLETE / LOCKED

``` text
[✓] Drift tooling + database foundation
[✓] Account / Category / Transaction / Recurring domain
[✓] User / Household / HouseholdMember
[✓] Relationships + constraints
[✓] Schema V1 lock
[✓] Repository foundation
[✓] Account + Category CRUD
[✓] Expense + Income
[✓] Transfer + Adjustment
[✓] Balance calculation
[✓] Recurring operations
[✓] Domain validation
[✓] In-memory test infrastructure
[✓] Automated tests
[✓] Full test/analyze/run validation
```

# Current Checkpoint

``` text
UANGKUH V1
========================================
BLUEPRINT / PRODUCT CONTRACT   🔒 LOCKED
PHASE 1 FOUNDATION             ✅ COMPLETE
PHASE 2 DATA + DOMAIN          ✅ COMPLETE / LOCKED

Local Drift engine             ✅
Financial ledger               ✅
Balance calculation            ✅
Recurring engine               ✅
Domain validation              ✅
Automated tests                ✅

Firebase                       ⏳ NOT IMPLEMENTED
Real feature UI                ⏳ NOT IMPLEMENTED
```

# Next Step

**Phase 3 has NOT started.**

Before coding Phase 3: 1. Define the Phase 3 roadmap. 2. Check it
against the locked V1 blueprint. 3. Approve the roadmap. 4. Implement
step-by-step. 5. Do not add unrelated improvements.

Do not automatically assume Firebase must be the first Phase 3 task.
Decide the sequence explicitly first.

# Consistency Rules for Future Chats

1.  Treat this document as the latest UangKuh V1 source of truth.
2.  Phase 1 and Phase 2 are complete/frozen unless a real blocker is
    discovered.
3.  Do not redesign locked rules because another approach seems newer or
    cleaner.
4.  Do not add unapproved V1 features.
5.  Work step-by-step and validate each checkpoint.
6.  Never manually edit Drift `*.g.dart`.
7.  Locked schema changes require migrations.
8.  Avoid abstractions for hypothetical future needs.
9.  Keep code clean and low-maintenance.
10. Do not jump into Firebase/UI implementation before the Phase 3
    roadmap is approved.
11. If a locked design must change, explain blocker, reason, smallest
    viable change, and impact, then wait for approval.
12. Preserve approved behavior if implementation details need
    adjustment.

# Resume Instruction

If this file is supplied in another chat, resume from:

``` text
PHASE 2 COMPLETE / LOCKED
NEXT = DEFINE AND APPROVE PHASE 3 ROADMAP
```

Do not restart Phase 2. Older UangKuh reference files are superseded by
this checkpoint.
