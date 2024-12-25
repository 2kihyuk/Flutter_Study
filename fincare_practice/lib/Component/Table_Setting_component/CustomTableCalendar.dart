import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../const/color.dart';

class Customtablecalendar extends StatelessWidget {

  final DateTime focusedDay;
  final OnDaySelected? onDaySelected;
  final bool Function(DateTime day) selectedDayPredicate;

  const Customtablecalendar({
    required this.focusedDay,
    required this.onDaySelected,
    required this.selectedDayPredicate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {


    final defaultBoxDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1.0,
        )
    );

    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: focusedDay,
      firstDay: DateTime.utc(2024,1,1),
      lastDay: DateTime.utc(2099,12,31),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
        ),
      ),

      calendarStyle: CalendarStyle(
          isTodayHighlighted: true, //오늘 날짜에 하이라이트 줄거냐
          defaultDecoration: defaultBoxDecoration,
          weekendDecoration: defaultBoxDecoration,
          selectedDecoration: defaultBoxDecoration.copyWith(
              border: Border.all(
                color: primaryColor,
                width: 1.0,
              )
          ),
          todayDecoration: defaultBoxDecoration.copyWith(
            color: primaryColor,
          ),
          outsideDecoration: defaultBoxDecoration.copyWith(
              border: Border.all(
                color: Colors.transparent,
              )
          ),
          defaultTextStyle: defaultTextStyle,
          weekendTextStyle: defaultTextStyle,
          selectedTextStyle: defaultTextStyle.copyWith(
            color: primaryColor,
          )
      ),
      onDaySelected: onDaySelected,
      ///bool형태의 함수인데 , 선택된날짜를 마킹된 형태로 표시하고 싶다면 true
      selectedDayPredicate: selectedDayPredicate,
    );
  }
}
