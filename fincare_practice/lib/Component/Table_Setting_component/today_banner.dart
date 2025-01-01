import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../model/category_data.dart';
//
// class TodayBanner extends StatelessWidget {
//   final DateTime selectedDay;
//   const TodayBanner({required this.selectedDay,super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: FutureBuilder(
//         future: _getTransactionsForToday(selectedDay), // 오늘 날짜의 트랜잭션을 가져오는 함수
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//
//           // 데이터가 없거나 빈 리스트인 경우 처리
//           if (!snapshot.hasData || snapshot.data == null || (snapshot.data as List).isEmpty) {
//             return Center(child: Text("오늘의 트랜잭션이 없습니다."));
//           }
//
//           // 데이터를 List<Map<String, dynamic>>로 변환
//           List<Map<String, dynamic>> transactions = [];
//           if (snapshot.data != null) {
//             // List<Map<String, dynamic>>로 안전하게 변환하기
//             transactions = List<Map<String, dynamic>>.from(snapshot.data!);
//
//             // 데이터를 제대로 변환했는지 확인
//             print("Transactions: $transactions");
//           }
//
//
//           return ListView.builder(
//             itemCount: transactions.length,
//             itemBuilder: (context, index) {
//               var transaction = transactions[index];
//
//               // Find the category from the categories list
//               String categoryLabel = transaction['category'];
//               String categoryImage = _getCategoryImage(categoryLabel); // Function to get the image path
//
//               return Container(
//                 padding: EdgeInsets.all(16.0),
//                 margin: EdgeInsets.symmetric(vertical: 8.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // 시간
//                     Text(
//                       DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(transaction['date'])),
//                       style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.bold),
//                     ),
//                     // 내용 (금액과 수입/지출)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           '₩ ${NumberFormat('#,###').format(transaction['amount'].toInt())}',
//                           style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.bold),
//                         ),
//                         Text(transaction['type'] == 'expense' ? '지출' : '수입'),
//                       ],
//                     ),
//                     // 카테고리 및 아이콘
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Image.asset(
//                           categoryImage,
//                           width: 30,  // You can adjust the size of the icon
//                           height: 30,
//                         ),
//                         Text(transaction['category']),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//   Future<List<Map<String, dynamic>>> _getTransactionsForToday(DateTime selectedDay) async {
//     var box = await Hive.openBox('transactionBox');
//     String dayKey = DateFormat('yyyy-MM-dd').format(selectedDay);  // 날짜를 'yyyy-MM-dd' 형식으로 변환
//
//     List<dynamic> transactionsForDay = box.get(dayKey, defaultValue: []);
//
//     // List<Map<String, dynamic>>로 변환하여 반환
//     return transactionsForDay.map((item) => Map<String, dynamic>.from(item)).toList();
//   }
//
//   String _getCategoryImage(String categoryLabel) {
//     // Loop through the categories list to find the matching category
//     final category = categories.firstWhere(
//           (cat) => cat['label'] == categoryLabel,
//       orElse: () => {'image': 'assets/images/etc.png'}, // Default to 'etc' if no match is found
//     );
//     return category['image'] ?? 'assets/images/etc.png'; // Return the image path
//   }
// }
class TodayBanner extends StatelessWidget {
  final DateTime selectedDay;

  const TodayBanner({required this.selectedDay, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: _getTransactionsForDay(selectedDay), // 선택한 날짜에 해당하는 트랜잭션을 가져오는 함수
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // 데이터가 없거나 빈 리스트인 경우 처리
          if (!snapshot.hasData || snapshot.data == null || (snapshot.data as List).isEmpty) {
            return Center(child: Text("오늘의 트랜잭션이 없습니다."));
          }

          List<Map<String, dynamic>> transactions = List<Map<String, dynamic>>.from(snapshot.data!);

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              var transaction = transactions[index];

              // Find the category from the categories list
              String categoryLabel = transaction['category'];
              String categoryImage = _getCategoryImage(categoryLabel); // 카테고리 이미지 가져오기

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
                    // 금액과 수입/지출
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
                    // 카테고리 이미지
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          categoryImage,
                          width: 30,
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
    );
  }

  Future<List<Map<String, dynamic>>> _getTransactionsForDay(DateTime selectedDay) async {
    var box = await Hive.openBox('transactionBox');
    String dayKey = DateFormat('yyyy-MM-dd').format(selectedDay);  // 날짜를 'yyyy-MM-dd' 형식으로 변환

    List<dynamic> transactionsForDay = box.get(dayKey, defaultValue: []);

    // List<Map<String, dynamic>>로 변환하여 반환
    return transactionsForDay.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  String _getCategoryImage(String categoryLabel) {
    // 카테고리 이미지 가져오기
    final category = categories.firstWhere(
          (cat) => cat['label'] == categoryLabel,
      orElse: () => {'image': 'assets/images/etc.png'}, // 카테고리가 없으면 기본 이미지 반환
    );
    return category['image'] ?? 'assets/images/etc.png';  // 이미지 경로 반환
  }
}
