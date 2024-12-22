import 'package:fincare_practice/model/budgetmodel.dart';
import 'package:fincare_practice/screen/decision_expanse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodayExpanseDecision extends StatefulWidget {
  const TodayExpanseDecision({super.key});

  @override
  State<TodayExpanseDecision> createState() => _TodayExpanseDecisionState();
}

class _TodayExpanseDecisionState extends State<TodayExpanseDecision> {
  TextEditingController _controller = TextEditingController();
  String labelText = "";

  @override
  void initState() {
    super.initState();
    _updateLabelText(); // 화면이 처음 로드될 때 하루 예산을 계산하여 labelText 설정
  }

  void _updateLabelText() {
    // BudgetModel을 사용하여 예산 값과 하루 예산을 가져옵니다.
    String budget = Provider.of<BudgetModel>(context, listen: false).budget;
    double dailyBudget =
        Provider.of<BudgetModel>(context, listen: false).dailyBudget;

    setState(() {
      labelText =
          "하루 예산은 ${dailyBudget.toStringAsFixed(0)}원"; // labelText에 하루 예산을 설정
    });
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

          // 하루 예산 텍스트
          Text(
            labelText, // labelText를 통해 하루 예산을 보여줍니다.
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),

          // 금액 입력 필드
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "금액을 입력하세요",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.6),
              ),
              border: UnderlineInputBorder(),
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
    _controller.text = "";

    if (updatedAmount != null) {
      setState(() {
        // updatedAmount에서 숫자 부분만 추출하여 계산
        double amountValue =
            double.tryParse(updatedAmount.replaceAll(RegExp(r'[^0-9.]'), '')) ??
                0;

        // 예산 값을 계산하기 전에, 기존 budget을 숫자로 변환합니다.
        double currentBudget = double.tryParse(
                Provider.of<BudgetModel>(context, listen: false)
                    .dailyBudget
                    .toString()
                    .replaceAll(',', '')) ??
            0;

        // 수입/지출에 따른 계산
        if (updatedAmount.startsWith("+")) {
          // 수입이면 예산 증가
          currentBudget += amountValue; // 수입이면 더하기
        } else if (updatedAmount.startsWith("-")) {
          // 지출이면 예산 감소
          currentBudget -= amountValue; // 지출이면 빼기
        }

        // 계산된 예산 값을 문자열로 다시 변환하여 Provider에 반영
        Provider.of<BudgetModel>(context, listen: false).dailyBudget =
            currentBudget;

        // 하루 예산 갱신
        _updateLabelText(); // labelText를 갱신합니다.
      });
    }
  }
}
