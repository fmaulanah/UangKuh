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

```text
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

```text
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

## Phase 3 --- Local Feature UI --- IN PROGRESS

### 3A --- Local Session / Bootstrap --- COMPLETE / LOCKED
### 3B --- Account UI --- COMPLETE / LOCKED
### 3C --- Category UI --- COMPLETE / LOCKED

### 3D --- Transaction UI --- COMPLETE / LOCKED

```text
[✓] 3D.1 Transaction foundation
[✓] 3D.2 Create Expense
[✓] 3D.3 Create Income
[✓] 3D.4 Create Transfer
[✓] 3D.5 Validation & Edge Cases
[✓] 3D.6 Balance Integration
[✓] 3D.7 Final Validation
```

Validated behavior:

```text
Expense
- active source account selection
- expense category isolation
- DAILY / RECURRING expense type
- transaction date + optional description
- amount validation
- balance decreases correctly

Income
- active destination account selection
- income category isolation
- transaction date + optional description
- amount validation
- balance increases correctly

Transfer
- source + destination account selection
- same-account transfer rejected
- minimum two active accounts required
- source decreases and destination increases
- total household assets remain unchanged

Edge cases / integration
- archived accounts excluded
- archived categories excluded
- cancel/back creates no transaction
- double-save protection
- future transaction dates blocked
- mixed Expense + Income + Transfer balances correct
- reverse transfer preserves total assets
- persistence after restart validated
- flutter analyze PASS
- flutter test PASS
- flutter run PASS
```


### 3E --- Transaction History --- COMPLETE / LOCKED

```text
[✓] 3E.1 History Foundation / Provider Integration
[✓] 3E.2 Transaction List
[✓] 3E.3 Transaction Type Presentation
[✓] 3E.4 Date Grouping
[✓] 3E.5 Transaction Detail
[✓] 3E.6 Soft Delete
[✓] 3E.7 V1 Filters
[-] 3E.8 Balance Regression Validation — SKIPPED
[✓] 3E.9 Final Validation
```

Validated behavior:

```text
History foundation
- household-scoped history through repository/provider
- soft-deleted transactions excluded
- transactionDate DESC + createdAt DESC ordering
- history refreshes after transaction creation

Transaction list / presentation
- account and category names resolved for UI
- Expense shows category + source account + negative Rupiah amount
- Income shows category + destination account + positive Rupiah amount
- Transfer shows source → destination and neutral Rupiah amount
- Adjustment presentation supported
- optional descriptions supported
- transaction semantics use the app Material 3 ColorScheme/theme

Date grouping
- Today / Yesterday labels
- older transactions grouped by calendar date
- multiple transactions on the same date share one header
- sorting remains correct

Transaction detail
- History rows open read-only detail
- Expense detail includes DAILY / RECURRING
- Income detail shows account + category
- Transfer detail shows From / To
- optional description hidden when absent
- Detail → Back preserves History state

Soft delete
- isDeleted = true; no physical transaction deletion
- confirmation required
- cancel has no side effect
- deleted transactions disappear from active History
- account balance providers refresh after deletion
- Expense deletion restores balance
- Income deletion restores balance
- Transfer deletion restores both account balances
- deleted transactions stay hidden after restart
- updatedAt / updatedBy maintained

V1 filters
- All / Expense / Income / Transfer / Adjustment
- inclusive date-range filtering
- type + date range can be combined
- Reset restores All + All time
- filtered empty state handled
- grouping and sorting survive filtering
- Detail → Back preserves filters
- pull-to-refresh preserves filters

Final validation
- History load / refresh PASS
- transaction presentation PASS
- transaction detail PASS
- V1 filters PASS
- soft-delete smoke test PASS
- navigation regression PASS
- persistence after full restart PASS
- flutter analyze PASS
- flutter test PASS
```

Note: 3E.8 dedicated Balance Regression Validation was explicitly skipped.
Balance behavior had already been validated in 3D.6 and again during
3E.6 soft-delete testing. 3E.9 also included a final soft-delete balance
smoke test.

### 3F --- Recurring / Plan UI --- COMPLETE / LOCKED

```text
[✓] 3F.1 Recurring List Foundation
[✓] 3F.2 Create Recurring Expense
[✓] 3F.3 Edit Recurring Expense
[✓] 3F.4 Deactivate Recurring Expense
[✓] 3F.5 Monthly Payment Status
[✓] 3F.6 Pay Recurring Expense
[✓] 3F.7 Recurring → History Integration
[✓] 3F.8 Validation & Edge Cases
[✓] 3F.9 Final Validation
```

Validated behavior:

```text
Recurring list / Plan foundation
- household-scoped active recurring expenses
- recurring items resolve category and optional default account
- inactive/deactivated recurring expenses are excluded from active Plan
- local Drift data remains the operational source of truth

Create / edit recurring expense
- active EXPENSE category from the same household
- default amount > 0
- optional active default account from the same household
- optional due day must be 1..31
- default amount/account remain payment suggestions
- recurring expense can be edited without changing locked V1 schema

Deactivate recurring expense
- deactivate instead of hard delete
- historical payments and transactions are preserved
- deactivated item disappears from active Plan UI

Monthly payment status
- no pre-generated UNPAID rows
- active recurring + no payment row for period = UNPAID
- existing RecurringPayment for period = PAID
- status is derived from RecurringPayment
- duplicate payment for the same recurring/year/month is rejected

Pay recurring expense
- creates EXPENSE + RECURRING transaction
- creates linked RecurringPayment
- both are created atomically
- successful payment affects account balance exactly once
- duplicate payment cannot create a duplicate financial transaction

Recurring → History integration
- paid recurring appears in History as EXPENSE + RECURRING
- History and balance refresh after payment
- recurring transaction detail remains compatible with 3E
- soft-delete removes the transaction's active financial effect
- linked RecurringPayment marker is cleaned up when its recurring transaction is soft-deleted
- Plan period returns to UNPAID after that deletion
- recurring master remains active unless explicitly deactivated

Validation / regression
- household isolation preserved
- archived account/category validation preserved
- locked V1 schema unchanged
- financial ledger formula unchanged
- completed Account, Category, Transaction, and History behavior preserved
- local persistence survives restart
- flutter analyze PASS
- flutter test PASS
```

3F completes the local Recurring / Plan workflow while preserving the
locked recurring contract: monthly status is derived rather than
pre-generated, payment is atomic, and financial activity uses the same
transaction ledger as the rest of UangKuh.

### 3G --- Dashboard UI --- COMPLETE / LOCKED

```text
[✓] 3G.1 Dashboard Foundation
[✓] 3G.2 Total Balance Summary
[✓] 3G.3 Account Balance Overview
[✓] 3G.4 Monthly Income & Expense Summary
[✓] 3G.5 Recent Transactions
[✓] 3G.6 Recurring / Plan Summary
[✓] 3G.7 Refresh & Empty States
[✓] 3G.8 Validation & Regression
[✓] 3G.9 Final Validation
```

Validated behavior:

```text
Dashboard foundation
- Home Dashboard uses existing Material 3 theme and navigation shell
- Dashboard remains read-focused and reuses existing providers/repositories
- Quick Actions preserve Expense / Income / Transfer flows
- scrollable layout and pull-to-refresh validated

Total balance / accounts
- household total balance matches Account balances
- Expense decreases total; Income increases total
- Transfer preserves total household assets
- account overview reuses accountListProvider
- archived accounts are excluded
- financial mutations refresh Dashboard state correctly

Monthly summary
- current month is based on transactionDate
- Income includes INCOME
- Expense includes DAILY and RECURRING expenses
- Transfer and Adjustment are excluded
- Net = Income - Expense
- soft-deleted transactions are excluded
- previous-month transactions do not affect current-month summary

Recent transactions
- reuses transactionListProvider / History presentation foundation
- maximum five recent transactions
- ordering matches Transaction History
- soft-deleted transactions are excluded
- rows open existing transaction detail
- View all navigates to History

Recurring / Plan summary
- reuses recurringPlanProvider
- Paid / Unpaid matches Plan
- Pay changes Unpaid to Paid
- deleting linked recurring transaction restores Unpaid
- deactivated recurring expenses are excluded
- View plan navigates to Plan

Refresh / empty states
- pull-to-refresh refreshes Dashboard data sources
- empty Account / Transaction / Recurring states handled
- zero monthly summary renders normally
- loading and section-level error states handled

Regression / final validation
- Expense updates Total, Account, Monthly, and Recent
- Income updates Total, Account, Monthly, and Recent
- Transfer updates account distribution and Recent while preserving Total and Monthly
- Recurring payment updates Total, Account, Monthly, Recent, and Plan
- transaction soft-delete reverses Dashboard financial effects
- recurring transaction soft-delete also restores Plan to Unpaid
- persisted Dashboard data remains consistent after cold restart
- Account ↔ Dashboard values consistent
- History ↔ Dashboard Recent consistent
- Plan ↔ Dashboard recurring summary consistent
- locked V1 schema unchanged
- locked ledger formula unchanged
- completed 3A--3F behavior preserved
- flutter analyze PASS
- flutter test PASS
- flutter run / cold-start validation PASS
```

During 3G validation, the ExpenseFormScreen description
TextEditingController lifecycle was corrected so the controller is owned
and disposed by the screen State. Repeated Add Expense form rendering
works correctly without changing the locked transaction contract.

3G completes the local Dashboard as a read-focused aggregation layer
that reuses Account, Transaction History, and Recurring foundations.

# Current Checkpoint

```text
UANGKUH V1
================================================
BLUEPRINT / PRODUCT CONTRACT     🔒 LOCKED

PHASE 1 FOUNDATION               ✅ COMPLETE / FROZEN
PHASE 2 DATA + DOMAIN            ✅ COMPLETE / LOCKED
PHASE 3 LOCAL FEATURE UI         🚧 IN PROGRESS

3A Local Session / Bootstrap     ✅ COMPLETE / LOCKED
3B Account UI                    ✅ COMPLETE / LOCKED
3C Category UI                   ✅ COMPLETE / LOCKED
3D Transaction UI                ✅ COMPLETE / LOCKED
3E Transaction History           ✅ COMPLETE / LOCKED
3F Recurring / Plan UI           ✅ COMPLETE / LOCKED
3G Dashboard UI                  ✅ COMPLETE / LOCKED

Local Drift engine               ✅
Local session                    ✅
Account management UI            ✅
Category management UI           ✅
Expense creation                 ✅
Income creation                  ✅
Transfer creation                ✅
Financial ledger                 ✅
Balance calculation              ✅
Transaction validation           ✅
Transaction History UI           ✅
Recurring / Plan UI              ✅
Dashboard UI                     ✅

Adjustment UI                    ⏳
Firebase Authentication          ⏳
Firestore Sync                   ⏳
```

# Next Step

```text
NEXT = 3H --- Adjustment UI
```

Before starting 3H:
1. Validate Adjustment UI against the locked V1 transaction contract.
2. Reuse the completed Transaction repository and ledger behavior.
3. Adjustment targets destinationAccountId, uses no category, and accepts signed non-zero amounts.
4. Keep the existing balance formula unchanged.
5. Implement step-by-step without changing the locked V1 schema.
6. Run flutter analyze and relevant tests at final checkpoints.
7. Do not jump to Firebase outside the approved Phase 3 sequence.
8. Do not modify completed 3A--3G behavior unless a real blocker or regression is discovered.

# Consistency Rules for Future Chats

1. Treat this document as the latest UangKuh V1 source of truth.
2. Phase 1 is frozen and Phase 2 is locked unless a real blocker is discovered.
3. Phase 3 sections 3A through 3G are complete/locked unless a real blocker or regression is discovered.
4. Do not redesign locked rules because another approach seems newer or cleaner.
5. Do not add unapproved V1 features.
6. Work step-by-step and validate each checkpoint.
7. Never manually edit Drift *.g.dart.
8. Locked schema changes require migrations.
9. Avoid abstractions for hypothetical future needs.
10. Keep code clean and low-maintenance.
11. If a locked design must change, explain blocker, reason, smallest viable change, and impact, then wait for approval.
12. Preserve approved behavior if implementation details need adjustment.

# Resume Instruction

```text
PHASE 1                  COMPLETE / FROZEN
PHASE 2                  COMPLETE / LOCKED
PHASE 3                  IN PROGRESS

3A SESSION               COMPLETE / LOCKED
3B ACCOUNT UI            COMPLETE / LOCKED
3C CATEGORY UI           COMPLETE / LOCKED
3D TRANSACTION UI        COMPLETE / LOCKED
3E TRANSACTION HISTORY   COMPLETE / LOCKED
3F RECURRING / PLAN UI   COMPLETE / LOCKED
3G DASHBOARD UI          COMPLETE / LOCKED

NEXT = 3H ADJUSTMENT UI
```

Do not restart Phase 1, Phase 2, or Phase 3 sections 3A--3G.
Do not redesign the financial ledger or recurring payment contract.
Do not change the locked V1 schema without migration planning.
