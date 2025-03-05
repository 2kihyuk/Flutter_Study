import 'package:flutter/material.dart';
import 'package:ready_project/start_budget_management/component/close_budget.dart';
import 'package:ready_project/start_budget_management/component/incomeorexpense.dart';



class StartBudgetManagementMiddle extends StatelessWidget {
  const StartBudgetManagementMiddle({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Incomeorexpense(),
        CloseBudget(),
      ],
    );
  }
}

