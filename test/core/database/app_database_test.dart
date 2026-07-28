import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uangkuh/core/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(
      NativeDatabase.memory(),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('database can open and query using in-memory SQLite', () async {
    final result = await database.select(database.accounts).get();

    expect(result, isEmpty);
  });
}
