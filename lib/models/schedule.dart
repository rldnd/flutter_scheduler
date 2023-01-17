import 'package:drift/drift.dart';

class Schedules extends Table {
  // PK
  IntColumn get id => integer().autoIncrement()();

  // 내용
  TextColumn get content => text()();

  // 일정 날짜
  DateTimeColumn get date => dateTime()();

  // 시작 시간
  IntColumn get startTime => integer()();

  // 끝 시간
  IntColumn get endTime => integer()();

  IntColumn get colorId => integer()();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
