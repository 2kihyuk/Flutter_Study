import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ready_project/common/const/data.dart';
import 'package:ready_project/common/layout/default_layout.dart';

class StartBudgetManagement extends StatefulWidget {
  const StartBudgetManagement({super.key});

  @override
  State<StartBudgetManagement> createState() => _StartBudgetManagementState();
}

///qqq@naver.com / test

class _StartBudgetManagementState extends State<StartBudgetManagement> {

  final dio =Dio();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  double month_budget = 0.0;  // 초기값을 0.0으로 설정
  double daily_budget = 0.0;  // 초기값을 0.0으로 설정
  String birthDate = "";
  String name = "";

  Future<void> _getUserData() async{
    final token = await storage.read(key: JWT_TOKEN);

    final resp = await dio.get(
      'http://$ip/user-info',
      options: Options(
        headers: {
          'Authorization' : 'Bearer $token',
        }
      )
    );
    if(resp.statusCode == 200){
      print(resp.data);
      setState(() {
        month_budget = resp.data['monthBudget'] ?? 0.0;  // null이거나 없을 경우 0.0 설정
        daily_budget = resp.data['dailyBudget'] ?? 0.0;  // null이거나 없을 경우 0.0 설정
        birthDate = resp.data['birthDate'];
        name = resp.data['name'];
      });
    }else{
      print('StartBudgetManagement _getUserData Data Get Error');
    }
  }

  //이름, 생년월일, month_budget , daily_budget
  @override
  initState(){
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          children:[
            Text('월 예산: ${month_budget.toString()}'),
            Text('하루 예산: ${daily_budget.toString()}'),
            Text('이름: ${name}'),
            Text('생년월일: ${birthDate.substring(0,10)}'),
          ],

        ),
      ),
    );
  }
}


///kihyuk5566@naver.com 1234