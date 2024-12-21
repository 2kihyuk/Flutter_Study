import 'package:flutter/material.dart';

class BudgetMainTopSlider extends StatelessWidget {
  const BudgetMainTopSlider({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${DateTime.now().month.toString()}월',
            style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                fontSize: 24),
          ),

          SizedBox(
            height: 10.0,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '한 달 예산',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(),
                onPressed: () {},
                child: Text(
                  '수정',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),

          Text(
            '600,000원',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ),

          // Slider(
          //   value: value,
          //   onChanged: (){},
          // )
        ],
      ),
    );
  }
}
