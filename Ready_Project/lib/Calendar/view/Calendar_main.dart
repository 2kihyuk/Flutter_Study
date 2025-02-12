import 'package:flutter/material.dart';
import 'package:ready_project/common/layout/default_layout.dart';
import 'package:ready_project/Calendar/view/Calendar.dart';

class CalendarMain extends StatelessWidget {
  const CalendarMain({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(

      child:Calendar(),
    );
  }
}
