import 'package:flutter/material.dart';
import 'package:ready_project/common/layout/default_layout.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarMain extends StatelessWidget {
  const CalendarMain({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      child: Container(
        child: Column(
          children: [
            TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime.utc(2000,01,01),
              lastDay: DateTime.utc(2099,12,31),
            ),
          ],
        ),
      ),
    );
  }
}
