import 'package:fincare_practice/screen/end_spend_screen.dart';
import 'package:flutter/material.dart';


class EndSpend extends StatefulWidget {
  const EndSpend({super.key});

  @override
  State<EndSpend> createState() => _EndSpendState();
}

class _EndSpendState extends State<EndSpend> {
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
              Icon(
                Icons.monetization_on,
                color: Colors.orange, // 아이콘 색상
              ),
              SizedBox(width: 8), // 아이콘과 텍스트 간 간격
              Text(
                '오늘 지출을 마감하세요',
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
                '지출 마감하기',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: onEndButtonPressed,
                icon: Icon(Icons.arrow_right_alt),
              )
            ],
          )
        ],
      ),
    );
  }

  void onEndButtonPressed(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context){
        return EndSpendScreen();
      })
    );
  }
}
