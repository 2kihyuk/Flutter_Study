import 'package:calendar_schedule/const/color.dart';
import 'package:calendar_schedule/database/drift.dart';
import 'package:calendar_schedule/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:drift/drift.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized(); //플러터 프레임워크가 실행할 준비가 되어있는지  확인하는 절차.

  await initializeDateFormatting();

  final database = AppDatabase();

  GetIt.I.registerSingleton<AppDatabase>(database);



  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: HomeScreen(

      ),
    )
  );
}

