import 'package:fincare_practice/model/budgetmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Safebox extends StatelessWidget {
  const Safebox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
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
              Icon(
                Icons.monetization_on,
                color: Colors.orange, // 아이콘 색상
              ),
              SizedBox(width: 15), // 아이콘과 텍스트 간 간격
              Text(
                '세이프박스',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Consumer<BudgetModel>(
            builder: (context,budgetModel,child){
              return Text(
                '${NumberFormat('#,###').format(budgetModel.safeboxBudget)}원',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
