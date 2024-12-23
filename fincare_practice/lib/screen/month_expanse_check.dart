// import 'package:fincare_practice/Component/savebutton.dart';
// import 'package:fincare_practice/budgetmodel.dart';
// import 'package:fincare_practice/screen/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart'; // 숫자 포맷팅을 위해
//
// class MonthExpanseCheck extends StatefulWidget {
//   const MonthExpanseCheck({super.key});
//
//   @override
//   State<MonthExpanseCheck> createState() => _MonthExpanseCheckState();
// }
//
// class _MonthExpanseCheckState extends State<MonthExpanseCheck> {
//   TextEditingController _budgetController = TextEditingController(); // 예산 입력을 위한 텍스트 컨트롤러
//   String Monthbudget = '0'; // 예산을 저장할 변수
//
//   // 숫자에 천 단위 구분 기호 추가하는 함수
//   String formatCurrency(String value) {
//     if (value.isEmpty) {
//       return '0';
//     }
//
//     final number = int.tryParse(value.replaceAll(',', ''));
//     if (number == null) {
//       return '0';
//     }
//
//     final formatter = NumberFormat('#,###');
//     return formatter.format(number);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Provider(
//       create: (context) => BudgetModel(),
//       child: Scaffold(
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(44.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '한 달 예산을 정해볼까요?',
//                   style: TextStyle(
//                     fontFamily: 'Pretendard',
//                     fontWeight: FontWeight.w700,
//                     fontSize: 24,
//                   ),
//                 ),
//                 SizedBox(height: 24.0),
//                 Text(
//                   '예산을 설정하고 지속적으로 관리해보세요.',
//                   style: TextStyle(
//                     fontFamily: 'Pretendard',
//                     fontWeight: FontWeight.w300,
//                     fontSize: 12,
//                   ),
//                 ),
//                 SizedBox(height: 120),
//
//                 // 예산 입력 부분
//                 Row(
//                   children: [
//                     Text(
//                       '한 달 예산',
//                       style: TextStyle(
//                         fontFamily: 'Pretendard',
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(width: 24),
//                     Expanded(
//                       child: TextField(
//                         controller: _budgetController,
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.right, // 텍스트를 오른쪽 정렬
//                         decoration: InputDecoration(
//                           hintText: '예산을 입력하세요',
//                           border: UnderlineInputBorder(),
//                           suffixText: '원', // "원" 텍스트 추가
//                         ),
//                         onChanged: (value) {
//                           setState(() {
//                             Monthbudget = formatCurrency(value); // 숫자 포맷팅
//                             _budgetController.text = Monthbudget; // 포맷된 값을 다시 텍스트 필드에 설정
//                             _budgetController.selection = TextSelection.fromPosition(TextPosition(offset: Monthbudget.length)); // 커서 위치 조정
//                           });
//                           Provider.of<BudgetModel>(context, listen: false).budget = Monthbudget;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 120),
//
//                 // 저장 버튼
//                 Savebutton(
//                   onSave: onSaveButtonPressed,
//                   content: '저장',
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void onSaveButtonPressed() {
//     print('저장완료성공');
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => (
//             HomeScreen()
//         ),
//       ),
//     );
//   }
// }


import 'package:fincare_practice/Component/savebutton.dart';
import 'package:fincare_practice/model/budgetmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart'; // 숫자 포맷팅을 위해

class MonthExpanseCheck extends StatefulWidget {
  const MonthExpanseCheck({super.key});

  @override
  State<MonthExpanseCheck> createState() => _MonthExpanseCheckState();
}

class _MonthExpanseCheckState extends State<MonthExpanseCheck> {
  TextEditingController _budgetController = TextEditingController(); // 예산 입력을 위한 텍스트 컨트롤러

  // 숫자에 천 단위 구분 기호 추가하는 함수
  String formatCurrency(double value) {
    // if (value.isEmpty) {
    //   return '0';
    // }
    //
    // final number = int.tryParse(value.replaceAll(',', ''));
    // if (number == null) {
    //   return '0';
    // }
    //
    // final formatter = NumberFormat('#,###');
    // return formatter.format(number);
    final formatter = NumberFormat('#,###');
    return formatter.format(value); // 숫자를 천 단위 구분 기호로 포맷팅
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(44.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '한 달 예산을 정해볼까요?',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 24.0),
              Text(
                '예산을 설정하고 지속적으로 관리해보세요.',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 120),

              // 예산 입력 부분
              Row(
                children: [
                  Text(
                    '한 달 예산',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: TextField(
                      controller: _budgetController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right, // 텍스트를 오른쪽 정렬
                      decoration: InputDecoration(
                        hintText: '예산을 입력하세요',
                        border: UnderlineInputBorder(),
                        suffixText: '원', // "원" 텍스트 추가
                      ),
                      onChanged: (value) {
                        setState(() {
                          // double formattedValue = formatCurrency(value); // 숫자 포맷팅
                          // _budgetController.text = formattedValue; // 포맷된 값을 다시 텍스트 필드에 설정
                          // _budgetController.selection = TextSelection.fromPosition(TextPosition(offset: formattedValue.length)); // 커서 위치 조정
                          // // 예산 값을 BudgetModel에 저장
                          // Provider.of<BudgetModel>(context, listen: false).budget = formattedValue;
                          double inputValue = double.tryParse(value.replaceAll(',', '')) ?? 0;
                          String formattedValue = formatCurrency(inputValue); // 숫자 포맷팅

                          _budgetController.text = formattedValue; // 포맷된 값을 다시 텍스트 필드에 설정
                          _budgetController.selection = TextSelection.fromPosition(TextPosition(offset: formattedValue.length)); // 커서 위치 조정

                          // 예산 값을 BudgetModel에 저장
                          Provider.of<BudgetModel>(context, listen: false).budget = inputValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 120),

              // 저장 버튼
              Savebutton(
                onSave: onSaveButtonPressed,
                content: '저장',
              )
            ],
          ),
        ),
      ),
    );
  }

  void onSaveButtonPressed() {
    print('저장완료성공');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }
}
