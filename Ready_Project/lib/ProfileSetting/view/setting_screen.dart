import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:ready_project/ProfileSetting/view/change_information.dart';
import 'package:ready_project/auth/view/login_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../../Notification/Flutter_Notification.dart';
import '../../common/const/data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationEnabled = false;

  String username = "";
  String birthDate = "";
  TextEditingController _usernameController = TextEditingController();


  // TextEditingController _monthBudgetController = TextEditingController();

  @override
  void initState() {
    FlutterLocalNotification.init();
    _loadNotificationSetting();
    getLoadData();
    super.initState();
  }

  _loadNotificationSetting() async {
    final storage = FlutterSecureStorage();
    String? notificationsEnabled =
    await storage.read(key: 'notificationsEnabled');
    print("${notificationsEnabled}");
    setState(() {
      _isNotificationEnabled = notificationsEnabled == 'true';
    });
  }

  // 알림 설정을 flutter_secure_storage에 저장
  _saveNotificationSetting(bool value) async {
    final storage = FlutterSecureStorage();
    await storage.write(
        key: 'notificationsEnabled', value: value ? 'true' : 'false');
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
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 50, // 프로필 이미지 크기
                backgroundColor: Colors.grey[300], // 배경색
                child: Icon(
                  Icons.person, // 사람 아이콘
                  size: 50,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 24.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$username님'),
                  Text('생년 월일 : $birthDate'),
                ],
              )
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ChangeInformation())
              );
            },
            child: Text('비밀번호 변경하기'),
          ),
          Divider(),
          Text(
            '개인정보 보호 및 공유',
            style: TextStyle(fontSize: 20.0),
          ),
          OutlinedButton(
            onPressed: () {

            },
            child: Text('계정 삭제하기'),
          ),
          Divider(),
          Text(
            '지원',
            style: TextStyle(fontSize: 20.0),
          ),
          OutlinedButton(
            onPressed: () {

            },
            child: Text('피드백 남기기'),
          ),
          Divider(),
          Text(
            '법률',
            style: TextStyle(fontSize: 20.0),
          ),
          OutlinedButton(
            onPressed: () {

            },
            child: Text('이용 약관'),
          ),
          OutlinedButton(
            onPressed: () {

            },
            child: Text('개인정보 처리방침'),
          ),
          OutlinedButton(
            onPressed: () {

            },
            child: Text('회사 세부정보'),
          ),

          TextButton(
            onPressed: () {
              LogOut();
            },
            child: Text('로그아웃'),
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
            onPressed: () {
              FlutterLocalNotification.showNotification();
            },
            child: Text('알림 버튼'),
          ),

        ],
      ),
    );
  }

  Future<void> LogOut() async {
    final dio = Dio();
    final storage = FlutterSecureStorage();

    final token = await storage.read(key: JWT_TOKEN);

    try {
      final response = await dio.post(
        'http://$ip/auth/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        print("SettingScreen : LogOut : ${response.data}");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false);
      } else {
        print('API 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: SettingScreen - LogOut -  $e');
    }
  }

  Future<void> getLoadData() async {
    final dio = Dio();
    final storage = FlutterSecureStorage();

    final token = await storage.read(key: JWT_TOKEN);

    try {
      final response = await dio.get(
        'http://$ip/user-info',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        print("IncomeOrExpense : GetLoadData : ${response.data}");
        setState(() {
          username = response.data['name'];
          birthDate = response.data['birthDate'].toString().split('T')[0];
        });
      } else {
        print('API 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: IncomeOrExpense - getLoadData -  $e');
    }
  }
}
