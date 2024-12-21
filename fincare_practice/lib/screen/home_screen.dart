import 'package:fincare_practice/Component/this_week_emotion.dart';
import 'package:fincare_practice/screen/authentication_start.dart';
import 'package:fincare_practice/screen/budget_main.dart';
import 'package:fincare_practice/screen/calendar_Setting.dart';
import 'package:fincare_practice/screen/custombottomnavigationbar.dart';
import 'package:fincare_practice/screen/login_page.dart';
import 'package:fincare_practice/screen/my_setting.dart';
import 'package:fincare_practice/screen/notification_setting.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // 화면 전환을 위한 List
  final List<Widget> _screens = [
    BudgetMain(),
    CalendarSetting(),
    NotificationSetting(),
    AuthenticationStart(),

    // LoginPage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: Custombottomnavigationbar(
          selectedIndex: _selectedIndex,
          onItemTapped: onItemTapped,
        ),

    );
  }



}


