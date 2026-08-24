# UangKuh V1 --- Project Reference (Updated Checkpoint)

> Canonical continuation reference.

## Architecture (LOCKED)

Firestore (Source of Truth) ↓ SQLite (Offline Cache) ↓ Riverpod ↓ UI

Shared entities: - Users - Households - Household Members - Categories -
Accounts (next) - Transactions (next)

SQLite is cache only.

## Rules

-   Step-by-step development.
-   Don't redesign approved architecture without a blocker.
-   Fix bugs with the smallest change.
-   Repository → Bootstrap → UI.

## Phase Status

### Phase 1

Complete

### Phase 2

Complete

### Phase 3

Complete

### Phase 4

Complete - Firebase Auth - Register - Login - Auto Login - Session
Bootstrap

### Phase 5 (Current)

Completed: - Firestore Users - Firestore Households - Firestore
Household Members - Firestore Categories - Category provisioning -
Bootstrap sync User - Bootstrap sync Household - Bootstrap sync
Members - Bootstrap sync Categories - Register race-condition fix

Current flow:

Firestore ↓ Bootstrap ↓ SQLite ↓ Riverpod ↓ UI

## Next

1.  Logout
2.  Account Firestore Sync
3.  Transaction Firestore Sync
4.  Recurring Firestore Sync
5.  Multi-device validation
