import 'package:fincare_practice/Component/Table_Setting_component/CustomTableCalendar.dart';
import 'package:fincare_practice/Component/Table_Setting_component/today_banner.dart';
import 'package:fincare_practice/Component/Table_Setting_component/today_budget_banner.dart';
import 'package:fincare_practice/const/color.dart';
import 'package:flutter/material.dart';



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

        ),
        TodayBanner(selectedDay: selectedDay,),

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

//
// Expanded(
// child: ListView( //ListView.builder로 수정해주면 되는데, 조건은 날짜를 통해서 렌더링해주면됨. 백엔드나 내부 저장소에 날짜별로 트랜잭션 데이터 넣어 두었으니까 , builder사용할때
// //그날짜에 해당하는 데이터들만 가지고와서 리스트뷰에 렌더링.
// padding: EdgeInsets.all(16.0),
// children: [
// Container(
// padding: EdgeInsets.all(16.0),
// margin: EdgeInsets.symmetric(vertical: 8.0),
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(12),
// border: Border.all(color: Colors.grey),
// ),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// // 시간
// Text(
// ' ${Provider.of<BudgetModel>(context,listen: false).transactions}',
// style: TextStyle(fontFamily: 'Pretendard',fontWeight: FontWeight.bold),
// ),
// // 내용 (금액과 수입/지출)
// Column(
// crossAxisAlignment: CrossAxisAlignment.end,
// children: [
// Text(
// '₩ 10,000',
// style: TextStyle(fontFamily: 'Pretendard',fontWeight: FontWeight.bold),
// ),
// Text('수입'),
// ],
// ),
// // 카테고리 및 아이콘
// Column(
// crossAxisAlignment: CrossAxisAlignment.end,
// children: [
// Icon(Icons.shopping_cart, color: Colors.blue),
// Text('쇼핑'),
// ],
// ),
// ],
// ),
// ),
// ],
// ),
// ),