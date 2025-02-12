import 'package:flutter/material.dart';
import 'package:ready_project/common/layout/default_layout.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'AI 서비스',
      child: Column(
        children: [
          // ElevatedButton들을 그리드 형태로 배치
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('AI를 활용한 자산 분석하기'),
                  SizedBox(height: 10.0,),
                  OutlinedButton(
                    onPressed: (){},
                    child: Text('저번 달 소비패턴 분석하기'),
                  ),
                  OutlinedButton(
                    onPressed: (){},
                    child: Text('다음 달엔 어떻게 아끼지?'),
                  ),
                  OutlinedButton(
                    onPressed: (){},
                    child: Text('어디에 가장 많이 소비해?'),
                  ),
                  OutlinedButton(
                    onPressed: (){},
                    child: Text('이번 달은 어떻게 하지?'),
                  ),
                ],
              ),
            ),
          ),
        Divider(),
          // 나머지 화면 내용
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircularPercent(70),
                  _buildCircularPercent(40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCircularPercent(int percentage) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 8,
          color: Colors.blueAccent,
        ),
      ),
      child: Center(
        child: Text(
          '$percentage%',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
