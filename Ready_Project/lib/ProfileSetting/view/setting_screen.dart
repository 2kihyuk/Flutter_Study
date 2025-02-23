import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../../Notification/Flutter_Notification.dart';

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

    FlutterLocalNotification.init();
    _loadNotificationSetting();
    // FlutterLocalNotification.init();
    super.initState();
  }

  _loadNotificationSetting() async {
    final storage = FlutterSecureStorage();
    String? notificationsEnabled = await storage.read(key: 'notificationsEnabled');
    print("${notificationsEnabled}");
    setState(() {
      _isNotificationEnabled = notificationsEnabled == 'true';
    });
  }

  // 알림 설정을 flutter_secure_storage에 저장
  _saveNotificationSetting(bool value) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'notificationsEnabled', value: value ? 'true' : 'false');
    if (value) {
      FlutterLocalNotification.requestNotificationPermission();
      FlutterLocalNotification.scheduleDailyNotification();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('설정'),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('닉네임 변경하기'),
            subtitle: TextField(
              controller: _usernameController,
              decoration: InputDecoration(hintText: '변경할 닉네임을 작성해주세요.'),
            ),
          ),
          SwitchListTile(
            title: Text('알림 설정'),
            value: _isNotificationEnabled,
            onChanged: (bool value) {
              setState(() {
                _isNotificationEnabled = value;
              });
              _saveNotificationSetting(value);
            },
          ),
          ElevatedButton(
            onPressed: (){
              FlutterLocalNotification.showNotification();
            },
            child: Text('알림 버튼'),
          ),
          ElevatedButton(
            onPressed: () {

              // FlutterLocalNotification.scheduledNotification();
              print("Schedule함수 호출");
            },
            child: Text('Save Settings'),
          ),
        ],
      ),
    );
  }
}