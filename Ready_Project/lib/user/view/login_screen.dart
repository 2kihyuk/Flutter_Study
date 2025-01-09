import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ready_project/common/const/data.dart';

import '../../common/component/custom_text_form_field.dart';
import '../../common/const/colors.dart';
import '../../common/layout/default_layout.dart';
import '../../common/view/root_tab.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userName = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    return DefaultLayout(
        child: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Title(),
              SizedBox(
                height: 16.0,
              ),
              _SubTitle(),
              CustomTextFormField(
                hintText: '이메일을 입력해주세요.',
                // errorText: '에러가 있습니다.',
                onChanged: (String value) {
                  userName = value;
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
              ElevatedButton(
                onPressed: () async {
                  final Map<String, String> loginData = {
                    'username': userName,
                    'password': password,
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
                        MaterialPageRoute(builder: (_) => RootTab()),
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
              TextButton(
                onPressed: () async {
                  final Map<String, String> authData = {
                    'username': userName,
                    'password': password,
                  };

                  try {
                    final resp = await dio.post('http://$ip/auth/register',
                        options: Options(
                          headers: {
                            'Content-Type': 'application/json',
                          },
                        ),
                        data: jsonEncode(authData));

                    if (resp.statusCode == 200) {
                      print('회원가입 성공!');

                      ///회원가입 성공 했다는 모달 하나 띄워주기.
                    }
                  } catch (e) {
                    print('로그인 오류: $e');
                  }
                },
                child: Text(
                  '회원가입',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '부자가 되는 첫 걸음!\nFincare로 시작해보세요.',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요 :)',
      style: TextStyle(fontSize: 16, color: BODY_TEXT_COLOR),
    );
  }
}
