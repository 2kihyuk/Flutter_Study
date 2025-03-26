import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ready_project/AIServiceScreen/AI_Screen/last_month_analyze.dart';
import 'package:ready_project/AIServiceScreen/AI_Screen/this_month_analyze.dart';
import 'package:ready_project/AIServiceScreen/view/pie_chart_sample3.dart';
import 'package:ready_project/common/layout/default_layout.dart';
import 'package:ready_project/riverpod/budget_model.dart';
import 'package:ready_project/riverpod/budget_notifier.dart';

import '../../common/const/data.dart';
import '../Model/TotalModel.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
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
    final budget = ref.watch(budgetProvider);
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
                    onPressed: () {
                      ///여기서 저번달 데이터를 가지고 프롬프트를 작성해서 push할때 데이터로 함께 집어넣어서 이동시키면 될듯.
                      ///그리고 페이지 이동해서 initState할때 ? post로 프롬프트 보내주고 응답 받아올 동안 CircleProgressIndicator() 띄워주다가 데이터 오면, 대화 형식?의 화면에다가
                      ///응답을 띄워주면 될거같음.

                      String lastMonthAnalyzePrompt =
                          makeLastMonthAnalyzePrompt(
                        budget,
                        last_month_expense_total,
                        last_month_income_total,
                        lastMonthCategoryExpenses,
                      );
                      print('$lastMonthAnalyzePrompt');

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => LastMonthAnalyze(
                                p: lastMonthAnalyzePrompt,
                              )));
                    },
                    child: Text('저번 달 소비패턴 분석하기'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      ///이번달과 저번달의 사용 데이터를 가지고 이를 토대로 다음달에는 어떻게 소비하면 불필요한 소비를 줄이고 예산을 더 아끼면서 효과적이고 효율적인 지출을 할 수 있을지에 대한
                      ///프롬프트를 제작해서 날려주기.
                    },
                    child: Text('다음 달엔 어떻게 아끼지?'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      ///여기도 현재 이번달 누적 사용량 데이터와, 이번달이 몇일 남았고, 남은 사용가능액을 함께 종합해서 프롬프트를 제작해서 화면 이동후 initState때 post로 데이터 날려주기.

                      String thisMonthAnalyzaPrompt =
                          makeHowSaveBudgetThisMonth(
                              budget,
                              monthly_expense_total,
                              monthly_income_total,
                              categoryExpenses);
                      print('$thisMonthAnalyzaPrompt');

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ThisMonthAnalyze(
                              prompt: thisMonthAnalyzaPrompt)));
                    },
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

  String makeLastMonthAnalyzePrompt(
      BudgetModel budget,
      double last_month_expense_total,
      double last_month_income_total,
      Map<String, double> lastMonthExpenses) {
    return '내 한달 총 사용 가능 금액은 ${NumberFormat('#,###').format(budget.month_budget)}원 이고 '
        '저번 달 누적 지출액은 ${NumberFormat('#,###').format(last_month_expense_total)}원 이고 '
        '저번 달 누적 수입 액은 ${NumberFormat('#,###').format(last_month_income_total)}원 이고 '
        '저번 달 지출 내역은 ${lastMonthExpenses.entries.map((entry) => entry.key)} 항목에  각각 ${lastMonthExpenses.entries.map((entry) => entry.value)}원이야.'
        '저번 달 내 소비 패턴에 대한 분석과 어떻게 하면 이번 달에 더 나은 소비를 할 수 있을지 금액을 중심으로 조언해줘.';
  }

  String makeHowSaveBudgetThisMonth(
      BudgetModel budget,
      double monthly_expense_total,
      double monthly_income_total,
      Map<String, double> categoryExpenses) {
    return '이번 달 내 한달 총 사용 가능 금액은 ${NumberFormat('#,###').format(budget.month_budget)}원 이고 ,'
        '이번 달 현재 누적 지출 금액은 ${NumberFormat('#,###').format(monthly_expense_total)}원 이고 ,'
        '이번 달 현재 누적 수입 금액은 ${NumberFormat('#,###').format(monthly_income_total)}원 이고 ,'
        '이번 달 지출 내역은 ${categoryExpenses.entries.map((entry) => entry.key)} 항목에 각각 ${categoryExpenses.entries.map((entry) => entry.value)}원 이야.'
        '지금은 ${DateTime.now().month}월 ${DateTime.now().day}일인데, 이번 달 남은 내 지출 가능 금액은 ${NumberFormat('#,###').format(budget.month_budget - monthly_expense_total)}원 이야.'
        '이번 달 남은 기간 동안 어떻게 해야 합리적인 소비 및 예산을 관리 할 수 있을지 금액을 중심으로 조언해줘.';
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

        LastMonthTotalModel lastMonthsummary =
            LastMonthTotalModel.fromJson(resp.data);

        setState(() {
          last_month_expense_total = lastMonthsummary.last_month_expense_total;
          last_month_income_total = lastMonthsummary.last_month_income_total;
          lastMonthCategoryExpenses =
              lastMonthsummary.last_month_category_expenses;
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
