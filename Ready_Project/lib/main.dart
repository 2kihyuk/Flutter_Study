import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_project/common/view/root_tab.dart';




void main()  {
  // 한국어 로케일 초기화


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
      ),
      debugShowCheckedModeBanner: false,
      home: RootTab(),
    );
  }
}