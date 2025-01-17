import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// class WeekEmotion extends StatefulWidget {
//   const WeekEmotion({super.key});
//
//   @override
//   State<WeekEmotion> createState() => _WeekEmotionState();
// }
//
// class _WeekEmotionState extends State<WeekEmotion> {
//   @override
//   Widget build(BuildContext context) {
//
//     final days[] =
//
//     DateTime now = DateTime.now();
//     String month = DateFormat('MM월').format(now);
//     int weekOfMonth = ((now.day - 1) / 7).floor() + 1;
//     String formatDate = '$month ${weekOfMonth}째주';
//
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 16.0, left: 24.0),
//           child: Text(formatDate),
//         ),
//         Row(
//           children: List.generate(
//             length,
//             generator,
//           ),
//         ),
//       ],
//     );
//   }
// }

class WeekEmotion extends StatefulWidget {
  const WeekEmotion({super.key});

  @override
  State<WeekEmotion> createState() => _ThisWeekEmotionState();
}

class _ThisWeekEmotionState extends State<WeekEmotion> {
  late DateTime startOfWeek;
  late List<DateTime> daysOfWeek;
  late int weekOfMonth;

  @override
  void initState() {
    super.initState();
    _calculateWeek(DateTime.now());
  }

  // 주 계산하는 함수
  void _calculateWeek(DateTime date) {
    startOfWeek = date.subtract(Duration(days: date.weekday - 1)); // 월요일
    daysOfWeek = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
    weekOfMonth = ((date.day - 1) / 7).floor() + 1;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 주 변경 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _calculateWeek(startOfWeek.subtract(Duration(days: 7)));
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Text(
                  '${DateFormat('MM월').format(startOfWeek)} ${weekOfMonth}째주',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(() {
                    _calculateWeek(startOfWeek.add(Duration(days: 7)));
                  });
                },
              ),
            ],
          ),

          // 날짜 표시
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              String formattedDate = DateFormat('d').format(daysOfWeek[index]);
              String dayOfWeek = ['월', '화', '수', '목', '금', '토', '일'][index];


              Icon icon = Icon(Icons.sentiment_very_dissatisfied, color: Colors.red);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayOfWeek,
                    style: TextStyle(fontFamily: 'Pretendard'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    formattedDate,
                    style: TextStyle(fontFamily: 'Pretendard'),
                  ),
                  SizedBox(height: 15.0),
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