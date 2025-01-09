import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ready_project/common/const/data.dart';
import 'package:ready_project/common/view/root_tab.dart';
import 'package:ready_project/user/view/login_screen.dart';

import '../const/colors.dart';
import '../layout/default_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final dio = Dio();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // deleteToken();
    checkToken();
  }

  void deleteToken() async{
    await storage.deleteAll();
  }

  Future<void> checkToken() async {
    String? token = await storage.read(key: JWT_TOKEN);
    print('1번 체크포인트');
    if (token != null) {

      final resp = await dio.post(
        'http://$ip/auth/validate',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
    print('2번 체크포인트');

      if (resp.statusCode == 200) {
        print('3번 체크포인트');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => RootTab()), (route) => false);
      } else {
        print('4번 체크포인트');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
      }
    }else{
      print('5번 체크포인트');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => LoginScreen()) , (route) => false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        backgroundColor: PRIMARY_COLOR,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'asset/img/logo/logo.png',
              //   width: MediaQuery.of(context).size.width / 2,
              // ),
              Text('Splash Screen'),
              SizedBox(
                height: 16.0,
              ),
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ));
  }
}
