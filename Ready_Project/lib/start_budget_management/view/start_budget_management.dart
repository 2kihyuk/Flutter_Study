import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ready_project/common/const/data.dart';
import 'package:ready_project/common/layout/default_layout.dart';
import 'package:ready_project/start_budget_management/layout/start_budget_management_bottom.dart';
import 'package:ready_project/start_budget_management/layout/start_budget_management_middle.dart';
import 'package:ready_project/start_budget_management/layout/start_budget_manament_top.dart';

import '../../Notification/Flutter_Notification.dart';
import '../../riverpod/budget_notifier.dart';

class StartBudgetManagement extends ConsumerStatefulWidget {
  const StartBudgetManagement({super.key});

  @override
  ConsumerState<StartBudgetManagement> createState() =>
      _StartBudgetManagementState();
}

class _StartBudgetManagementState extends ConsumerState<StartBudgetManagement> {

  @override
  void initState() {
    super.initState();
    _getUserData();

  }

  Future<void> _getUserData() async {
    final token = await FlutterSecureStorage().read(key: JWT_TOKEN);
    if (token != null) {
      ref.read(budgetProvider.notifier).getLoadData(token); // 상태 업데이트
    }
  }

  @override
  Widget build(BuildContext context) {
    final budget = ref.watch(budgetProvider); // 상태 구독

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children:[
            StartBudgetManamentTop(monthBudget: budget.month_budget),
            StartBudgetManagementMiddle(),
            SizedBox(height: 24.0,),
            StartBudgetManagementBottom(),
          ],

        ),
      ),
    );
  }
}


