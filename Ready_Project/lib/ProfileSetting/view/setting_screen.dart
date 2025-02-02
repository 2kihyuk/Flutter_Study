import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationEnabled = false;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _monthBudgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('설정')),
      body: ListView(
        children: [
          ListTile(
            title: Text('닉네임 변경하기'),
            subtitle: TextField(
              controller: _usernameController,
              decoration: InputDecoration(hintText: '변경할 닉네임을 작성해주세요.'),
            ),
          ),
          ListTile(
              title: Text('한달 총 수익 변경하기'),
              subtitle:
              TextField(
                controller: _monthBudgetController,
                decoration: InputDecoration(hintText: '현재 한 달 총 수익은 3,300,000원 입니다.'),
              )
          ),
          ListTile(
              title: Text('한달 고정 지출액 변경하기'),
              subtitle:
              TextField(
                controller: _monthBudgetController,
                decoration: InputDecoration(hintText: '현재 한 달 고정 지출액은 300,000원 입니다.'),
              )
          ),

          SwitchListTile(
            title: Text('알림 설정'),
            value: _isNotificationEnabled,
            onChanged: (bool value) {
              setState(() {
                _isNotificationEnabled = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Save Settings'),
          ),
        ],
      ),
    );
  }
}
