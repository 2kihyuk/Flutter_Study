// import 'package:fincare_practice/budgetmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class BudgetMainTopSlider extends StatelessWidget {
//   const BudgetMainTopSlider({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.now();
//
//     return Container(
//       padding: EdgeInsets.all(10),
//       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       width: double.infinity,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '${DateTime.now().month.toString()}월',
//             style: TextStyle(
//                 fontFamily: 'Pretendard',
//                 fontWeight: FontWeight.w700,
//                 fontSize: 24),
//           ),
//
//           SizedBox(
//             height: 10.0,
//           ),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '한 달 예산',
//                 style: TextStyle(
//                   fontFamily: 'Pretendard',
//                   fontSize: 16,
//                   color: Colors.grey,
//                 ),
//               ),
//               TextButton(
//                 style: TextButton.styleFrom(),
//                 onPressed: () {},
//                 child: Text(
//                   '수정',
//                   style: TextStyle(
//                     fontFamily: 'Pretendard',
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           Text(
//             '${Provider.of<BudgetModel>(context).budget}원',
//             style: TextStyle(
//               fontFamily: 'Pretendard',
//               fontWeight: FontWeight.w700,
//               fontSize: 30,
//             ),
//           ),
//
//           // Slider(
//           //   value: value,
//           //   onChanged: (){},
//           // )
//         ],
//       ),
//     );
//   }
// }
import 'package:fincare_practice/model/budgetmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BudgetMainTopSlider extends StatefulWidget {
  const BudgetMainTopSlider({super.key});

  @override
  State<BudgetMainTopSlider> createState() => _BudgetMainTopSliderState();
}

class _BudgetMainTopSliderState extends State<BudgetMainTopSlider> {
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
                onPressed: onMonthExpanseChangePressed,
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

          // 예산 값을 실시간으로 표시 Consumer를 사용해서, Provider.of<BudgetModel>(context).budget.toString()를 Consumer<BudgetModel>위젯으로 감싸고, builder를 통해 수정.
          Consumer<BudgetModel>(

            builder: (context, budgetModel, child) {
              String formattedBudget = NumberFormat('#,###').format(budgetModel.budget);
              return Text(
                '${formattedBudget}원',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                ),
              );
            },
            // child: Text(
            //   '${Provider.of<BudgetModel>(context).budget.toString()}원',
            //   style: TextStyle(
            //     fontFamily: 'Pretendard',
            //     fontWeight: FontWeight.w700,
            //     fontSize: 30,
            //   ),
            // ),
          ),
          // Slider(value: value, onChanged: onChanged)
        ],
      ),
    );
  }

  onMonthExpanseChangePressed() {
    print('수정 버튼 클릭! / 한달 총 예산을 수정하러 고고');
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) =>
              Container(

              )
      )
    );
  }
}
