
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import 'data.dart';

class Transaction {
  final double amount; //금액
  final String category; //카테고리
  final String type; //수입 인지 지출인지
  final DateTime date; //날짜

  Transaction({
    required this.amount,
    required this.category,
    required this.type,
    required this.date
  });


  Map<String,dynamic> toJson(){
    return {
      "type" : type,
      "category" : category,
      "amount" : amount,
      "date" : DateFormat('yyyy-MM-dd').format(date),
    };
  }

  // fromJson 메서드를 추가하여 JSON 데이터를 객체로 변환
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'].toDouble(),
      category: json['category'],
      type: json['type'],
      date: DateTime.parse(json['date']), // 날짜는 'yyyy-MM-dd' 형식으로 변환
    );
  }
}


class DailySummary {
  final List<Transaction> transactions; // 트랜잭션 리스트
  final double dailyExpenseTotal; // 하루 지출 총합
  final double dailyIncomeTotal; // 하루 수입 총합
  final double dailyBudgetNoChange;

  DailySummary({
    required this.transactions,
    required this.dailyExpenseTotal,
    required this.dailyIncomeTotal,
    required this.dailyBudgetNoChange
  });

  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      transactions: (json['transactions'] as List)
          .map((item) => Transaction.fromJson(item))
          .toList(),
      dailyExpenseTotal: json['daily_expense_total'].toDouble(),
      dailyIncomeTotal: json['daily_income_total'].toDouble(),
      dailyBudgetNoChange: json['daily_budget_no_change'].toDouble(),
    );
  }
}
