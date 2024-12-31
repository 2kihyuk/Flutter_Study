import 'package:fincare_practice/Component/savebutton.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../model/budgetmodel.dart';
import '../model/category_data.dart';

class EndSpendScreen extends StatelessWidget {
  const EndSpendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              '오늘 지출 영수증',
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              '하루 예산 ${Provider.of<BudgetModel>(context, listen: false).dailyBudgetCopy.toInt()}원',
              style: TextStyle(
                fontFamily: 'Pretendard',
              ),
            ),
          ),//반영되지 않은 dailyBudget초기값을 넣어주어야함.
          SizedBox(height: 30.0,),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              '지출 ${NumberFormat('#,###').format(Provider.of<BudgetModel>(context, listen: false).dailySpend.toInt())}원',
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              '수입 ${NumberFormat('#,###').format(Provider.of<BudgetModel>(context, listen: false).dailyPlus.toInt())}원',
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: 24.0,),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              '오늘 하루 총 지출액 ${NumberFormat('#,###').format(Provider.of<BudgetModel>(context, listen: false).dailyPlus.toInt() -
                  Provider.of<BudgetModel>(context,listen: false).dailySpend.toInt())}원',
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700),
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
          ///여기자리에는 오늘 하루동안 지출한 카테고리의 아이콘과 카테고리 이름, 지출금을 넣어주어야함.
          Expanded(
            child: FutureBuilder(
              future: _getTransactionsForToday(), // 오늘 날짜의 트랜잭션을 가져오는 함수
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }


                // 데이터가 없거나 빈 리스트인 경우 처리
                if (!snapshot.hasData || snapshot.data == null || (snapshot.data as List).isEmpty) {
                  return Center(child: Text("오늘의 트랜잭션이 없습니다."));
                }

                // 데이터를 List<Map<String, dynamic>>로 변환
                List<Map<String, dynamic>> transactions = [];
                if (snapshot.data != null) {
                  // List<Map<String, dynamic>>로 안전하게 변환하기
                  transactions = List<Map<String, dynamic>>.from(snapshot.data!);

                  // 데이터를 제대로 변환했는지 확인
                  print("Transactions: $transactions");
                }


                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    var transaction = transactions[index];

                    // Find the category from the categories list
                    String categoryLabel = transaction['category'];
                    String categoryImage = _getCategoryImage(categoryLabel); // Function to get the image path

                    return Container(
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
                            DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(transaction['date'])),
                            style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.bold),
                          ),
                          // 내용 (금액과 수입/지출)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₩ ${NumberFormat('#,###').format(transaction['amount'].toInt())}',
                                style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.bold),
                              ),
                              Text(transaction['type'] == 'expense' ? '지출' : '수입'),
                            ],
                          ),
                          // 카테고리 및 아이콘
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset(
                                categoryImage,
                                width: 30,  // You can adjust the size of the icon
                                height: 30,
                              ),
                              Text(transaction['category']),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),


          Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Savebutton(
              onSave: onButtonPressed,
              content: Provider.of<BudgetModel>(context, listen: false).dailyBudget -
                  Provider.of<BudgetModel>(context, listen: false).dailySpend <
                  0
                  ? '차감하기'
                  : '세이프박스에 더하기',
            ),
          ),
        ],
          ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getTransactionsForToday() async {
    var box = await Hive.openBox('transactionBox');
    String todayKey = DateTime.now().toIso8601String().split('T').first;

    List<dynamic> transactionsForToday = box.get(todayKey, defaultValue: []);

    // List<Map<String, dynamic>>로 변환
    return transactionsForToday.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  String _getCategoryImage(String categoryLabel) {
    // Loop through the categories list to find the matching category
    final category = categories.firstWhere(
          (cat) => cat['label'] == categoryLabel,
      orElse: () => {'image': 'assets/images/etc.png'}, // Default to 'etc' if no match is found
    );
    return category['image'] ?? 'assets/images/etc.png'; // Return the image path
  }


  onButtonPressed() {
    ///버튼 누르면 오늘 날짜에 있던 쉐어드 프레퍼런스에 존재하는 데이터를 모두 백엔드로 전송?  -> 달력 로직에서 백엔드에 있는 데이터 변경 감지시 그냥 바로 달력 에 반영?
    ///or 그냥 마감하고 달력에 반영하는 로직을 짜야하나?
  }
}
