import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ThisWeekEmotion extends StatelessWidget {
  const ThisWeekEmotion({super.key});

  @override
  Widget build(BuildContext context) {
    // 이번 주의 날짜 계산
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // 월요일
    List<DateTime> daysOfWeek =
        List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    // 이번 주 몇째주인지 계산 (현재 기준으로 몇 번째 주)
    int weekOfMonth = ((now.day - 1) / 7).floor() + 1;

    // 요일을 월화수목금토일로 표시
    List<String> dayNames = ['월', '화', '수', '목', '금', '토', '일'];

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 36.0, top: 18.0, bottom: 18.0, right: 18.0),
                child: Text(
                  '${DateFormat('MM월').format(now)} ${weekOfMonth}째주', // 몇째주
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              String formattedDate = DateFormat('d').format(daysOfWeek[index]);
              String dayOfWeek = dayNames[index]; // 월, 화, 수, ...
              Icon icon =
                  Icon(Icons.sentiment_very_dissatisfied, color: Colors.red);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dayOfWeek,
                  style: TextStyle(fontFamily: 'Pretendard',),), // 요일 표시
                  SizedBox(height: 10.0),
                  Text(formattedDate,
                  style: TextStyle(fontFamily: 'Pretendard',),), // 날짜 표시
                  SizedBox(height: 20.0),
                  icon, // 상태 아이콘 표시
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
