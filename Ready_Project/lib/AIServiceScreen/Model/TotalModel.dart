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