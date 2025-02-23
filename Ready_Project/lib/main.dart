import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:ready_project/common/view/root_tab.dart';
import 'package:ready_project/common/view/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

import 'Notification/Flutter_Notification.dart';

// Future<void> initializeTimezone() async {
//   // flutter_timezone 패키지를 사용하여 로컬 타임존을 가져옵니다.
//   String currentTimeZone = await FlutterTimezone.getLocalTimezone();
//
//   tz_data.initializeTimeZones();
//   tz.setLocalLocation(tz.getLocation(currentTimeZone));
// }

// void setSeoulTimeZone() {
//   // 타임존 데이터를 초기화
//   tz_data.initializeTimeZones();
//
//   // 'Asia/Seoul' 타임존을 로컬 타임존으로 설정
//   tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
// }


void setSeoulTimeZone() {
  // 타임존 데이터를 초기화
  tz_data.initializeTimeZones();

  // 'Asia/Seoul' 타임존을 로컬 타임존으로 설정
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
}


void main() async{
  // 한국어 로케일 초기화

  WidgetsFlutterBinding.ensureInitialized();

  // 한국어 로케일 초기화
  await initializeDateFormatting();

  // 타임존 설정
  setSeoulTimeZone();
  testTimeZone();

  // 타임존이 제대로 설정되었는지 확인
  print("Local Time Zone after setup: ${tz.local}");

  runApp(
    ProviderScope(child: _App()),
  );
}

class _App extends StatelessWidget {
  const _App({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('ko', 'KR'), // 한국어로 설정
      theme: ThemeData(
        fontFamily: 'Pretendard'
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }

}

void testTimeZone() {
  // Asia/Seoul로 설정된 시간 출력
  var currentTime = tz.TZDateTime.now(tz.local);
  print("Asia/Seoul Time: $currentTime");
}