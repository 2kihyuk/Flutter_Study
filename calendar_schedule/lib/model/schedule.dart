import 'package:drift/drift.dart';

class ScheduleTable extends Table {
  ///식별 가능한 ID

  IntColumn get id => integer().autoIncrement()();

  ///시작 시간

  IntColumn get startTime => integer()();

  ///종료 시간

  IntColumn get endTime => integer()();

  ///일정 내용
  TextColumn get content => text()();

  ///날짜

  DateTimeColumn get date => dateTime()();

  ///카테고리
  TextColumn get color => text()();

  ///일정 생성날짜시간
  ///일정을 생성한 시간
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();

}
