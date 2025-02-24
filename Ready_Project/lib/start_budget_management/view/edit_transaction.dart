import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/const/data.dart';
import '../../common/const/transaction.dart';
import '../component/category_modal.dart';

class EditTransaction extends StatefulWidget {
  const EditTransaction({super.key});

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  late String type;
  late double amount;
  late String category;
  late int index;
  late String date;
  late int id;
  late String categoryItemString = "카테고리를 선택하세요.";
  int selectedExpanseIndex = 0; // 0: 수입, 1: 지출
  late TextEditingController _amountController = TextEditingController();
  String hintTextAmount = "";

  List<bool> selectedStates = [true, false]; // 초기값: 수입 선택 상태

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // arguments에서 데이터를 받아 초기화
    // arguments가 null이 아닌지 체크하고, Map으로 캐스팅
    final Map<String, dynamic>? args =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>?;

    if (args != null) {
      // 전달된 데이터를 안전하게 받아오기
      category = args['category'];
      amount = args['amount'];
      type = args['type'];
      date = args['date'].toString();
      id = args['id'];
      print('didChange - ${category}, ${amount} , ${type} , ${date} , ${id}');

    } else {
      // 만약 arguments가 null이라면 기본값을 할당하거나 예외 처리
      category = "내역이 누락되었습니다.";
      amount = 0.0;
      type = "Default Type";
    }

    // categoryItemString = category;
    hintTextAmount =
    "수정할 금액을 입력하세요. 수정 전 금액은 ${NumberFormat('#,###').format(amount)}원 입니다.";
    // 금액의 기호 초기화 (수입/지출에 따라 기호 변경)
    // selectedExpanseIndex = type == '수입' ? 0 : 1;
    selectedStates = [
      selectedExpanseIndex == 0,
      selectedExpanseIndex == 1,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('수정하기')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '수정 할 내역',
                    style: TextStyle(fontSize: 24.0),
                  )),
              SizedBox(
                height: 16.0,
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Text(
                      '금액 : ${NumberFormat('#,###').format(amount)}원',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      '소비 유형: $type',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      '카테고리 : $category',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(),
              SizedBox(
                height: 16.0,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '수정 후',
                    style: TextStyle(fontSize: 20.0),
                  )),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: hintTextAmount,
                        labelStyle: const TextStyle(
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
              const SizedBox(height: 50.0),
              Row(
                children: [
                  const Expanded(child: Text('분류')),
                  const SizedBox(width: 16.0),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(10),
                    borderWidth: 0,
                    selectedBorderColor: Colors.transparent,
                    selectedColor: Colors.black,
                    fillColor: Colors.transparent,
                    color: Colors.black.withOpacity(0.5),
                    constraints: const BoxConstraints(
                      minWidth: 55,
                      minHeight: 40,
                    ),
                    children: const [Text('수입'), Text('지출')],
                    isSelected: [
                      selectedExpanseIndex == 0,
                      selectedExpanseIndex == 1
                    ],
                    onPressed: (index) {
                      setState(() {
                        selectedExpanseIndex = index;
                        _amountController.text =
                            (selectedExpanseIndex == 0 ? "+" : "-") +
                                NumberFormat('#,###').format(double.parse(
                                    _amountController.text
                                        .replaceAll(RegExp(r'[^0-9]'), ''))) +
                                '원';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              // 카테고리 수정(모달)
              Row(
                children: [
                  Expanded(child: Text('카테고리')),
                  Text(categoryItemString),
                  IconButton(
                    onPressed: () async {
                      final selectedCategoryItem =
                      await showModalBottomSheet<Map<String, String>>(
                        context: context,
                        builder: (context) => CategoryModal(),
                      );

                      if (selectedCategoryItem != null) {
                        String newCategory = selectedCategoryItem['label']!;
                        if (newCategory != categoryItemString) {
                          setState(() {
                            categoryItemString = newCategory;
                          });
                        }
                        // setState(() {
                        //   categoryItemString = selectedCategoryItem['label']!;
                        //
                        // });
                      }
                    },
                    icon: const Icon(Icons.u_turn_right_outlined),
                  ),
                ],
              ),

              OutlinedButton(
                onPressed: () async {
                  final token = await storage.read(key: JWT_TOKEN);

                  // amount 값을 double로 변환
                  double amountValue = double.tryParse(
                      _amountController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ??
                      0.0;  // Using _amountController.text
                  // date 값을 DateTime으로 변환
                  DateTime dateValue = DateTime.parse(date);

                  String transactionType =
                  selectedExpanseIndex == 0 ? "수입" : "지출";


                  // `Transaction` 객체 생성
                  Transaction afterTransaction = Transaction(
                    amount: amountValue,
                    category: categoryItemString,
                    type: transactionType,
                    date: dateValue, // 현재 날짜
                  );

                  print('after - ${afterTransaction.category} / ${afterTransaction
                      .amount} / ${afterTransaction.type} / ${afterTransaction.date}');
                  // `Transaction` 객체를 JSON으로 변환
                  Map<String, dynamic> AfterEditTransactionJson = afterTransaction.toJson();

                  // Map<String, dynamic> BeforeEditTransactionJson = beforeTransaction.toJson();

                  ///이제 여기서 수정 전 , 수정 후 트랜잭션 데이터를 올리면 됨.
                  final dio = Dio();
                  try{
                    final resp = await dio.patch(
                        'http://$ip/transactions/update/${id}',
                        options: Options(
                            headers: {
                              'Content-Type': 'application/json',
                              'Authorization' : 'Bearer $token',
                            }
                        ),
                        data: AfterEditTransactionJson
                    );
                    if(resp.statusCode==200){
                      Navigator.pop(context,true);
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
                  '수정',
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
        _amountController.text = "+$formattedValue";
      } else {
        // 지출 선택 시 '-' 부호
        _amountController.text = "-$formattedValue";
      }

      // 커서 위치 유지
      _amountController.selection =
          TextSelection.collapsed(offset: _amountController.text.length - 2);
    } else {
      _amountController.text = "원";
    }
  }
}
