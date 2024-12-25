import 'package:fincare_practice/Component/Table_Setting_component/CustomTableCalendar.dart';
import 'package:fincare_practice/Component/Table_Setting_component/today_budget_banner.dart';
import 'package:fincare_practice/const/color.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarSetting extends StatefulWidget {
  const CalendarSetting({super.key});

  @override
  State<CalendarSetting> createState() => _CalendarSettingState();
}

class _CalendarSettingState extends State<CalendarSetting> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        Customtablecalendar(
          focusedDay: DateTime.now(),
          onDaySelected: onDaySelected,
          selectedDayPredicate: selectedDayPredicate,
        ),
        TodayBudgetBanner(
          selectedDay: selectedDay,
          taskCount: 0,
        ),
        Expanded(
            child: ListView(
              children: [
                Container(
                  child: Row(
                    children: [
                      Text('시간'), // 여기다가 날짜 시간넣고
                      Text('내용'), // 금액은 얼마이고 수입인지 지출인지
                      Text('색상'), // 카테고리및 아이콘 넣고
                    ],
                  ),
                )
              ],
            ),
        ),
      ]
      ),
    )
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    /// onDaySelected는 함수인데, 매개변수로 selectedDay 선택된 날짜 /  focusedDay 포커스된 날짜를 파라미터로
    setState(() {
      this.selectedDay = selectedDay;
    });
  }

  bool selectedDayPredicate(DateTime date) {
    if (selectedDay == null) {
      return false;
    }
    return date.isAtSameMomentAs(selectedDay!);
  }
}
