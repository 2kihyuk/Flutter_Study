import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/budgetmodel.dart';

class EndSpendScreen extends StatelessWidget {
  const EndSpendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
            children: [
              Text('오늘 지출 영수증'),
              Text('하루 예산 ${Provider.of<BudgetModel>(context,listen: false).dailyBudget.toInt()}원'), //반영되지 않은 dailyBudget초기값을 넣어주어야함.
              Text('지출 ${Provider.of<BudgetModel>(context,listen: false).dailySpend.toInt()}원'),
              SizedBox(height: 20.0,),
              Text('${DateTime.now().day}일 오늘'),
              ///여기자리에는 오늘 하루동안 지출한 카테고리의 아이콘과 카테고리 이름, 지출금을 넣어주어야함.
              Divider(),

            ],
          )
      ),
    );
  }
}