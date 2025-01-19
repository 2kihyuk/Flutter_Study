import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lv2_actual/common/const/colors.dart';
import 'package:lv2_actual/common/const/data.dart';
import 'package:lv2_actual/common/layout/default_layout.dart';
import 'package:lv2_actual/common/secure_storage/secure_storage.dart';
import 'package:lv2_actual/common/view/root_tab.dart';
import 'package:lv2_actual/user/view/login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
      // deleteToken();
    checkToken();
  }

  void deleteToken() async{
    final storage = ref.read(secureStorageProvider);
    await storage.deleteAll();
  }

  void checkToken() async {
    final storage = ref.read(secureStorageProvider);
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final dio =Dio();

    try{
      final resp = await dio.post(
        'http://$ip/auth/token',
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );

      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => RootTab()),
            (route) => false,
      );
    }catch(e){
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );
    }
    ///accessToken은 유효기간이 5분. refreshToken은 하루.
    ///유효기간이 지났다면,,,,
    ///서비스마다 회사마다 처리 방식이 다르지만, 가장 평범한 방법인 로그아웃을 시키는 방식으로 진행하기.
    ///다시 로그인 하면 토큰을 재발급할수있기때문에, 로그아웃을 시키는 방법을 사용.

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
              Image.asset(
                'asset/img/logo/logo.png',
                width: MediaQuery.of(context).size.width / 2,
              ),
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
