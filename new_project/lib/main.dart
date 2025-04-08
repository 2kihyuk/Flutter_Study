import 'package:flutter/material.dart';
import 'package:new_project/user/view/login_screen.dart';
import 'package:new_project/common/view/root_tab.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomeScreen(),
    )
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}
