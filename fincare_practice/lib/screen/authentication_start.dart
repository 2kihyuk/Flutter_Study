import 'package:fincare_practice/Component/savebutton.dart';
import 'package:flutter/material.dart';

class AuthenticationStart extends StatelessWidget {
  const AuthenticationStart({super.key});

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
                Text('지출 계엄령 ,FinCare'),
                SizedBox(height: 20.0),
                Text(
                  'FINCARE',
                  style: TextStyle(
                    fontSize: 60,
                  ),
                ),
              ],
            ),
          ),

          // 화면 하단에 버튼을 배치
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Savebutton(content: '회원가입하기'),
          ),
        ],
      ),
    );
  }
}
