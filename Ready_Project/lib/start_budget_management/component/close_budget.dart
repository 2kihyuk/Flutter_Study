import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ready_project/start_budget_management/view/close_budget_detail.dart';

import '../../common/const/data.dart';
import '../../riverpod/budget_notifier.dart';

class CloseBudget extends ConsumerStatefulWidget {
  const CloseBudget({super.key});

  @override
  ConsumerState<CloseBudget> createState() => _CloseBudgetState();
}

class _CloseBudgetState extends ConsumerState<CloseBudget> {

  Future<void> getLoadData() async {
    final storage = FlutterSecureStorage();

    final token = await storage.read(key: JWT_TOKEN);
    await ref.watch(budgetProvider.notifier).getLoadData(token!);
  }

  @override
  Widget build(BuildContext context) {
    final budget = ref.watch(budgetProvider); // 상태 구독
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 아이콘과 텍스트 간 간격을 확보
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/money_icon.png',
                width: 25,
                height: 25,
              ),
              SizedBox(width: 16), // 아이콘과 텍스트 간 간격
              Text(
                '오늘 내역을 확인하세요',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard'
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '오늘 영수증 보기',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => CloseBudgetDetail())
                  );
                },
                icon: Icon(Icons.arrow_right_alt),
              )
            ],
          )
        ],
      ),
    );
  }
}
