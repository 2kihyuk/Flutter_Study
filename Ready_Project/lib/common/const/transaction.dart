
import 'package:intl/intl.dart';

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