import 'package:flutter/material.dart';

class TodayBudgetBanner extends StatelessWidget {
  final DateTime selectedDay;


  const TodayBudgetBanner({required this.selectedDay,  super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일',
              style: TextStyle(
                color: Colors.white,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
