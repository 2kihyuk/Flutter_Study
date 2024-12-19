import 'package:fincare_practice/screen/decision_expanse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayExpanseDecision extends StatefulWidget {
  const TodayExpanseDecision({super.key});

  @override
  State<TodayExpanseDecision> createState() => _TodayExpanseDecisionState();
}

class _TodayExpanseDecisionState extends State<TodayExpanseDecision> {
  double MonthExpanse = 600000;
  double dailyBudget = 0;  // 하루 예산을 실시간으로 업데이트
  String labelText = "";
  TextEditingController _controller = TextEditingController();
  int selectedExpanseIndex = 0; // 0: 수입, 1: 지출

  @override
  void initState() {
    super.initState();
    _updateLabelText();
  }

  // 하루 예산 계산
  void _updateLabelText() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    int daysInMonth = lastDayOfMonth.day;

    dailyBudget = MonthExpanse / daysInMonth;

    labelText = "하루 예산은 ${dailyBudget.toStringAsFixed(0)}원";
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d일 EEEE', 'ko_KR').format(now);

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

          // 금액 입력 필드
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                onPressed: onTapSave,
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

  void onTapSave() async {
    String amount = _controller.text;

    // 페이지 이동 및 데이터를 받음
    final updatedAmount = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DecisionExpanse(
          initialAmount: amount,
        ),
      ),
    );

    if (updatedAmount != null) {
      setState(() {
        // updatedAmount에서 숫자 부분만 추출하여 계산
        double amountValue = double.tryParse(updatedAmount.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

        // 수입/지출에 따른 계산
        if (updatedAmount.startsWith("+")) {
          dailyBudget += amountValue; // 수입이면 더하기
        } else if (updatedAmount.startsWith("-")) {
          dailyBudget -= amountValue; // 지출이면 빼기
        }
        labelText = "하루 예산은 ${dailyBudget.toStringAsFixed(0)}원";
        // 하루 예산 갱신
        // _updateLabelText();
      });
    }
  }



}
