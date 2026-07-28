import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/account/data/accounts_table.dart';
import '../../features/account/domain/account_purpose.dart';
import '../../features/account/domain/account_type.dart';

import '../../features/category/data/categories_table.dart';
import '../../features/category/domain/category_type.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Accounts,
    Categories,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(
      p.join(dbFolder.path, 'uangkuh.sqlite'),
    );

    return NativeDatabase.createInBackground(file);
  });
}
