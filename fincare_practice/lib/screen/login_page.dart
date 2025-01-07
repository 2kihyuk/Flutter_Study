import 'package:dio/dio.dart';
import 'package:fincare_practice/const/color.dart';
import 'package:fincare_practice/screen/home_screen.dart';
import 'package:fincare_practice/screen/month_expanse_check.dart';
import 'package:flutter/material.dart';

import '../Component/loginPage_component/custom_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String userName = '';
  String password = '';

  // void _onLoginPressed() async {  ///로그인 기능 구현
  //
  //   ///로그인 기능.
  //   final resp = await dio.post(
  //     'http://'
  //   );
  //   ///로그인시 토큰 값이 이미 존재한다면 , HomeScreen()으로 이동. 토큰 값이 존재하지않는(즉, 첫 로그인이라면) MonthExpanseCheck으로 이동
  //
  //   Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder:(context)=>
  //           MonthExpanseCheck()
  //           // HomeScreen()
  //       )
  //   );
  //   // 로그인 처리 로직을 여기에 추가
  //
  // }

  // void _onSignUpPressed() async{ ///회원가입 기능 구현
  //
  // }

  @override
  Widget build(BuildContext context) {

    final dio = Dio();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // 텍스트필드와 버튼들을 양쪽 끝에 맞춰줌
          children: [
            // 아이디 입력 폼
            CustomTextFormField(
              hintText: '이메일을 입력해주세요.',
              // errorText: '에러가 있습니다.',
              onChanged: (String value) {
                userName = value;
              },
            ),
            SizedBox(height: 20), // 폼 사이의 간격

            // 비밀번호 입력 폼
            CustomTextFormField(
              hintText: '비밀번호를 입력해주세요.',
              // errorText: '에러가 있습니다.',
              obscureText: true,
              onChanged: (String value) {
                password = value;
              },
            ),
            SizedBox(height: 40), // 폼과 버튼 사이의 간격

            // 로그인 버튼
            ElevatedButton(
              onPressed: ()async{
                // final resp = await dio.post(
                //   'http://auth/login?username=$userName&password=$password',
                // );
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder:(context)=>
                          MonthExpanseCheck()
                          // HomeScreen()
                      )
                  );


              },
              child: Text('로그인',style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Colors.blue
              ),
            ),
            SizedBox(height: 20), // 로그인 버튼과 회원가입 버튼 사이의 간격

            // 회원가입 버튼
            TextButton(
              onPressed: ()async{
                final resp = await dio.post(
                  'http://auth/register'
                );
              },
              child: Text(
                '회원가입하기',
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
