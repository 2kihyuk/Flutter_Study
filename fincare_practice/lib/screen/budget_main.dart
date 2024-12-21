import 'package:fincare_practice/Component/budget_main_top_slider.dart';
import 'package:fincare_practice/Component/end_spend.dart';
import 'package:fincare_practice/Component/safebox.dart';
import 'package:fincare_practice/Component/savebutton.dart';
import 'package:fincare_practice/Component/this_week_emotion.dart';
import 'package:fincare_practice/Component/today_expanse_decision.dart';
import 'package:flutter/material.dart';

class BudgetMain extends StatelessWidget {
  const BudgetMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            BudgetMainTopSlider(),
            SizedBox(height: 16.0,),
            TodayExpanseDecision(),
            SizedBox(height: 16.0,),
            EndSpend(),
            SizedBox(height: 16.0,),
            ThisWeekEmotion(),
            SizedBox(height: 16.0,),
            Safebox(),
          ],
        ),
      ),
    );
  }
}
