import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:ready_project/common/const/colors.dart';
import 'package:ready_project/riverpod/budget_notifier.dart';
import 'package:ready_project/start_budget_management/view/decision_incomeorexpense.dart';

import '../../common/const/data.dart';
//
// class Incomeorexpense extends ConsumerWidget {
//   const Incomeorexpense({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final budget = ref.read(budgetProvider);
//
//     TextEditingController _controller = TextEditingController();
//     // Get current date and day in Korean
//     DateTime now = DateTime.now();
//
//     // Days of the week in Korean
//     List<String> daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];
//
//     // Format the date in a custom way: 'd일 EEEE'
//     String formattedDate = '${now.day}일 ${daysOfWeek[now.weekday - 1]}요일';
//
//     return Container(
//       padding: EdgeInsets.all(20),
//       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       decoration: BoxDecoration(
//         color: PRIMARY_COLOR,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 5,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 날짜 텍스트
//           Text(
//             formattedDate,
//             style: TextStyle(
//               fontWeight: FontWeight.w700,
//               fontSize: 16,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 10),
//
//           // 하루 예산 텍스트
//           Text(
//               '오늘 하루 예산은 ${NumberFormat("#,###").format(budget.daily_budget)}원',
//             // labelText를 통해 하루 예산을 보여줍니다.
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 10),
//
//           // 금액 입력 필드
//           TextField(
//             onChanged: (value) {
//               String withoutComma = value.replaceAll(RegExp(r','), '');
//
//               // 숫자가 있으면 파싱하고 쉼표 추가
//               if (withoutComma.isNotEmpty) {
//                 double parsedValue = double.tryParse(withoutComma) ?? 0.0;
//                 String formattedValue =
//                 NumberFormat('#,###').format(parsedValue);
//
//                 // TextController에 다시 형식을 적용한 값을 설정
//                 _controller.value = _controller.value.copyWith(
//                   text: formattedValue,
//                   selection:
//                   TextSelection.collapsed(offset: formattedValue.length),
//                 );
//               }
//             },
//             controller: _controller,
//             decoration: InputDecoration(
//               hintText: "금액을 입력하세요",
//               floatingLabelBehavior: FloatingLabelBehavior.auto,
//               labelStyle: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black.withOpacity(0.6),
//               ),
//               border: UnderlineInputBorder(),
//               contentPadding:
//               EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   Icons.add,
//                   color: Colors.blue,
//                 ),
//                 onPressed: () async {
//                   String amount = _controller.text;
//                   final updatedAmount = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (_) =>
//                             DecisionIncomeorexpense(initialAmount: amount)),
//                   );
//                   if (updatedAmount != null) {
//                     double amountValue = double.tryParse(
//                         updatedAmount.replaceAll(RegExp(r'[^0-9.]'), '')) ??
//                         0;
//                     bool isIncome =
//                     updatedAmount.startsWith('+'); // 수입인지 지출인지 판별
//
//                     // `budgetProvider`를 통해 상태 업데이트
//                     ref
//                         .read(budgetProvider.notifier)
//                         .updateDailyBudget(amountValue, isIncome);
//                   }
//
//                   _controller.clear();
//                   //버튼 눌러서 다음 화면으로 넘어가는 로직
//                 },
//               ),
//             ),
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// }
//
//

class Incomeorexpense extends ConsumerStatefulWidget {
  const Incomeorexpense({super.key});

  @override
  _IncomeorexpenseState createState() => _IncomeorexpenseState();
}

class _IncomeorexpenseState extends ConsumerState<Incomeorexpense> {
  // String? token;  // 토큰을 저장할 변수
  //
  // // 토큰을 비동기적으로 읽어오는 함수
  // Future<void> getToken() async {
  //   final storage = FlutterSecureStorage();
  //   token = await storage.read(key: JWT_TOKEN);
  //   print("IncomeOrExpenses : getToken함수 : $token");
  //
  //   // 토큰을 읽은 후 getDailyBudgetAnytime 호출
  //   if (token != null) {
  //     await ref.read(budgetProvider.notifier).getDailyBudgetAnytime(token!);
  //   } else {
  //     print("토큰을 가져오는 데 실패했습니다.");
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getToken();  // IncomeorExpense 위젯이 나타날 때마다 호출
  // }

  @override
  Widget build(BuildContext context) {
    final budget = ref.watch(budgetProvider); // 상태 구독

    TextEditingController _controller = TextEditingController();
    // Get current date and day in Korean
    DateTime now = DateTime.now();

    // Days of the week in Korean
    List<String> daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];

    // Format the date in a custom way: 'd일 EEEE'
    String formattedDate = '${now.day}일 ${daysOfWeek[now.weekday - 1]}요일';

    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: PRIMARY_COLOR,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 날짜 텍스트
          Text(
            formattedDate,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),

          // 하루 예산 텍스트
          Text(
            '오늘 하루 예산은 ${NumberFormat("#,###").format(budget.daily_budget)}원',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),

          // 금액 입력 필드
          TextField(
            onChanged: (value) {
              String withoutComma = value.replaceAll(RegExp(r','), '');

              // 숫자가 있으면 파싱하고 쉼표 추가
              if (withoutComma.isNotEmpty) {
                double parsedValue = double.tryParse(withoutComma) ?? 0.0;
                String formattedValue =
                NumberFormat('#,###').format(parsedValue);

                // TextController에 다시 형식을 적용한 값을 설정
                _controller.value = _controller.value.copyWith(
                  text: formattedValue,
                  selection:
                  TextSelection.collapsed(offset: formattedValue.length),
                );
              }
            },
            controller: _controller,
            decoration: InputDecoration(
              hintText: "금액을 입력하세요",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.6),
              ),
              border: UnderlineInputBorder(),
              contentPadding:
              EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
                onPressed: () async {
                  String amount = _controller.text;
                  final updatedAmount = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            DecisionIncomeorexpense(initialAmount: amount)),
                  );
                  if (updatedAmount != null) {
                    double amountValue = double.tryParse(
                        updatedAmount.replaceAll(RegExp(r'[^0-9.]'), '')) ??
                        0;
                    // bool isIncome =
                    // updatedAmount.startsWith('+'); // 수입인지 지출인지 판별

                    // // `budgetProvider`를 통해 상태 업데이트
                    // ref
                    //     .read(budgetProvider.notifier)
                    //     .updateDailyBudget(amountValue, isIncome);
                  }

                  _controller.clear();
                  //버튼 눌러서 다음 화면으로 넘어가는 로직
                },
              ),
            ),
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}


