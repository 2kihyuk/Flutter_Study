import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../common/const/category.dart';
import '../../common/const/data.dart';
import '../../common/const/transaction.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<Transaction> transactions = [];

  String selectedDateString =
      "${DateTime.now().toUtc().year}년 ${DateTime.now().toUtc().month}월 ${DateTime.now().toUtc().day}일";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TableCalendar(
              locale: 'ko_KR',
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2000, 01, 01),
              lastDay: DateTime.utc(2099, 12, 31),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;

                  selectedDateString =
                      "${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일";
                  getTransactionData(selectedDay);

                  //날짜눌렀을떄, 해당 날짜에 해당하는 트랜잭션 데이터를 띄워줘야함 아래 listview
                });
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                weekendStyle: TextStyle(color: Colors.red),
              ),
            ),
            Divider(),

            Container(

              padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedDateString),
                  Text("이날의 지출 및 수입 건수 : ${transactions.length}건"),
                ],
              ),
            ),

            Expanded(

              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (BuildContext context, int index) {

                  Transaction transaction = transactions[index];
                  String categoryLabel = transaction.category;
                  String categoryImage = getCategoryImage(
                      categoryLabel);

                  return Container(
                    padding: EdgeInsets.all(16.0),
                    margin: EdgeInsets.symmetric(vertical:6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 날짜
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            SizedBox(height: 4),
                            Text(
                              DateFormat('yyyy-MM-dd').format(transaction.date),
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        // 금액과 수입/지출
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              NumberFormat("#,###").format(transaction.amount)+"원",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "${transaction.type} - ${transaction.category}",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        // 카테고리 및 아이콘
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  categoryImage,
                                  width: 40, // You can adjust the size of the icon
                                  height: 40,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getCategoryImage(String categoryLabel) {
    final category = categories.firstWhere(
          (label) => label['label'] == categoryLabel,
      orElse: () => {'image': 'assets/images/etc.png'},
    );

    return category['image'] ?? 'assets/images/etc.png';
  }

  Future<void> getTransactionData(DateTime selectedDate) async {
    final dio = Dio();
    final token = await storage.read(key: JWT_TOKEN);
    try {

      final resp = await dio.get(
        'http://$ip/transactions/daily?date=${DateFormat('yyyy-MM-dd').format(_selectedDay)}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if(resp.statusCode==200){
          List<dynamic>data = resp.data['transactions'];
          List<Transaction> fetchedTransactions =
          data.map((json) => Transaction.fromJson(json)).toList();

          setState(() {
            transactions = fetchedTransactions;
          });
      }

    } catch (e) {
      print('Calendar Try-Catch Error : $e');
    }
  }
}
