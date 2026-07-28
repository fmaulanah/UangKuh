import 'package:drift/drift.dart';

class Households extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get inviteCode => text().unique()();

  TextColumn get createdBy => text()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
