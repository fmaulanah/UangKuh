// import 'package:drift/native.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:uangkuh/core/database/app_database.dart';
// import 'package:uangkuh/features/auth/data/local_session_bootstrap.dart';
// import 'package:uangkuh/features/household/domain/household_role.dart';

// void main() {
//   late AppDatabase database;
//   late LocalSessionBootstrap bootstrap;

//   setUp(() {
//     database = AppDatabase.forTesting(
//       NativeDatabase.memory(),
//     );

//     bootstrap = LocalSessionBootstrap(database);
//   });

//   tearDown(() async {
//     await database.close();
//   });

//   test(
//     'bootstraps local session idempotently',
//     () async {
//       final firstSession = await bootstrap.bootstrap();

//       expect(firstSession.userId, 'local-user');
//       expect(firstSession.householdId, 'local-household');
//       expect(firstSession.email, 'local@uangkuh.app');
//       expect(firstSession.displayName, 'Local User');

//       final users = await database.select(database.users).get();
//       final households = await database.select(database.households).get();
//       final members = await database.select(database.householdMembers).get();
//       final categories = await database.select(database.categories).get();

//       expect(users, hasLength(1));
//       expect(households, hasLength(1));
//       expect(members, hasLength(1));
//       expect(categories, hasLength(13));

//       expect(members.single.userId, firstSession.userId);
//       expect(
//         members.single.householdId,
//         firstSession.householdId,
//       );
//       expect(members.single.role, HouseholdRole.owner);

//       final secondSession = await bootstrap.bootstrap();

//       expect(secondSession.userId, firstSession.userId);
//       expect(
//         secondSession.householdId,
//         firstSession.householdId,
//       );

//       expect(
//         await database.select(database.users).get(),
//         hasLength(1),
//       );

//       expect(
//         await database.select(database.households).get(),
//         hasLength(1),
//       );

//       expect(
//         await database.select(database.householdMembers).get(),
//         hasLength(1),
//       );

//       expect(
//         await database.select(database.categories).get(),
//         hasLength(13),
//       );
//     },
//   );
// }
