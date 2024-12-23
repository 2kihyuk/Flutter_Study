// import 'package:flutter/material.dart';
//
// class BudgetModel extends ChangeNotifier {
//   double _budget = 0.0; // 예산 초기 값
//
//   double _dailyBudget = 0; // 하루 예산
//   double _dailySpend = 0; // 하루 지출
//   double _dailySpendLeft = 0; // 하루 예산에서 지출한 금액을 뺀 남은 금액
//   double _dailySpendOver = 0; // 초과 지출 금액 (마이너스)
//
//   double _totalSpend = 0; // 이번 달 총 지출
//   // double _budgetClone = 0; // 하루마다 복사되는 예산 (budget_clone)
//   DateTime _lastResetDate = DateTime.now(); // 마지막 초기화된 날짜
//   double _safeboxBudget = 0; // 아낀 금액 (이번 달에 절약한 금액)
//
//   double get budget => _budget;
//   double get dailyBudget => _dailyBudget;
//   double get dailySpend => _dailySpend;
//   double get dailySpendLeft => _dailySpendLeft;
//   double get dailySpendOver => _dailySpendOver;
//   double get safeboxBudget => _safeboxBudget;
//   double get totalSpend => _totalSpend;
//   DateTime get lastResetData => _lastResetDate;
//
//   set budget(double value) {
//     _budget = value;
//     _calculateDailyBudget(); // 예산 값이 변경되면 하루 예산을 재계산
//     notifyListeners(); // 상태가 변경되었음을 알립니다.
//   }
//
//   // 하루 예산을 계산하는 함수
//   void _calculateDailyBudget() {
//
//     // DateTime now = DateTime.now();
//     // DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
//     // DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
//     // int daysInMonth = lastDayOfMonth.day;
//     //
//     // _dailyBudget = _budget / daysInMonth; // 하루 예산 계산
//     DateTime now = DateTime.now();
//     DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
//     DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
//     int daysInMonth = lastDayOfMonth.day;
//
//     _dailyBudget = _budget / daysInMonth; // 하루 예산 계산
//     _dailySpendLeft = _dailyBudget; // 처음에는 예산이 남아있음
//     _dailySpendOver = 0; // 처음에는 초과 지출 없음
//     _safeboxBudget = 0; // 처음에는 아낀 금액 없음
//
//   }
//
//   set dailyBudget(double value) {
//     _dailyBudget = value;
//     notifyListeners();
//   }
//   ///하루 지출량 추가
//   void addDailySpend(double spendAmount) {
//     _dailySpend += spendAmount;
//     _updateDailySpendStatus();
//     notifyListeners();
//   }
//
//   // 하루 지출 상태 업데이트
//   void _updateDailySpendStatus() {
//     if (_dailySpend > _dailyBudget) {
//       _dailySpendOver = _dailySpend - _dailyBudget; // 초과 지출
//       _dailySpendLeft = 0; // 남은 예산 없음
//     } else {
//       _dailySpendLeft = _dailyBudget - _dailySpend; // 남은 예산 계산
//       _dailySpendOver = 0; // 초과 지출 없음
//     }
//   }
//
//   // 하루가 지나면 `dailySpend` 값을 초기화하고, `safeboxBudget`에 절약한 금액을 추가
//   void resetDailySpend() {
//     _safeboxBudget += _dailySpendLeft; // 아낀 금액을 safebox에 더함
//     _dailySpend = 0; // 하루 지출 초기화
//     _dailySpendLeft = _dailyBudget; // 남은 예산을 하루 예산으로 초기화
//     _dailySpendOver = 0; // 초과 지출 초기화
//     notifyListeners();
//   }
//
//   // 이번 달 아낀 금액을 계산
//   void calculateSafeboxBudget() {
//     DateTime now = DateTime.now();
//     if (now.day == 1) {
//       // 매일 1일마다 safeboxBudget 계산
//       _safeboxBudget = 0; // 새로운 달이 시작되면 safeboxBudget 초기화
//     }
//   }
// }
import 'dart:async';

import 'package:fincare_practice/model/transaction.dart';
import 'package:flutter/material.dart';

class BudgetModel extends ChangeNotifier {
  double _budget = 0.0; // 월 예산
  double _dailyBudget = 0; // 하루 예산
  double _dailySpend = 0; // 하루 지출
  double _dailySpendLeft = 0; // 하루 예산에서 지출한 금액을 뺀 남은 금액
  double _dailySpendOver = 0; // 초과 지출 금액 (음수)
  double _totalSpend = 0; // 이번 달 총 지출
  double _safeboxBudget = 0; // 아낀 금액 (이번 달에 절약한 금액)
  double _dailyPlus = 0; // 하루 수입 (이 값은 수입을 추가하는 데 사용)

  DateTime _lastResetDate = DateTime.now(); // 마지막 초기화된 날짜

  List<Transaction> _transactions = [];

  double get budget => _budget;

  double get dailyBudget => _dailyBudget;

  double get dailySpend => _dailySpend;

  double get dailySpendLeft => _dailySpendLeft;

  double get dailySpendOver => _dailySpendOver;

  double get safeboxBudget => _safeboxBudget;

  double get totalSpend => _totalSpend;

  double get dailyPlus => _dailyPlus;

  DateTime get lastResetDate => _lastResetDate;

  set budget(double value) {
    _budget = value;
    _calculateDailyBudget(); // 예산 값이 변경되면 하루 예산을 재계산
    notifyListeners(); // 상태가 변경되었음을 알립니다.
  }

  void setDailyBudget(double value) {
    _dailyBudget = value;
    // 이 곳에서 notifyListeners()를 호출하여 상태 변경을 알림
    notifyListeners();
  }

  // 하루 예산을 계산하는 함수
  void _calculateDailyBudget() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    int daysInMonth = lastDayOfMonth.day;

    _dailyBudget = _budget / daysInMonth; // 하루 예산 계산
    _dailySpendLeft = _dailyBudget; // 처음에는 예산이 남아있음
    _dailySpendOver = 0; // 처음에는 초과 지출 없음
    _safeboxBudget = 0; // 처음에는 아낀 금액 없음
  }

  // 하루 지출량 추가
  void addDailySpend(double spendAmount) {
    _dailySpend += spendAmount;
    _totalSpend += spendAmount; // 총 지출에 추가
    _updateDailySpendStatus();
    notifyListeners();
  }

  // 하루 지출 상태 업데이트
  void _updateDailySpendStatus() {
    if (_dailySpend > _dailyBudget) {
      _dailySpendOver = _dailySpend - _dailyBudget; // 초과 지출
      _dailySpendLeft = 0; // 남은 예산 없음
    } else {
      _dailySpendLeft = _dailyBudget - _dailySpend; // 남은 예산 계산
      _dailySpendOver = 0; // 초과 지출 없음
    }
  }

  // 하루가 지나면 `dailySpend` 값을 초기화하고, `safeboxBudget`에 절약한 금액을 추가
  void resetDailySpend() {
    // 아낀 금액을 safebox에 더함
    _safeboxBudget += _dailySpendLeft;

    // 하루 지출 초기화
    _dailySpend = 0;

    // 하루 예산에서 지출을 뺀 남은 예산을 계산
    _dailySpendLeft = _dailyBudget - _dailySpend;

    // 초과 지출 초기화
    if (_dailySpend > _dailyBudget) {
      _dailySpendOver = _dailySpend - _dailyBudget; // 초과 지출 금액
    } else {
      _dailySpendOver = 0; // 초과 지출이 없으면 0
    }

    notifyListeners();
  }

  // 하루가 지나면 자동으로 초기화
  void checkAndReset() {
    DateTime now = DateTime.now();
    // 자정이 지난 후에 resetDailySpend() 호출
    if (now.year != _lastResetDate.year ||
        now.month != _lastResetDate.month ||
        now.day != _lastResetDate.day) {
      resetDailySpend();
      _lastResetDate = now; // 날짜 갱신
    }
  }

  // 자정까지 남은 시간 계산
  Duration _calculateDurationUntilMidnight() {
    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day + 1);
    return midnight.difference(now); // 자정까지 남은 시간 계산
  }

  // Timer를 사용하여 자정마다 자동으로 하루 초기화
  void startTimer() {
    Duration durationUntilMidnight = _calculateDurationUntilMidnight();
    Timer.periodic(durationUntilMidnight, (timer) {
      checkAndReset(); // 자정이 되면 checkAndReset 호출
    });
  }

  void addTransaction(double amount, String category, String type) {

    if (type == "income") {
      _dailyPlus += amount;
    } else if (type == "expense") {
      _dailySpend += amount;
      _totalSpend += amount; // 총 지출에 반영
    }

    Transaction newTransaction = new Transaction(
      amount: amount,
      category: category,
      type: type,
      date: DateTime.now(),);

    _transactions.add(newTransaction); //트랜잭션리스트에 트랜잭션 추가. (가격, 카테고리, 지출or수입,추가한 날짜 및 시간)
    printTransactions();
    _totalSpend += (type == "expense" ? amount : 0);
    _updateDailySpendStatus();
    notifyListeners();
  }
  void printTransactions() {
    for (var transaction in _transactions) {
      print("Transaction - Category: ${transaction.category}, Amount: ${transaction.amount}, Type: ${transaction.type}, Date: ${transaction.date}");
    }
  }

}
