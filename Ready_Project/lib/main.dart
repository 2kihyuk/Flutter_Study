import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_project/common/view/root_tab.dart';
import 'package:ready_project/common/view/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async{
  // 한국어 로케일 초기화

  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

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