import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class StartBudgetManamentTop extends ConsumerWidget {
  final double monthBudget;

  const StartBudgetManamentTop({required this.monthBudget, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${DateTime.now().month.toString()}월',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '한 달 예산',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  '수정',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          Text(
            '${NumberFormat("#,###").format(monthBudget)}원',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
          ),

        ],
      ),
    );
  }
}
