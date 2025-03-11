import 'package:flutter/material.dart';
import 'package:ready_project/common/layout/default_layout.dart';

class ThisMonthAnalyze extends StatelessWidget {
  final String prompt;
  const ThisMonthAnalyze({required this.prompt,super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '이번 달 소비패턴 분석하기',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('${prompt}'),
        ],
      ),
    );
  }
}
