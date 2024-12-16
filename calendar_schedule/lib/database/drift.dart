import 'package:drift/drift.dart';
import 'package:calendar_schedule/model/schedule.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

///@는 Annotation . Annotation밑에 있는 값에다가 기능을 추가해주는 역할을 한다.
///AppDatabase기반의 코드를 만드는데 도움을 준다.

part 'drift.g.dart';



@DriftDatabase(
  tables: [ScheduleTable]
)
class AppDatabase extends _$AppDatabase{
  AppDatabase() : super(_openConnection());

  Future <List<ScheduleTableData>> getSchedules() => select(scheduleTable).get();

  Future<int> createSchedule(ScheduleTableCompanion data) => into(scheduleTable).insert(data);



  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection(){
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // if(Platform.isAndroid){
    //   await applyWorkaroundToOpenSqlite30nOldAndroidVersions();
    // }
    final cachebase = await getTemporaryDirectory();

    sqlite3.tempDirectory = cachebase.path;

    return NativeDatabase.createInBackground(file);
  },);
}



