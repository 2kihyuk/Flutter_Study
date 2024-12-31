import 'package:fincare_practice/Component/savebutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../model/budgetmodel.dart';

class EndSpendScreen extends StatelessWidget {
  const EndSpendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              '오늘 지출 영수증',
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              '하루 예산 ${Provider.of<BudgetModel>(context, listen: false).dailyBudget.toInt()}원',
              style: TextStyle(
                fontFamily: 'Pretendard',
              ),
            ),
          ),//반영되지 않은 dailyBudget초기값을 넣어주어야함.
          SizedBox(height: 30.0,),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              '지출 ${NumberFormat('#,###').format(Provider.of<BudgetModel>(context, listen: false).dailySpend.toInt())}원',
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              '수입 ${NumberFormat('#,###').format(Provider.of<BudgetModel>(context, listen: false).dailyPlus.toInt())}원',
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text('${DateTime.now().day}일 오늘'),
          ),

          ///여기자리에는 오늘 하루동안 지출한 카테고리의 아이콘과 카테고리 이름, 지출금을 넣어주어야함.
          ///

          Divider(),
          Spacer(),
          Savebutton(
              onSave: onButtonPressed,
              content:
                  Provider.of<BudgetModel>(context, listen: false).dailyBudget -
                              Provider.of<BudgetModel>(context, listen: false)
                                  .dailySpend <
                          0
                      ? '차감하기'
                      : '분배하기'),
        ],
      )),
    );
  }

  onButtonPressed() {
    ///버튼 누르면 오늘 날짜에 있던 쉐어드 프레퍼런스에 존재하는 데이터를 모두 백엔드로 전송?  -> 달력 로직에서 백엔드에 있는 데이터 변경 감지시 그냥 바로 달력 에 반영?
    ///or 그냥 마감하고 달력에 반영하는 로직을 짜야하나?
  }
}
