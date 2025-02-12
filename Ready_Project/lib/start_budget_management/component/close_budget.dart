import 'package:flutter/material.dart';
import 'package:ready_project/start_budget_management/view/close_budget_detail.dart';

class CloseBudget extends StatelessWidget {
  const CloseBudget({super.key});

  @override
  Widget build(BuildContext context) {
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
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_)=> CloseBudgetDetail())
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
