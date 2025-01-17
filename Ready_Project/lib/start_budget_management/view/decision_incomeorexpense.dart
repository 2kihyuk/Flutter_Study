import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ready_project/common/layout/default_layout.dart';

import '../../common/const/category.dart';
import '../../common/const/data.dart';
import '../../common/const/transaction.dart';
import '../component/toggle_button.dart';

class DecisionIncomeorexpense extends StatefulWidget {
  final String initialAmount;

  const DecisionIncomeorexpense({required this.initialAmount, super.key});

  @override
  State<DecisionIncomeorexpense> createState() => _DecisionExpanseState();
}

class _DecisionExpanseState extends State<DecisionIncomeorexpense> {
  String categoryItemString = "선택된 카테고리 없음";
  TextEditingController _controller = TextEditingController();
  int selectedExpanseIndex = 0; // 0: 수입, 1: 지출
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    // 텍스트 필드 초기 값 설정
    _controller.text = widget.initialAmount;
  }

  @override
  Widget build(BuildContext context) {
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
                'D-15 / 300000원', //여기에 남은 일수와 전체예산에서 현재날짜까지 지출한 금액을 뺸 값.
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
                        labelText: '금액을 입력하세용',
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
              Spacer(),
              ElevatedButton(
                onPressed: () async {

                  final token = await storage.read(key: JWT_TOKEN);
                  String amount = _controller.text
                      .replaceAll(RegExp(r'[^0-9]'), ''); // 입력한 금액에서 숫자만 추출
                  double amountValue = double.tryParse(amount) ?? 0.0;
                  String transactionType =
                      selectedExpanseIndex == 0 ? "수입" : "지출";
                  // print('amountValue : $amountValue  /  category : $categoryItemString  / type : $transactionType  / date : ${DateFormat('yyyy-MM-dd').format(DateTime.now())}');
                  // print(token);

                  // `Transaction` 객체 생성
                  Transaction transaction = Transaction(
                    amount: amountValue,
                    category: categoryItemString,
                    type: transactionType,
                    date: DateTime.now(), // 현재 날짜
                  );

                  // `Transaction` 객체를 JSON으로 변환
                  Map<String, dynamic> transactionJson = transaction.toJson();

                  try{
                    final resp = await dio.post(
                      'http://$ip/transactions',
                      options: Options(
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization' : 'Bearer $token',
                          }
                      ),
                      data: transactionJson
                    );
                    if(resp.statusCode==200){
                      Navigator.pop(context, _controller.text);
                      print('DecisionIncomeOrExpense에서 Transaction데이터를 서버에 성공적으로 전송');
                    }else{
                      print('DecisionIncomeOrExpense에서 Transaction데이터를 서버에 전송하는데 실패함');
                    }
                  }catch(e) {
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
}

class CategoryModal extends StatefulWidget {
  const CategoryModal({super.key});

  @override
  State<CategoryModal> createState() => _CategoryModalState();
}

class _CategoryModalState extends State<CategoryModal> {
  @override
  Widget build(BuildContext context) {
    int selectedIndex = -1;
    return Scaffold(
      body: GridView.builder(
        padding: EdgeInsets.all(30.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = isSelected ? -1 : index;
                print(selectedIndex);
                if (!isSelected) {
                  Navigator.pop(
                      context, categories[index]); // 모달 닫고 선택된 카테고리 정보 반환
                }
                // 선택/해제
              });
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.blue : Colors.grey[200],
                boxShadow: [
                  if (isSelected)
                    BoxShadow(color: Colors.blue, blurRadius: 10.0)
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      categories[index]["image"]!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      categories[index]['label']!,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
