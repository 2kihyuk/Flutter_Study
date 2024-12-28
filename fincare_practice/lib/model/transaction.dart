import 'package:flutter/cupertino.dart';

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
}
