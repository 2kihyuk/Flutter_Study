import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ready_project/common/layout/default_layout.dart';

import '../../common/const/data.dart';

class EditMonthBudget extends StatefulWidget {
  const EditMonthBudget({super.key});

  @override
  State<EditMonthBudget> createState() => _EditMonthBudgetState();
}

class _EditMonthBudgetState extends State<EditMonthBudget> {

  double MonthTotalBudget = 0;
  double MonthFixedExpense = 0;

  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController MonthTotalBudgetController = TextEditingController();
    TextEditingController MonthFixedExpenseController = TextEditingController();

    return DefaultLayout(
      title: '예산 수정 하기',
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Text('현재(수정 전) 한 달 총 고정 수입액은 ${MonthTotalBudget}원 입니다.'),
            Text('현재(수정 전) 한 달 고정 지출액은 ${MonthFixedExpense}원 입니다.'),
            Divider(),
            Text('수정 할 내역'),
            TextFormField(
              controller: MonthTotalBudgetController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: "한 달 총 고정 수입을 입력해주세요.",
                labelStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
              onChanged: (value) {

              },
            ),
            TextFormField(
              controller: MonthFixedExpenseController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: "한 달 고정 지출액을 입력해주세요..",
                labelStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
              onChanged: (value) {

              },
            ),

            ElevatedButton(
              onPressed: (){

              },
              child: Text('수정하기'),
            ),

          ],
        ),
      ),);
  }

  Future<void> getInitialData() async {
    final dio = Dio();
    final storage = FlutterSecureStorage();

    final token = await storage.read(key: JWT_TOKEN);
    print("EditMonthBudget : getBudgetData : ${token}");

    try {
      final response = await dio.get(
        'http://$ip/user/budget',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        print("EditMonthBudget : getBudgetData : ${response.data}");
        MonthTotalBudget = response.data['monthTotalIncome'];
        MonthFixedExpense = response.data['monthFixedExpense'];
      } else {
        print('API 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: editMonthBudget - getBudgetData -  $e');
    }
  }
}
