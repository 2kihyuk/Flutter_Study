class TotalModel {
  double monthly_expense_total;
  double monthly_income_total;
  final Map<String, double> category_expenses;

  TotalModel({
    required this.monthly_expense_total,
    required this.monthly_income_total,
    required this.category_expenses
  });

  factory TotalModel.fromJson(Map<String, dynamic> json) {
    return TotalModel(
      monthly_expense_total: (json['monthly_expense_total'] ?? 0).toDouble(),
      monthly_income_total: (json['monthly_income_total'] ?? 0).toDouble(),
      category_expenses: (json['category_expenses'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, (value ?? 0).toDouble())),
    );
  }

}

class LastMonthTotalModel {
  int year;
  int month;
  double last_month_expense_total;
  double last_month_income_total;
  final Map<String, double> last_month_category_expenses;

  LastMonthTotalModel({
    required this.year,
    required this.month,
    required this.last_month_expense_total,
    required this.last_month_income_total,
    required this.last_month_category_expenses,
  });

  factory LastMonthTotalModel.fromJson(Map<String, dynamic> json){
    return LastMonthTotalModel(
      year : (json['year']),
      month: (json['month']),
      last_month_expense_total: (json['last_month_expense_total']),
      last_month_income_total: (json['last_month_income_total']),
      last_month_category_expenses: (json['category_expenses'] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, (value ?? 0).toDouble())),
    );
  }
}