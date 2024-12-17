import 'package:calendar_schedule/component/calendar.dart';
import 'package:calendar_schedule/component/custom_text_field.dart';
import 'package:calendar_schedule/component/schedule_bottom_sheet.dart';
import 'package:calendar_schedule/component/schedule_card.dart';
import 'package:calendar_schedule/component/today_banner.dart';
import 'package:calendar_schedule/const/color.dart';
import 'package:calendar_schedule/database/drift.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/schedule.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  ///{
  /// 2023-11-23: [Schedule,Schdule],
  /// 2023-11-24: [Schedule,Schedule]
  /// }
  // Map<DateTime, List<ScheduleTable>> schedules = {
  //   DateTime.utc(2024, 12, 12): [
  //     ScheduleTable(
  //       id: 1,
  //       startTime: 11,
  //       endTime: 12,
  //       content: '플러터 공부하기',
  //       date: DateTime.utc(2024, 12, 12),
  //       color: categoryColors[0],
  //       createdAt: DateTime.now().toUtc(),
  //     ),
  //     ScheduleTable(
  //       id: 2,
  //       startTime: 14,
  //       endTime: 16,
  //       content: 'NextJS 공부하기',
  //       date: DateTime.utc(2024, 12, 12),
  //       color: categoryColors[3],
  //       createdAt: DateTime.now().toUtc(),
  //     ),
  //   ],
  // };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final schedule = await showModalBottomSheet<ScheduleTable>(
            context: context,
            builder: (_) {
              return ScheduleBottomSheet(selectedDay: selectedDay);
            },
          );

          setState(() {

          });

          // final dateExists = schedules.containsKey(schedule.date);
          //
          // final List<ScheduleTable> existingSchdules = dateExists ? schedules[schedule.date]! : [];
          //
          // ///[Schedule1 , Schedule2]
          // ///[Schedule2]
          // existingSchdules.add(schedule);

          // setState(() {
          //   schedules = {
          //     ...schedules,
          //     schedule.date : existingSchdules,
          //   };
          // });
          //
          // setState(() {
          //   schedules = {
          //     ...schedules,
          //     schedule.date: [
          //       if(schedules.containsKey(schedule.date))
          //         ...schedules[schedule.date]!,
          //       schedule,
          //     ]
          //   };
          // });
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
                child: FutureBuilder<List<ScheduleTableData>>(
                    future: GetIt.I<AppDatabase>().getSchedules(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                          ),
                        );
                      }

                      if (!snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final schedules = snapshot.data!;

                      final selectedSchedules = schedules
                          .where(
                            (e) => e.date.isAtSameMomentAs(selectedDay),
                          )
                          .toList();

                      return ListView.separated(
                        itemCount: selectedSchedules.length,
                        /*schedules.containsKey(selectedDay)
                          ? schedules[selectedDay]!.length : 0,*/
                        //itemBuilder는 몇개의 데이터를 넣어줄냐? itemCOunt속성
                        itemBuilder: (BuildContext context, int index) {
                          //index는 순서
                          final schedule = selectedSchedules[index];
                          //선택된 날짜에 해당되는 일정 리스트로 저장
                          // final selectedSchedules = schedules[selectedDay]!;
                          // final scheduleModel = selectedSchedules[index];
                          return ScheduleCard(
                            startTime: schedule.startTime,
                            endTime: schedule.endTime,
                            content: schedule.content,
                            color: Color(
                                int.parse('FF${schedule.color}', radix: 16)),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 16.0);
                        },
                      );
                    }),
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

///RAM은 빠르지만 데이터의 휘발성이 높다.
///Random Access Memory.
///빠르기 때문에 쓴다.
///
/// HDD/ SSD는 느리지만 장기적으로 데이터를 유지할 수 있다.
/// 두 종류의 저장메모리가 존재하는 이유...
///
/// 실행하고있는 것들만 RAM에다 올려서 쓰고 장기적으로 저장해야하는 데이터는 HDD/SSD에 올린다.
///
/// SQL을 이용해서 데이터를 HDD에 장기적으로 저장하고, 불러와서..
///
/// Sturctured Query Language
///
/// Drift
///
///
