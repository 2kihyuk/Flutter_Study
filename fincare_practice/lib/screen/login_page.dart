import 'package:fincare_practice/screen/home_screen.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onLoginPressed() {  ///로그인 기능 구현
    String username = _usernameController.text;
    String password = _passwordController.text;
    ///회원가입 카카오 나 자체 ?

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder:(context)=>
            HomeScreen()
        )
    );
    // 로그인 처리 로직을 여기에 추가
    print('Username: $username, Password: $password');
  }

  void _onSignUpPressed() { ///회원가입 기능 구현
    // 회원가입 화면으로 이동하는 로직을 여기에 추가
    ///KAKAO LOGIN, AUTHENTICATION API  // JWT 이용한 회원가입 기능 구현 예정.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // 텍스트필드와 버튼들을 양쪽 끝에 맞춰줌
          children: [
            // 아이디 입력 폼
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: '아이디',
                border: OutlineInputBorder(),
                hintText: '아이디를 입력하세요',
              ),
            ),
            SizedBox(height: 20), // 폼 사이의 간격

            // 비밀번호 입력 폼
            TextField(
              controller: _passwordController,
              obscureText: true, // 비밀번호는 가려서 입력
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
                hintText: '비밀번호를 입력하세요',
              ),
            ),
            SizedBox(height: 40), // 폼과 버튼 사이의 간격

            // 로그인 버튼
            ElevatedButton(
              onPressed: _onLoginPressed,
              child: Text('로그인'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20), // 로그인 버튼과 회원가입 버튼 사이의 간격

            // 회원가입 버튼
            TextButton(
              onPressed: _onSignUpPressed,
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
