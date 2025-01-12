import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ready_project/auth/component/amount_input_field.dart';
import 'package:ready_project/common/layout/default_layout.dart';

import '../component/custom_text_form_field.dart';
import '../../common/const/colors.dart';
import '../../common/const/data.dart';
import 'login_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  String userId = '';
  String password = '';
  String userName = '';
  DateTime? birthDate;

  Future<void> selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthDate = picked; // 선택한 날짜를 변수에 저장
      });
      print(birthDate);
    }
  }
  final TextEditingController monthTotalIncomeController = TextEditingController();
  final TextEditingController monthFixedExpanseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    return DefaultLayout(
      child: SingleChildScrollView(
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // _Title(),
                SizedBox(
                  height: 16.0,
                ),
                // _SubTitle(),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요.',
                  // errorText: '에러가 있습니다.',
                  onChanged: (String value) {
                    userId = value;
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  // errorText: '에러가 있습니다.',
                  obscureText: true,
                  onChanged: (String value) {
                    password = value;
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                CustomTextFormField(
                  hintText: '이름을 입력해주세요.',
                  // errorText: '에러가 있습니다.',
                  onChanged: (String value) {
                    userName = value;
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                GestureDetector(
                  onTap: () => selectBirthday(context),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.blue),
                        // 캘린더 아이콘
                        SizedBox(width: 8),
                        Text(
                          birthDate == null
                              ? '생년월일을 선택해주세요'
                              : '${birthDate!.toLocal()}'.split(' ')[0],
                          // 선택된 날짜
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                AmountInputField(
                  controller: monthTotalIncomeController,
                  hintText: '한 달 총 수입액을 입력해주세요.',
                ),
                SizedBox(
                  height: 16.0,
                ),
                AmountInputField(
                  controller: monthFixedExpanseController,
                  hintText: '한 달 총 수입액을 입력해주세요.',
                ),

                SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: () async {

                    double monthTotalIncome = double.tryParse(monthTotalIncomeController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0; //한달 총 수입액
                    double monthFixedExpanse = double.tryParse(monthFixedExpanseController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0; // 한달 고정 지출액


                    final Map<String, dynamic> loginData = {
                      'userId': userId,
                      'password': password,
                      'userName': userName,
                      'birthDate' : birthDate!.toIso8601String(),
                      'monthTotalIncome': monthTotalIncome,
                      'monthFixedExpanse': monthFixedExpanse,

                    };

                    final resp = await dio.post(
                      'http://$ip/auth/login',
                      options: Options(headers: {
                        'Content-Type': 'application/json',
                      }),
                      data: jsonEncode(loginData),
                    );

                    if (resp.statusCode == 200) {
                      final jwtToken = resp.data['token'];
                      await storage.write(key: JWT_TOKEN, value: jwtToken);

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                          (route) => false);
                      print(jwtToken);
                    } else {
                      print(resp.statusCode);
                      print('로그인 실패');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
