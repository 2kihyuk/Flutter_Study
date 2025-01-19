import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ready_project/common/const/data.dart';
import 'package:ready_project/common/layout/default_layout.dart';
import 'package:ready_project/start_budget_management/layout/start_budget_management_bottom.dart';
import 'package:ready_project/start_budget_management/layout/start_budget_management_middle.dart';
import 'package:ready_project/start_budget_management/layout/start_budget_manament_top.dart';

import '../../riverpod/budget_notifier.dart';


///kihyuk5566@naver.com 1234
///
///

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

  // double month_budget = 0.0;
  // // 초기값을 0.0으로 설정
  // double daily_budget = 0.0;
  // // 초기값을 0.0으로 설정
  // String birthDate = "";
  //
  // String name = "";

  @override
  Widget build(BuildContext context) {
    final budget = ref.watch(budgetProvider); // 상태 구독
    return Scaffold(
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


