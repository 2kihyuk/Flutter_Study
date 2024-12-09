import 'package:flutter/material.dart';
import 'package:navigation/screen/home_screen.dart';
import 'package:navigation/screen/route_one_screen.dart';
import 'package:navigation/screen/route_three_screen.dart';
import 'package:navigation/screen/route_two_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      ///key는 route이름
      ///value는 builder함수. 뭘 반환하냐? 이동하고 싶은 라우트를 반환

      '/': (BuildContext context) => HomeScreen(),
      '/one': (BuildContext context) => RouteOneScreen(
            number: 999,
          ),
      '/two' : (BuildContext context) => RouteTwoScreen(),
      '/three' : (BuildContext context) => RouteThreeScreen(),
    },
  ));
}
