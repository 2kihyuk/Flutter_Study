import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../friend/view/friend_list_screen.dart';
import '../../map/view/map_screen.dart';
import '../../profile/view/profile_screen.dart';
import '../../user/data/user_data.dart';
import '../layout/default_layout.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  int index = 0;
  late TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(tapListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.removeListener(tapListener);
  }

  void tapListener() {
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
          MapScreen(),
          FriendListScreen(),
          ProfileScreen(user:
            User(user_Name: '이기혁', user_ID: 'kihyuk5566', user_Number: '010-2930-1504', isUserIsMe: true),) //여기에 user에 대한 프로퍼티가 들어가야함. 그래서 로그인 하고나서 User클래스의 user 인스턴스를 Root_Tab에서 받아서 여기에는 로그인한 사용자 나 자신의 데이터.
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: '친구'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
        ), IsaddButton: false,
    );
  }
}
