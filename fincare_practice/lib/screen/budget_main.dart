import 'package:fincare_practice/Component/end_spend.dart';
import 'package:fincare_practice/Component/safebox.dart';
import 'package:fincare_practice/Component/savebutton.dart';
import 'package:flutter/material.dart';

class BudgetMain extends StatelessWidget {
  const BudgetMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [


            Safebox(),
            EndSpend(),
            Savebutton(content: '저장하기',),
            SizedBox(height: 16.0,),
            Savebutton(content: '이메일로 시작하기')

          ],
        ),
      ),
    );
  }
}
