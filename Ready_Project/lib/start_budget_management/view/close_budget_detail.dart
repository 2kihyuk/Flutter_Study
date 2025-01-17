import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:ready_project/common/layout/default_layout.dart';

import '../../common/const/data.dart';
import '../../common/const/transaction.dart';

class CloseBudgetDetail extends StatefulWidget {

  CloseBudgetDetail({super.key});

  @override
  State<CloseBudgetDetail> createState() => _CloseBudgetDetailState();
}

class _CloseBudgetDetailState extends State<CloseBudgetDetail> {
  final dio = Dio();

  final storage = FlutterSecureStorage();
  List<Transaction> transactions = [];
  @override
  void initState() {
    getTransactionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      child: Column(
        children: [
          ...transactions.map((transaction) => Text(
            'Amount: ${transaction.amount}, Category: ${transaction.category}, Type: ${transaction.type}, Date: ${transaction.date}',
            style: TextStyle(fontSize: 16),
          )).toList(),
        ],
      ),
    );
  }

  Future<void> getTransactionData() async {
    final token = await storage.read(key: JWT_TOKEN);

    try {
      final resp = await dio.get(
        'http://$ip/transactions?date=${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (resp.statusCode == 200) {
        List<dynamic> data = resp.data; // 데이터를 받아서
        List<Transaction> fetchedTransactions =
        data.map((json) => Transaction.fromJson(json)).toList();

        // 상태를 업데이트하여 UI 갱신
        setState(() {
          transactions = fetchedTransactions;
        });
      }
    } catch (e) {
      print('CloseBudgetDetail Try-Catch Error : $e');
    }

  }
}
