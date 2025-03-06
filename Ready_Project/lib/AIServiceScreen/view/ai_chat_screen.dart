import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ready_project/AIServiceScreen/view/pie_chart_sample3.dart';
import 'package:ready_project/common/layout/default_layout.dart';

import '../../common/const/data.dart';
import '../Model/TotalModel.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  double monthly_expense_total = 0.0;
  double monthly_income_total = 0.0;
  Map<String, double> categoryExpenses = {};

  double last_month_expense_total = 0.0;
  double last_month_income_total = 0.0;
  Map<String, double> lastMonthCategoryExpenses = {};
  bool isThisMonth = true;

  int touchedIndex = -1;
  int selectedIndex = 1;

  @override
  void didUpdateWidget(AiChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // widget이 변경될 때마다 API 호출
    getCumulativeData();
    getLastMonthCumulativeData();
  }

  @override
  void initState() {
    super.initState();
    getCumulativeData();
    getLastMonthCumulativeData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'AI 서비스',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI 분석 버튼들
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'AI를 활용한 자산 분석하기',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text('저번 달 소비패턴 분석하기'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text('다음 달엔 어떻게 아끼지?'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text('어디에 가장 많이 소비해?'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text('이번 달은 어떻게 하지?'),
                  ),
                ],
              ),
            ),

            // 카테고리별 지출 내역
            Center(
              child: ToggleButtons(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("지난 달 카테고리 별 지출"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("이번 달 카테고리 별 지출"),
                  ),
                ],
                isSelected: [selectedIndex == 0, selectedIndex == 1],
                // 선택된 인덱스에 따라 색상 변경
                onPressed: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                color: Colors.black,
                // 비선택 시 색상
                selectedColor: Colors.white,
                // 선택 시 색상
                fillColor: Colors.blue,
                // 선택된 버튼 배경 색상
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            if (selectedIndex == 1)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이번 달 카테고리별 지출 내역',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: categoryExpenses.entries.map((entry) {
                        return ListTile(
                          title: Text(entry.key),
                          trailing: Text(
                              '${NumberFormat('#,###').format(entry.value)} 원'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            if (selectedIndex == 0)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '지난 달 카테고리별 지출 내역',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: lastMonthCategoryExpenses.entries.map((entry) {
                        return ListTile(
                          title: Text(entry.key),
                          trailing: Text(
                              '${NumberFormat('#,###').format(entry.value)} 원'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            if (selectedIndex == 1)
              PieChartSample3(
                monthly_expense_total: monthly_expense_total,
                categoryExpenses: categoryExpenses,
              ),
            if (selectedIndex == 0)
              PieChartSample3(
                monthly_expense_total: last_month_expense_total,
                categoryExpenses: lastMonthCategoryExpenses,
              ),

            Divider(),
            // 누적 지출 및 수입
            if (selectedIndex == 1)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이번 달 누적 지출 금액 : ${NumberFormat('#,###').format(monthly_expense_total)}원',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '이번 달 누적 수입 금액 : ${NumberFormat('#,###').format(monthly_income_total)}원',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            if (selectedIndex == 0)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '지난 달 누적 지출 금액 : ${NumberFormat('#,###').format(last_month_expense_total)}원',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '지난 달 누적 수입 금액 : ${NumberFormat('#,###').format(last_month_income_total)}원',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> getCumulativeData() async {
    String? token = await storage.read(key: 'JWT_TOKEN');
    final dio = Dio();
    try {
      final resp = await dio.get('http://$ip/transactions/monthly-summary',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (resp.statusCode == 200) {
        print('AI_CHAT_SCREEN - ${resp.data}');
        TotalModel summary = TotalModel.fromJson(resp.data);

        setState(() {
          monthly_expense_total = summary.monthly_expense_total;
          monthly_income_total = summary.monthly_income_total;
          categoryExpenses = summary.category_expenses;
        });
      } else {
        print('getCumulativeData - API 요청 실패: ${resp.statusCode}');
      }
    } catch (e) {
      print('에러 발생: AI_Chat_Screen - getCumulativeData -  $e');
    }
  }

  Future<void> getLastMonthCumulativeData() async {
    String? token = await storage.read(key: 'JWT_TOKEN');
    final dio = Dio();
    try {
      final resp = await dio.get('http://$ip/transactions/last-month-summary',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (resp.statusCode == 200) {
        print('AI_CHAT_SCREEN - getLastMonthCumulativeData -  ${resp.data}');

        LastMonthTotalModel lastMonthsummary = LastMonthTotalModel.fromJson(resp.data);

        setState(() {
          last_month_expense_total = lastMonthsummary.last_month_expense_total;
          last_month_income_total = lastMonthsummary.last_month_income_total;
          lastMonthCategoryExpenses = lastMonthsummary.last_month_category_expenses;
        });
      } else {
        print(
            'getCumulativeData - getLastMonthCumulativeData - API 요청 실패: ${resp.statusCode}');
      }
    } catch (e) {
      print('에러 발생: AI_Chat_Screen - getLastMonthCumulativeData -  $e');
    }
  }

}
