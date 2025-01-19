import 'package:flutter/material.dart';
import 'package:ready_project/common/layout/default_layout.dart';

class EditMonthBudget extends StatelessWidget {
  const EditMonthBudget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'EditMonthBudgetPage',
      child: Center(child: Text('EditMonthBudgetPage'),),
    );
  }
}
