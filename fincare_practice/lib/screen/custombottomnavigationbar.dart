import 'package:flutter/material.dart';

class Custombottomnavigationbar extends StatelessWidget {
  final int  selectedIndex;
  final Function(int) onItemTapped;


  const Custombottomnavigationbar({
    required this.selectedIndex,
    required this.onItemTapped,
    super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

      backgroundColor: Colors.blue,
      selectedItemColor: Colors.white, // 선택된 아이템 색

      type: BottomNavigationBarType.fixed, // 타입을 fixed로 설정
      currentIndex: selectedIndex,
      onTap: onItemTapped,

      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: '예산',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: '설정',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: '로그인세팅',
        ),
      ],
    );
  }
}
