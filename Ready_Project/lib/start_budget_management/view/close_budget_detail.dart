import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:ready_project/common/const/category.dart';
import 'package:ready_project/common/layout/default_layout.dart';
import 'package:ready_project/riverpod/budget_notifier.dart';
import 'package:ready_project/start_budget_management/view/edit_transaction.dart';

import '../../common/const/data.dart';
import '../../common/const/transaction.dart';
import '../../riverpod/daily_summary_notifier.dart';
import '../../riverpod/transaction_provider.dart';

class CloseBudgetDetail extends ConsumerStatefulWidget {
  const CloseBudgetDetail({super.key});

  @override
  _CloseBudgetDetailState createState() => _CloseBudgetDetailState();
}

class _CloseBudgetDetailState extends ConsumerState<CloseBudgetDetail> {
  @override
  void initState() {
    super.initState();
    getTransactionData();
  }

  List<Transaction> transactions = [];
  double dailyExpenseTotal = 0.0;
  double dailyIncomeTotal = 0.0;

  // @override
  @override
  Widget build(BuildContext context) {
    final budget = ref.watch(budgetProvider);
    final dailySummary = ref.watch(dailySummaryProvider);

    return DefaultLayout(
      title: '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24.0),
            child: Text(
              '오늘 지출 영수증',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              '하루 예산: ${NumberFormat('#,###').format(dailySummary.dailyBudgetNoChange)}원', // 예산을 provider로부터 가져오기
            ),
          ),

          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              '지출: ${NumberFormat('#,###').format(dailySummary.dailyExpenseTotal)}원',
              // 지출 데이터를 provider로부터 가져오기
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              '수입: ${NumberFormat('#,###').format(dailySummary.dailyIncomeTotal)}원',
              // 수입 데이터를 provider로부터 가져오기
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              '오늘 하루 잔여 예산: ${NumberFormat('#,###').format((dailySummary.dailyBudgetNoChange - dailySummary.dailyExpenseTotal + dailySummary.dailyIncomeTotal).toInt())}원',
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text('${DateTime.now().day}일 오늘'),
          ),
          Divider(),
          //구분선

          Expanded(
            child: ListView.builder(
              itemCount: dailySummary.transactions.length,
              itemBuilder: (context, index) {
                Transaction transaction = dailySummary.transactions[index];

                String categoryLabel = transaction.category;
                String categoryImage = getCategoryImage(
                    categoryLabel); // Function to get the image path

                return InkWell(
                  onTap: () {
                    print('Tapped on item at index: $index');
                    print(
                        '${transaction.amount} / ${transaction.category} / ${transaction.type} / ${transaction.date}');
                    showOptionDialog(context, transaction, index);
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
// 시간
                        Text(
                          DateFormat('yyyy-MM-dd HH:mm')
                              .format(transaction.date),
                          style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.bold),
                        ),
// 내용 (금액과 수입/지출)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${NumberFormat('#,###').format(transaction.amount)}원',
                              style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(transaction.type),
                          ],
                        ),
// 카테고리 및 아이콘
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              categoryImage,
                              width: 30, // You can adjust the size of the icon
                              height: 30,
                            ),
                            Text(transaction.category),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Align(
          //   alignment: Alignment.center,
          //   child: ElevatedButton(
          //     onPressed: (){
          //       ///여기에는 트랜잭션 데이터를 저장하고 마감하고, budget값들을 초기화 시키는 작업이 필요함. 하루의 지출계획이 더이상 없다. 수입계획이 더이상 없다 할때 , 지출을 마감할때 쓰는 곳.
          //       ///이 작업이 12시 지나서도 자동으로 행해지는것이 가능한가?
          //       ///여기서 오늘 하루 잔예 총 예산을 post로 쏴줘야함.
          //     },
          //     child: Text('저장'),
          //   ),
          // ),
        ],
      ),
    );
  }

  void showOptionDialog(
      BuildContext context, Transaction transaction, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('옵션 선택'),
          content: Text('해당 내역을 수정 또는 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                _editTransaction(transaction, index); // 수정 로직 실행
              },
              child: const Text("수정"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                _deleteTransaction(transaction , index); // 삭제 로직 실행
              },
              child: const Text("삭제"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text("취소"),
            ),
          ],
        );
      },
    );
  }

  void _editTransaction(Transaction transaction, int index) {
    //트랜잭션 데이터 수정 페이지로 이동하여, 트랜잭션 데이터를 매핑해놓고, 데이터를 수정 할 수 있게. 그걸 다시 post.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditTransaction(),
        settings: RouteSettings(
          arguments: {'category': transaction.category , 'amount': transaction.amount , 'type': transaction.type, 'date':transaction.date , 'id': transaction.id},
        ),
      ),
    ).then(
        (value){
          if(value==true){
            getTransactionData();
          }
        }
    );
  }

  Future<void> _deleteTransaction(Transaction transaction , int index) async {
    final dio = Dio();
    final storage = FlutterSecureStorage();

    final token = await storage.read(key: JWT_TOKEN);

    try {
      final response = await dio.delete(
        'http://$ip/transactions/delete/${transaction.id}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        print("CloseBudgetDetail : _deleteTransaction : ${response.data}");
        getTransactionData();

      } else {
        print('API 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: CloaseBudgetDetail - _deleteTransaction -  $e');
    }
  }

  String getCategoryImage(String categoryLabel) {
    final category = categories.firstWhere(
      (label) => label['label'] == categoryLabel,
      orElse: () => {'image': 'assets/images/etc.png'},
    );

    return category['image'] ?? 'assets/images/etc.png';
  }

  Future<void> getTransactionData() async {
    final token = await storage.read(key: JWT_TOKEN);
    final dio = Dio();

    try {
      final resp = await dio.get(
        'http://$ip/transactions/daily?date=${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (resp.statusCode == 200) {
        final dailyIncomeTotal = resp.data['daily_income_total'];
        final dailyExpenseTotal = resp.data['daily_expense_total'];
        final dailyBudgetNoChanged = resp.data['daily_budget_no_change'];

        print('${resp.data}');


        List<dynamic> data = resp.data['transactions']; // 데이터를 받아서
        List<Transaction> fetchedTransactions =
            data.map((json) => Transaction.fromJson(json)).toList();
        for (var transaction in fetchedTransactions) {
          print("Transaction ID: ${transaction.id}");
        }
        // 상태 업데이트
        final dailySummary = DailySummary(
            transactions: fetchedTransactions,
            dailyIncomeTotal: dailyIncomeTotal,
            dailyExpenseTotal: dailyExpenseTotal,
            dailyBudgetNoChange: dailyBudgetNoChanged);

        ref
            .read(dailySummaryProvider.notifier)
            .updateDailySummary(dailySummary);
      }
    } catch (e) {
      print('CloseBudgetDetail Try-Catch Error : $e');
    }
  }
}
