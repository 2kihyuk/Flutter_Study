import 'package:fincare_practice/Component/savebutton.dart';
import 'package:fincare_practice/screen/login_page.dart';
import 'package:flutter/material.dart';

class AuthenticationStart extends StatefulWidget {
  const AuthenticationStart({super.key});

  @override
  State<AuthenticationStart> createState() => _AuthenticationStartState();
}

class _AuthenticationStartState extends State<AuthenticationStart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 위쪽 텍스트들
          Expanded(
            flex: 1, // 텍스트와 상단 영역을 차지
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 위아래 중앙 배치
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '지출 계엄령, 계산은 여자가',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'FINCARE',
                  style: TextStyle(
                    fontSize: 60,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 화면 하단에 버튼을 배치
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Savebutton(
              content: '시작하기',
              onSave: onStartButtonPressed,
            ),

          ),
          // Expanded(
          //   child:
          //   Image.asset(name),
          // ),
        ],
      ),
    );
  }

  void onStartButtonPressed(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => (
          LoginPage()
        ),
      ),
    );
  }
}
