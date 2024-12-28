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

import 'dart:convert';

import 'package:fincare_practice/model/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

///---------------------------------------------------------------------------------------------------------------------------------------
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:fincare_practice/model/transaction.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class BudgetModel with ChangeNotifier {
//   double _budget = 0.0; // 월 예산
//   double _dailyBudget = 0; // 하루 예산
//   double _dailySpend = 0; // 하루 지출
//   double _dailySpendLeft = 0; // 하루 예산에서 지출한 금액을 뺀 남은 금액
//   double _dailySpendOver = 0; // 초과 지출 금액 (음수)
//   double _totalSpend = 0; // 이번 달 총 지출
//   double _safeboxBudget = 0; // 아낀 금액 (이번 달에 절약한 금액)
//   double _dailyPlus = 0; // 하루 수입 (이 값은 수입을 추가하는 데 사용)
//
//   DateTime _lastResetDate = DateTime.now(); // 마지막 초기화된 날짜
//
//   // List<Transaction> _transactions = [];
//   Map<String,List<Transaction>> _transactions = {}; //날짜,트랜잭션데이터를 맵형태로 저장. 날짜별로 데이터 저장.
//
//   double get budget => _budget;
//
//   double get dailyBudget => _dailyBudget;
//
//   double get dailySpend => _dailySpend;
//
//   double get dailySpendLeft => _dailySpendLeft;
//
//   double get dailySpendOver => _dailySpendOver;
//
//   double get safeboxBudget => _safeboxBudget;
//
//   double get totalSpend => _totalSpend;
//
//   double get dailyPlus => _dailyPlus;
//
//   DateTime get lastResetDate => _lastResetDate;
//
//   Map<String, List<Transaction>> get transactions => _transactions;
//
//   set budget(double value) {
//     _budget = value;
//     _calculateDailyBudget(); // 예산 값이 변경되면 하루 예산을 재계산
//     notifyListeners(); // 상태가 변경되었음을 알립니다.
//   }
//
//   void setDailyBudget(double value) {
//     _dailyBudget = value;
//     // 이 곳에서 notifyListeners()를 호출하여 상태 변경을 알림
//     notifyListeners();
//   }
//
//   // 하루 예산을 계산하는 함수
//   void _calculateDailyBudget() {
//     DateTime now = DateTime.now();
//     DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
//     DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
//     int daysInMonth = lastDayOfMonth.day;
//
//     _dailyBudget = _budget / daysInMonth; // 하루 예산 계산
//     _dailySpendLeft = _dailyBudget; // 처음에는 예산이 남아있음
//     _dailySpendOver = 0; // 처음에는 초과 지출 없음
//     _safeboxBudget = 0; // 처음에는 아낀 금액 없음
//   }
//
//   // 하루 지출량 추가
//   void addDailySpend(double spendAmount) {
//     _dailySpend += spendAmount;
//     _totalSpend += spendAmount; // 총 지출에 추가
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
//     // 아낀 금액을 safebox에 더함
//     _safeboxBudget += _dailySpendLeft;
//
//     // 하루 지출 초기화
//     _dailySpend = 0;
//
//     // 하루 예산에서 지출을 뺀 남은 예산을 계산
//     _dailySpendLeft = _dailyBudget - _dailySpend;
//
//     // 초과 지출 초기화
//     if (_dailySpend > _dailyBudget) {
//       _dailySpendOver = _dailySpend - _dailyBudget; // 초과 지출 금액
//     } else {
//       _dailySpendOver = 0; // 초과 지출이 없으면 0
//     }
//
//     notifyListeners();
//   }
//
//   // 하루가 지나면 자동으로 초기화
//   void checkAndReset() {
//     DateTime now = DateTime.now();
//     // 자정이 지난 후에 resetDailySpend() 호출
//     if (now.year != _lastResetDate.year ||
//         now.month != _lastResetDate.month ||
//         now.day != _lastResetDate.day) {
//       resetDailySpend();
//       _lastResetDate = now; // 날짜 갱신
//     }
//   }
//
//   // 자정까지 남은 시간 계산
//   Duration _calculateDurationUntilMidnight() {
//     DateTime now = DateTime.now();
//     DateTime midnight = DateTime(now.year, now.month, now.day + 1);
//     return midnight.difference(now); // 자정까지 남은 시간 계산
//   }
//
//   // Timer를 사용하여 자정마다 자동으로 하루 초기화
//   void startTimer() {
//     Duration durationUntilMidnight = _calculateDurationUntilMidnight();
//     Timer.periodic(durationUntilMidnight, (timer) {
//       checkAndReset(); // 자정이 되면 checkAndReset 호출
//     });
//   }
//
//   // SharedPreferences에서 트랜잭션 로드
//   Future<void> loadTransactionsFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? transactionsJson = prefs.getString('transactions');
//     if (transactionsJson != null) {
//       Map<String, dynamic> jsonMap = jsonDecode(transactionsJson);
//       _transactions = jsonMap.map((key, value) {
//         return MapEntry(key, List<Transaction>.from(value.map((item) {
//           return Transaction(
//             amount: item['amount'],
//             category: item['category'],
//             type: item['type'],
//             date: DateTime.parse(item['date']),
//           );
//         })));
//       });
//       notifyListeners();
//     }
//   }
//
//   // 오늘 날짜에 맞는 트랜잭션을 계산하여 사용
//   double getTodayLeftSpend() {
//     DateTime today = DateTime.now();
//     String todayDate = DateFormat('yyyy-MM-dd').format(today); // 오늘 날짜 형식으로 변환
//
//     // 오늘 날짜에 해당하는 트랜잭션을 가져옴
//     List<Transaction> todayTransactions = _transactions[todayDate] ?? [];
//
//     double todayLeftSpend = 0;
//     if (todayTransactions.isNotEmpty) {
//       // 오늘 날짜에 트랜잭션이 있을 경우 지출합 계산
//       todayLeftSpend = todayTransactions.fold(0.0, (sum, transaction) {
//         return transaction.type == 'expense' ? sum + transaction.amount : sum;
//       });
//     } else {
//       // 오늘 날짜의 트랜잭션이 없다면 dailyBudget을 사용
//       todayLeftSpend = _dailyBudget;
//     }
//
//     return todayLeftSpend;
//   }
//
//   // 과거 날짜에 대한 계산 (오늘 이전의 날짜들에 대해 누적된 수입/지출 반영)
//   double getDailySpendLeftForPastDays() {
//     double pastDaysSpend = _dailyBudget; // 기본적으로 dailyBudget을 사용
//     DateTime now = DateTime.now();
//
//     // 과거 날짜 트랜잭션 계산
//     _transactions.forEach((dateKey, transactionsList) {
//       DateTime transactionDate = DateTime.parse(dateKey);
//       if (transactionDate.isBefore(now)) {
//         double dailySpendForDate = transactionsList.fold(0.0, (sum, transaction) {
//           if (transaction.type == 'expense') {
//             return sum + transaction.amount;
//           } else if (transaction.type == 'income') {
//             return sum - transaction.amount;
//           }
//           return sum;
//         });
//         pastDaysSpend += dailySpendForDate;
//       }
//     });
//
//     return pastDaysSpend;
//   }
//
//   // 트랜잭션 추가
//   void addTransaction(double amount, String category, String type) {
//     DateTime now = DateTime.now();
//     String dateKey = DateFormat('yyyy-MM-dd').format(now); // 날짜를 Key로 사용
//
//     // 트랜잭션 객체 생성
//     Transaction newTransaction = Transaction(
//       amount: amount,
//       category: category,
//       type: type,
//       date: now,
//     );
//
//     // 날짜별로 트랜잭션 리스트에 추가
//     if (_transactions.containsKey(dateKey)) {
//       _transactions[dateKey]!.add(newTransaction);
//     } else {
//       _transactions[dateKey] = [newTransaction];
//     }
//
//     // 수입/지출에 따라 계산
//     if (type == "income") {
//       _dailyPlus += amount;
//     } else if (type == "expense") {
//       _dailySpend += amount;
//       _totalSpend += amount;
//     }
//
//     _updateDailySpendStatus();
//     _printTransactions(); // 트랜잭션 출력
//     notifyListeners();
//
//     _saveTransactionsToPrefs(); // 트랜잭션을 SharedPreferences에 저장
//   }
//
//   // 트랜잭션 출력 (디버깅용)
//   void _printTransactions() {
//     _transactions.forEach((date, transactionsList) {
//       for (var transaction in transactionsList) {
//         print("Date: $date - Category: ${transaction.category}, Amount: ${transaction.amount}, Type: ${transaction.type}, Date: ${transaction.date}");
//       }
//     });
//   }
//
//   // SharedPreferences에 트랜잭션 저장
//   Future<void> _saveTransactionsToPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     String transactionsJson = jsonEncode(_transactions.map((key, value) {
//       return MapEntry(key, value.map((e) => {
//         'amount': e.amount,
//         'category': e.category,
//         'type': e.type,
//         'date': e.date.toIso8601String(),
//       }).toList());
//     }));
//
//     await prefs.setString('transactions', transactionsJson);
//   }
//
//
// }

///---------------------------------------------------------------------------------------------------------------------------------------
import 'dart:async';
import 'dart:convert';

import 'package:fincare_practice/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class BudgetModel with ChangeNotifier {
  double _budget = 0.0; // 월 예산
  double _dailyBudget = 0; // 하루 예산
  double _dailySpend = 0; // 하루 지출
  double _dailySpendLeft = 0; // 하루 예산에서 지출한 금액을 뺀 남은 금액
  double _dailySpendOver = 0; // 초과 지출 금액 (음수)
  double _totalSpend = 0; // 이번 달 총 지출
  double _safeboxBudget = 0; // 아낀 금액 (이번 달에 절약한 금액)
  double _dailyPlus = 0; // 하루 수입 (이 값은 수입을 추가하는 데 사용)

  DateTime _lastResetDate = DateTime.now(); // 마지막 초기화된 날짜

  // 트랜잭션 데이터를 날짜별로 저장
  Map<String, List<Transaction>> _transactions = {};

  double get budget => _budget;
  double get dailyBudget => _dailyBudget;
  double get dailySpend => _dailySpend;
  double get dailySpendLeft => _dailySpendLeft;
  double get dailySpendOver => _dailySpendOver;
  double get safeboxBudget => _safeboxBudget;
  double get totalSpend => _totalSpend;
  double get dailyPlus => _dailyPlus;
  DateTime get lastResetDate => _lastResetDate;
  Map<String, List<Transaction>> get transactions => _transactions;

  ///MonthExpanseCheck.dart에서 한달 총 예산인 budget값을 세팅하면, 하루 예산을 계산하여 dailyBudget(하루 총 예산)에도 값을 세팅해줌.
  set budget(double value) {
    _budget = value;
    // _calculateDailyBudget(); // 예산 값이 변경되면 하루 예산을 재계산
    _calculateDailyBudget();
    notifyListeners();
  }

    void setDailyBudget(double value) {
    _dailyBudget = value;
    // 이 곳에서 notifyListeners()를 호출하여 상태 변경을 알림
    notifyListeners();
  }

  // 하루 예산을 계산하는 함수
  void _calculateDailyBudget() {
    DateTime now = DateTime.now();
    // DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    int daysInMonth = lastDayOfMonth.day;

    _dailyBudget = _budget / daysInMonth; // 하루 예산 계산
    _dailySpendLeft = _dailyBudget; // 처음에는 예산이 남아있음
    _dailySpendOver = 0; // 처음에는 초과 지출 없음
    _safeboxBudget = 0; // 처음에는 아낀 금액 없음
  }

  void _updateDailySpendStatus() {
    if (_dailySpend > _dailyBudget) {
      _dailySpendOver = _dailySpend - _dailyBudget; // 초과 지출
      _dailySpendLeft = 0; // 남은 예산 없음
    } else {
      _dailySpendLeft = _dailyBudget - _dailySpend; // 남은 예산 계산
      _dailySpendOver = 0; // 초과 지출 없음
    }
  }

  // 오늘 날짜에 맞는 트랜잭션을 계산하여 사용
  // double getTodayLeftSpend() {
  //   DateTime today = DateTime.now();
  //   String todayDate = DateFormat('yyyy-MM-dd').format(today); // 오늘 날짜 형식으로 변환
  //
  //   // 오늘 날짜에 해당하는 트랜잭션을 가져옴
  //   List<Transaction> todayTransactions = _transactions[todayDate] ?? [];
  //
  //   double todayLeftSpend = 0;
  //   if (todayTransactions.isNotEmpty) {
  //     // 오늘 날짜에 트랜잭션이 있을 경우 지출합 계산
  //     todayLeftSpend = todayTransactions.fold(0.0, (sum, transaction) {
  //       // 수입은 더하고, 지출은 빼기
  //       if (transaction.type == 'expense') {
  //         return sum + transaction.amount; // 지출이 있을 경우 더함
  //       } else if (transaction.type == 'income') {
  //         return sum - transaction.amount; // 수입이 있을 경우 뺌
  //       }
  //       return sum;
  //     });
  //   } else {
  //     // 오늘 날짜의 트랜잭션이 없다면 dailyBudget을 사용
  //     todayLeftSpend = _dailyBudget;
  //   }
  //
  //   return todayLeftSpend;
  // }


  // 트랜잭션 추가
  void addTransaction(double amount, String category, String type) {
    DateTime now = DateTime.now();
    String dateKey = DateFormat('yyyy-MM-dd').format(now); // 날짜를 Key로 사용

    // 트랜잭션 객체 생성
    Transaction newTransaction = Transaction(
      amount: amount,
      category: category,
      type: type,
      date: now,
    );

    // 날짜별로 트랜잭션 리스트에 추가
    if (_transactions.containsKey(dateKey)) {
      _transactions[dateKey]!.add(newTransaction);
    } else {
      _transactions[dateKey] = [newTransaction];
    }

    // 수입/지출에 따라 계산
    if (type == "income") {
      _dailyPlus += amount; // 수입이면 dailyPlus에 추가
    } else if (type == "expense") {
      _dailySpend += amount; // 지출이면 dailySpend에 추가
      _totalSpend += amount; // 총 지출에 반영
    }


    _updateDailySpendStatus(); // 하루 지출 상태 업데이트
    _printTransactions(); // 트랜잭션 출력
    notifyListeners();

    // _saveTransactionsToPrefs(); // 트랜잭션을 SharedPreferences에 저장
  }

  // 트랜잭션 출력 (디버깅용)
  void _printTransactions() {
    _transactions.forEach((date, transactionsList) {
      for (var transaction in transactionsList) {
        print("Date: $date - Category: ${transaction.category}, Amount: ${transaction.amount}, Type: ${transaction.type}, Date: ${transaction.date}");

      }
      print("dailySpend : ${dailySpend} , totalSpend : ${totalSpend} , dailyPlus:${dailyPlus} , dailySpendLeft : ${dailySpendLeft} , dailySpendOver : ${dailySpendOver}");
    });
  }

  // SharedPreferences에 트랜잭션 저장
  // Future<void> _saveTransactionsToPrefs() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String transactionsJson = jsonEncode(_transactions.map((key, value) {
  //     return MapEntry(key, value.map((e) => {
  //       'amount': e.amount,
  //       'category': e.category,
  //       'type': e.type,
  //       'date': e.date.toIso8601String(),
  //     }).toList());
  //   }));
  //
  //   await prefs.setString('transactions', transactionsJson);
  // }
}
