import 'package:drift/drift.dart';

import '../domain/category_type.dart';

class Categories extends Table {
  TextColumn get id => text()();

  TextColumn get householdId => text()();

  TextColumn get name => text()();

  TextColumn get type => textEnum<CategoryType>()();

  TextColumn get iconKey => text()();

  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get createdBy => text()();

  TextColumn get updatedBy => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
