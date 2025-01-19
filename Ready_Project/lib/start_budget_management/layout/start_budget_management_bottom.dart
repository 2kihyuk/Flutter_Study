import 'package:flutter/material.dart';
import 'package:ready_project/start_budget_management/component/safebox.dart';
import 'package:ready_project/start_budget_management/component/week_emotion.dart';

class StartBudgetManagementBottom extends StatelessWidget {
  const StartBudgetManagementBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(

      children:[
        WeekEmotion(),
        SizedBox(height: 40.0,),
        Safebox(),
      ]

    );
  }
}
