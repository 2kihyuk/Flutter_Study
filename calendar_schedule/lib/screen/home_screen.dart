import 'package:calendar_schedule/component/calendar.dart';
import 'package:calendar_schedule/component/custom_text_field.dart';
import 'package:calendar_schedule/component/schedule_bottom_sheet.dart';
import 'package:calendar_schedule/component/schedule_card.dart';
import 'package:calendar_schedule/component/today_banner.dart';
import 'package:calendar_schedule/const/color.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/schedule.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime
        .now()
        .year,
    DateTime
        .now()
        .month,
    DateTime
        .now()
        .day,
  );

  ///{
  /// 2023-11-23: [Schedule,Schdule],
  /// 2023-11-24: [Schedule,Schedule]
  /// }
  Map<DateTime, List<Schedule>> schedules = {
    DateTime.utc(2024, 12, 12): [
      Schedule(
        id: 1,
        startTime: 11,
        endTime: 12,
        content: '플러터 공부하기',
        date: DateTime.utc(2024, 12, 12),
        color: categoryColors[0],
        createdAt: DateTime.now().toUtc(),
      ),
      Schedule(
        id: 2,
        startTime: 14,
        endTime: 16,
        content: 'NextJS 공부하기',
        date: DateTime.utc(2024, 12, 12),
        color: categoryColors[3],
        createdAt: DateTime.now().toUtc(),
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return ScheduleBottomSheet();
            },
          );
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              focusedDay: DateTime(2024, 12, 9),
              onDaySelected: onDaySelected,
              selectedDayPredicate: SelectedDayPredicate,
            ),
            TodayBanner(
              selectedDay: selectedDay,
              taskCount: 0,
            ),
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: ListView.separated(
                  itemCount: schedules.containsKey(selectedDay)
                      ? schedules[selectedDay]!.length : 0,
                  //itemBuilder는 몇개의 데이터를 넣어줄거냐? itemCOunt속성
                  itemBuilder: (BuildContext context, int index) { //index는 순서

                    //선택된 날짜에 해당되는 일정 리스트로 저장
                    final selectedSchedules = schedules[selectedDay]!;
                    final scheduleModel = selectedSchedules[index];
                    return ScheduleCard(
                      startTime: scheduleModel.startTime,
                      endTime: scheduleModel.endTime,
                      content: scheduleModel.content,
                      color: Color(
                        int.parse(
                          'FF${scheduleModel.color}',
                          radix: 16
                        )
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index){
                    return SizedBox(height: 16.0);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
    });
  }

  bool SelectedDayPredicate(DateTime date) {
    if (selectedDay == null) {
      return false;
    }
    return date.isAtSameMomentAs(selectedDay!);
  }
}

// children: schedules.containsKey(selectedDay)
// ? schedules[selectedDay]!
//     .map((e) => ScheduleCard(
// startTime: e.startTime,
// endTime: e.endTime,
// content: e.content,
// color: Color(
// int.parse('FF${e.color}', radix: 16),
// ),
// ))
// .toList()
// : [],
