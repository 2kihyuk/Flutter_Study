import 'package:fincare_practice/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // intl 패키지
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // 위젯 트리 초기화

  // 로케일 데이터 초기화
  await initializeDateFormatting('ko_KR', null); // 'ko_KR'을 사용하여 한국어 로케일 초기화

  runApp(
    MaterialApp(
      home:HomeScreen(),
    )
  );
}

