import 'package:flutter/material.dart';
import 'package:ready_project/AIServiceScreen/view/ai_chat_screen.dart';
import 'package:ready_project/Calendar/view/Calendar_main.dart';
import 'package:ready_project/ProfileSetting/view/setting_screen.dart';
import 'package:ready_project/start_budget_management/view/start_budget_management.dart';

import '../../Calendar/view/Calendar.dart';
import '../../Notification/Flutter_Notification.dart';
import '../const/colors.dart';
import '../layout/default_layout.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(
      length: 4,
      vsync: this,
    );
    controller.addListener(tapListener);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.removeListener(tapListener);
    super.dispose();
  }
  void tapListener(){
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(

      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          StartBudgetManagement(),
          CalendarMain(),
          AiChatScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        // selectedItemColor: PRIMARY_COLOR,
        // unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined), label: '예산'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), label: 'AI서비스'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: '프로필'),
        ],
      ),
    );
  }
}
