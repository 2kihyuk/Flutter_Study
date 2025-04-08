import 'package:flutter/material.dart';
import 'package:new_project/common/layout/default_layout.dart';

class AddFriendScreen extends StatelessWidget {
  const AddFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      titleText: '친구추가화면',
      IsaddButton: false,

      child: Center(child: Text('친구 추가 화면')),
    );
  }
}
