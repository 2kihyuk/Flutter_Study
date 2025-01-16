// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetModel _$BudgetModelFromJson(Map<String, dynamic> json) => BudgetModel(
      month_budget: (json['month_budget'] as num).toDouble(),
      daily_budget: (json['daily_budget'] as num).toDouble(),
    );

Map<String, dynamic> _$BudgetModelToJson(BudgetModel instance) =>
    <String, dynamic>{
      'month_budget': instance.month_budget,
      'daily_budget': instance.daily_budget,
    };
