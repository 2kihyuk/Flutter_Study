import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:new_project/user/view/login_screen.dart';
import 'package:new_project/common/view/root_tab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: 'jtcaxatytt');
  await NaverMapSdk.instance.initialize(
      clientId: 'jtcaxatytt',
      onAuthFailed: (ex) {
        print("********* 네이버맵 인증오류 : $ex *********");
      });
  runApp(
    MaterialApp(
      home: HomeScreen(),
    )
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}
