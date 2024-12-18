import 'package:fincare_practice/screen/decision_expanse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayExpanseDecision extends StatefulWidget {
  const TodayExpanseDecision({super.key});

  @override
  State<TodayExpanseDecision> createState() => _TodayExpanseDecisionState();
}

class _TodayExpanseDecisionState extends State<TodayExpanseDecision> {
  final int todayExpanse = 10000;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d일 EEEE', 'ko_KR').format(now);

    ///한국어로 변환

    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 날짜 텍스트
          Text(
            formattedDate,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),

          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: '금액을 입력해주세요',
              labelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.6),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue, // 테두리 색을 원하는 색으로 변경
                  width: 2.0, // 테두리 두께
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
                onPressed: () {
                  ///페이지 이동
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return DecisionExpanse();
                    }),
                  );
                },
              ),
            ),
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Pretendard',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
