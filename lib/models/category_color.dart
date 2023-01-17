import 'package:drift/drift.dart';

class CategoryColors extends Table {
  // PK
  IntColumn get id => integer().autoIncrement()();

  // color hex code
  TextColumn get hexCode => text()();
}
