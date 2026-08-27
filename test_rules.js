const {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} = require("@firebase/rules-unit-testing");
const fs = require("fs");

let testEnv;

async function runTests() {
  console.log("Initializing Firestore Rules Test Environment...");

  testEnv = await initializeTestEnvironment({
    projectId: "uangkuh-app",
    firestore: {
      rules: fs.readFileSync("firestore.rules", "utf8"),
      host: "127.0.0.1",
      port: 8080,
    },
  });

  const ownerA = testEnv.authenticatedContext("userA");
  const memberB = testEnv.authenticatedContext("userB");
  const attackerC = testEnv.authenticatedContext("userC");
  const unauth = testEnv.unauthenticatedContext();

  const dbA = ownerA.firestore();
  const dbB = memberB.firestore();
  const dbC = attackerC.firestore();
  const dbUnauth = unauth.firestore();

  console.log("Setting up initial state...");
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const adminDb = context.firestore();

    // Users
    await adminDb.doc("users/userA").set({ uid: "userA", email: "a@test.com", defaultHouseholdId: "houseA" });
    await adminDb.doc("users/userB").set({ uid: "userB", email: "b@test.com", defaultHouseholdId: "houseA" });
    await adminDb.doc("users/userC").set({ uid: "userC", email: "c@test.com", defaultHouseholdId: "houseC" });

    // Households
    await adminDb.doc("households/houseA").set({
      id: "houseA",
      name: "Household A",
      ownerId: "userA",
      inviteCode: "CODE_A_123"
    });

    // Invite code lookup
    await adminDb.doc("invite_codes/CODE_A_123").set({
      inviteCode: "CODE_A_123",
      householdId: "houseA",
      createdBy: "userA"
    });

    // Members in houseA
    await adminDb.doc("households/houseA/members/userA").set({
      id: "userA",
      userId: "userA",
      householdId: "houseA",
      role: "owner"
    });
    await adminDb.doc("households/houseA/members/userB").set({
      id: "userB",
      userId: "userB",
      householdId: "houseA",
      role: "member",
      inviteCode: "CODE_A_123"
    });

    // Subcollections in houseA
    await adminDb.doc("households/houseA/transactions/tx1").set({
      id: "tx1",
      householdId: "houseA",
      amount: 1000
    });
  });

  console.log("\n--- RUNNING ATTACK TESTS ---");

  // TEST A: User C changes users/userC.defaultHouseholdId = "houseA".
  // Expected: Still CANNOT read houseA subcollections
  console.log("TEST A: Attack via manipulating defaultHouseholdId...");
  await assertSucceeds(dbC.doc("users/userC").update({ defaultHouseholdId: "houseA" }));
  await assertFails(dbC.doc("households/houseA/transactions/tx1").get());
  console.log("TEST A PASSED (Manipulating defaultHouseholdId grants NO access)");

  // TEST B: User C tries to create membership in houseA without valid invite code
  console.log("TEST B: Arbitrary membership creation without invite code...");
  await assertFails(dbC.doc("households/houseA/members/userC").set({
    id: "userC",
    userId: "userC",
    householdId: "houseA",
    role: "member",
    inviteCode: "INVALID_CODE"
  }));
  console.log("TEST B PASSED (Arbitrary membership creation DENIED)");

  // TEST C: User C joins houseA with VALID invite code
  console.log("TEST C: Join with valid invite code...");
  await assertSucceeds(dbC.doc("households/houseA/members/userC").set({
    id: "userC",
    userId: "userC",
    householdId: "houseA",
    role: "member",
    inviteCode: "CODE_A_123"
  }));
  // Now C is a legitimate member, should be able to read transactions
  await assertSucceeds(dbC.doc("households/houseA/transactions/tx1").get());
  console.log("TEST C PASSED (Valid invite join ALLOWED and grants member access)");

  // Clean up C membership for subsequent tests
  await testEnv.withSecurityRulesDisabled(async (context) => {
    await context.firestore().doc("households/houseA/members/userC").delete();
  });

  // TEST D: User A tries to create membership for someone else (C != auth.uid)
  console.log("TEST D: Creating membership for another user UID when not owner...");
  await assertFails(dbB.doc("households/houseA/members/userC").set({
    id: "userC",
    userId: "userC",
    householdId: "houseA",
    role: "member",
    inviteCode: "CODE_A_123"
  }));
  console.log("TEST D PASSED (Creating membership with spoofed UID DENIED)");

  // TEST E: User C tries to read houseA transactions without membership
  console.log("TEST E: Cross-household transaction read...");
  await assertFails(dbC.doc("households/houseA/transactions/tx1").get());
  console.log("TEST E PASSED (Cross-household transaction read DENIED)");

  // TEST F: User C tries to read houseA members
  console.log("TEST F: Cross-household members read...");
  await assertFails(dbC.doc("households/houseA/members/userA").get());
  await assertFails(dbC.collection("households/houseA/members").get());
  console.log("TEST F PASSED (Cross-household members read DENIED)");

  // TEST G: Authenticated user tries to list all households
  console.log("TEST G: Global households list enumeration...");
  await assertFails(dbC.collection("households").get());
  console.log("TEST G PASSED (Global households enumeration DENIED)");

  // TEST H: Authenticated user tries to list invite_codes
  console.log("TEST H: Global invite_codes enumeration...");
  await assertFails(dbC.collection("invite_codes").get());
  console.log("TEST H PASSED (Invite codes list enumeration DENIED)");

  // TEST I: Reading specific invite code directly
  console.log("TEST I: Deterministic invite code get...");
  await assertSucceeds(dbC.doc("invite_codes/CODE_A_123").get());
  console.log("TEST I PASSED (Specific invite code get ALLOWED)");

  // TEST J: User C tries to read/modify userA document
  console.log("TEST J: Cross-user profile access...");
  await assertFails(dbC.doc("users/userA").get());
  await assertFails(dbC.doc("users/userA").update({ email: "hacked@test.com" }));
  console.log("TEST J PASSED (Cross-user read/write DENIED)");

  // TEST K: Owner A reads and writes houseA
  console.log("TEST K: Owner access...");
  await assertSucceeds(dbA.doc("households/houseA").get());
  await assertSucceeds(dbA.doc("households/houseA/transactions/tx1").get());
  await assertSucceeds(dbA.doc("households/houseA/transactions/tx2").set({
    id: "tx2",
    householdId: "houseA",
    amount: 500
  }));
  console.log("TEST K PASSED (Owner read/write ALLOWED)");

  // TEST L: Member B reads and writes houseA subcollections
  console.log("TEST L: Member access...");
  await assertSucceeds(dbB.doc("households/houseA/transactions/tx1").get());
  await assertSucceeds(dbB.doc("households/houseA/transactions/tx3").set({
    id: "tx3",
    householdId: "houseA",
    amount: 750
  }));
  console.log("TEST L PASSED (Member read/write ALLOWED)");

  // TEST M: Unauthenticated access
  console.log("TEST M: Unauthenticated access...");
  await assertFails(dbUnauth.doc("households/houseA").get());
  await assertFails(dbUnauth.doc("households/houseA/transactions/tx1").get());
  await assertFails(dbUnauth.doc("users/userA").get());
  await assertFails(dbUnauth.doc("invite_codes/CODE_A_123").get());
  console.log("TEST M PASSED (Unauthenticated requests DENIED)");

  // TEST N: Legacy top-level household_members collection
  console.log("TEST N: Legacy household_members collection access...");
  await assertFails(dbA.doc("household_members/randomId").get());
  await assertFails(dbA.collection("household_members").get());
  console.log("TEST N PASSED (Legacy household_members DENIED)");

  await testEnv.cleanup();
  console.log("\nALL 14 ATTACK & VALIDATION TESTS PASSED 100% SECURELY!");
}

runTests().catch((err) => {
  console.error("Test execution failed:", err);
  process.exit(1);
});
