import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ready_project/common/layout/default_layout.dart';
import 'package:ready_project/riverpod/budget_notifier.dart';
import 'package:ready_project/start_budget_management/riverpod/safebox_notifier.dart';

import '../../common/const/category.dart';
import '../../common/const/data.dart';
import '../../common/const/transaction.dart';
import '../../riverpod/daily_summary_notifier.dart';
import '../component/category_modal.dart';
import '../component/toggle_button.dart';

class DecisionIncomeorexpense extends ConsumerStatefulWidget {
  final String initialAmount;

  const DecisionIncomeorexpense({required this.initialAmount, super.key});

  @override
  ConsumerState<DecisionIncomeorexpense> createState() =>
      _DecisionExpanseState();
}

class _DecisionExpanseState extends ConsumerState<DecisionIncomeorexpense> {
  String categoryItemString = "선택된 카테고리 없음";
  TextEditingController _controller = TextEditingController();
  int selectedExpanseIndex = 0; // 0: 수입, 1: 지출
  double monthly_expense_total = 0;
  final dio = Dio();
  bool OpenSafeBox = false;
  bool isSafeBoxPossible = false;
  String selectedOption = 'A';

  @override
  void initState() {
    super.initState();
    getCumulativeData();
    // 텍스트 필드 초기 값 설정
    _controller.text = widget.initialAmount;
  }

  @override
  Widget build(BuildContext context) {
    final budget = ref.watch(budgetProvider);
    final safeBox = ref.watch(safeBoxProvider);
    double enteredAmount = double.tryParse(
            widget.initialAmount.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0.0;

    if (safeBox > 0) {
      isSafeBoxPossible = true;
    }

    DateTime now = DateTime.now();
    DateTime lastDayOfMonth =
        DateTime(now.year, now.month + 1, 0); // 이번 달 마지막 날짜

    // 남은 일수 계산
    int remainingDays = lastDayOfMonth.difference(now).inDays;

    // 남은 일수를 "D-15" 형식으로 출력
    String remainingDaysText = "D-$remainingDays";


    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '남은 일정과 금액',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              Text(
                '$remainingDaysText / ${NumberFormat('#,###').format(3000000 - monthly_expense_total)}원', //3백만원 대신 month_budget.
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: '금액을 입력하세요',
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onChanged: (value) {
                        _updateAmountWithSign(value);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('분류'),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(10),
                    // 테두리 둥글게
                    borderWidth: 0,
                    // 테두리 없음
                    selectedBorderColor: Colors.transparent,
                    // 선택된 버튼의 테두리 제거
                    selectedColor: Colors.black,
                    // 선택된 버튼 텍스트 색
                    fillColor: Colors.transparent,
                    // 배경색 투명
                    color: Colors.black.withOpacity(0.5),
                    // 비선택된 버튼 텍스트 색
                    constraints: BoxConstraints(
                      minWidth: 55, // 버튼 최소 너비
                      minHeight: 40, // 버튼 최소 높이
                    ),
                    children: [Text('수입'), Text('지출')],
                    isSelected: [
                      selectedExpanseIndex == 0,
                      selectedExpanseIndex == 1
                    ],
                    onPressed: (index) {
                      setState(() {
                        selectedExpanseIndex = index;
                        _controller.text =
                            (selectedExpanseIndex == 0 ? "+" : "-") +
                                NumberFormat('#,###').format(double.parse(
                                    _controller.text
                                        .replaceAll(RegExp(r'[^0-9]'), ''))) +
                                '원'; // 기존 기호 삭제 후 새로운 기호 추가

                        if (index == 1 && enteredAmount > budget.daily_budget) {
                          setState(() {
                            OpenSafeBox =
                                true; // 지출이 예산을 초과하면 OpenSafeBox = true로 설정
                          });
                        } else {
                          setState(() {
                            OpenSafeBox = false; // 예산 내라면 OpenSafeBox = false
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('카테고리'),
                  ),
                  Text('${categoryItemString}'),
                  IconButton(
                    onPressed: () async {
                      final selectedCategoryItem =
                          await showModalBottomSheet<Map<String, String>>(
                        context: context,
                        builder: (context) => CategoryModal(),
                      );
                      if (selectedCategoryItem != null) {
                        setState(() {
                          categoryItemString = selectedCategoryItem['label']!;
                        });
                      }
                    },
                    icon: Icon(Icons.u_turn_right_outlined),

                    ///여기 아이콘 바꿔야함.
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              if (OpenSafeBox && isSafeBoxPossible)
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '하루 예산을 초과하여 SafeBox 금액을 사용 할 수 있습니다.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                              '세이프 박스 : ${NumberFormat('#,###').format(safeBox)}원'),
                          Text('지출하려는 금액 : ${widget.initialAmount}원'),
                          Text(
                              '오늘 하루 잔여 예산 : ${NumberFormat('#,###').format(budget.daily_budget)}원'),
                          Text(
                              '초과되는 금액 : ${NumberFormat('#,###').format(budget.daily_budget - enteredAmount)}원 '),
                          // 추가로 SafeBox에서 꺼낼 금액을 설정하거나 버튼을 넣을 수 있음
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        RadioListTile<String>(
                          title: Text(
                              '${NumberFormat('#,###').format(budget.daily_budget)}원 을 모두 사용하고 ${NumberFormat('#,###').format(budget.daily_budget - enteredAmount)}원을 세이프 박스에서 사용할까요?'),
                          value: 'A',
                          groupValue: selectedOption,
                          onChanged: (String? value) {
                            setState(() {
                              selectedOption = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: Text(
                              '세이프 박스 금액은 사용하지 않고 오늘 하루 잔여 예산을 초과하여 지출하시겠습니까?'),
                          value: 'B',
                          groupValue: selectedOption,
                          onChanged: (String? value) {
                            setState(() {
                              selectedOption = value!;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Text(
                          '선택된 옵션: $selectedOption',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  final token = await storage.read(key: JWT_TOKEN);
                  String amount = _controller.text
                      .replaceAll(RegExp(r'[^0-9]'), ''); // 입력한 금액에서 숫자만 추출
                  double amountValue = double.tryParse(amount) ?? 0.0;
                  String transactionType =
                      selectedExpanseIndex == 0 ? "수입" : "지출";

                  // `Transaction` 객체 생성
                  Transaction transaction = Transaction(
                    amount: amountValue,
                    category: categoryItemString,
                    type: transactionType,
                    date: DateTime.now(), // 현재 날짜
                  );

                  // `Transaction` 객체를 JSON으로 변환
                  Map<String, dynamic> transactionJson = transaction.toJson();

                  try {
                    final resp = await dio.post('http://$ip/transactions',
                        options: Options(headers: {
                          'Content-Type': 'application/json',
                          'Authorization': 'Bearer $token',
                        }),
                        data: transactionJson);
                    if (resp.statusCode == 200) {
                      // await ref.read(budgetProvider.notifier).getDailyBudgetAnytime(token!);
                      Navigator.pop(context, _controller.text);
                      print(
                          'DecisionIncomeOrExpense에서 Transaction데이터를 서버에 성공적으로 전송');
                    } else {
                      print(
                          'DecisionIncomeOrExpense에서 Transaction데이터를 서버에 전송하는데 실패함');
                    }
                  } catch (e) {
                    print('DecisionIncomeOrExpense Try-Catch Error : $e');
                    if (e is DioError) {
                      // DioErrorType을 체크하여 오류 종류를 파악
                      switch (e.type) {
                        case DioErrorType.connectTimeout:
                          print('Connection timeout');
                          break;
                        case DioErrorType.sendTimeout:
                          print('Send timeout');
                          break;
                        case DioErrorType.receiveTimeout:
                          print('Receive timeout');
                          break;
                        case DioErrorType.response:
                          // 서버 응답을 받았지만 에러 상태 코드가 반환됨
                          print('Error response: ${e.response}');
                          break;
                        case DioErrorType.cancel:
                          print('Request cancelled');
                          break;
                        case DioErrorType.other:
                          print('Other error: ${e.message}');
                          break;
                      }
                    }
                  }
                },
                child: Text(
                  '저장',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(400, 50),
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateAmountWithSign(String value) {
    // 숫자만 추출하여 '원' 붙이기
    String amount = value.replaceAll(RegExp(r'[^0-9]'), ''); // 숫자만 추출
    if (amount.isNotEmpty) {
      String formattedValue = "$amount 원";
      if (selectedExpanseIndex == 0) {
        // 수입 선택 시 '+' 부호
        _controller.text = "+$formattedValue";
      } else {
        // 지출 선택 시 '-' 부호
        _controller.text = "-$formattedValue";
      }

      // 커서 위치 유지
      _controller.selection =
          TextSelection.collapsed(offset: _controller.text.length - 2);
    } else {
      _controller.text = "원";
    }
  }

  Future<void> getCumulativeData() async {
    String? token = await storage.read(key: 'JWT_TOKEN');
    final dio = Dio();
    try {
      final resp = await dio.get('http://$ip/transactions/monthly-summary',
          options: Options(headers: {'Authorization': 'Bearer $token'}

              // resp['monthly_expense_total']
              ));
      if (resp.statusCode == 200) {
        setState(() {
          monthly_expense_total = resp.data['monthly_expense_total'];
        });
      } else {
        print('getCumulativeData - API 요청 실패: ${resp.statusCode}');
      }
    } catch (e) {
      print('에러 발생: AI_Chat_Screen - getCumulativeData -  $e');
    }
  }
}
