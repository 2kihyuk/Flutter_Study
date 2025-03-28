import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lv2_actual/common/const/colors.dart';
import 'package:lv2_actual/common/const/data.dart';
import 'package:lv2_actual/common/layout/default_layout.dart';
import 'package:lv2_actual/common/secure_storage/secure_storage.dart';
import 'package:lv2_actual/common/view/root_tab.dart';

import '../../common/component/custom_text_form_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
              Image.asset(
                'asset/img/misc/logo.png',
                width: MediaQuery.of(context).size.width / 3 * 2,
              ),
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
                  final rawString = '$userName:$password';
                  print(rawString);

                  Codec<String, String> stringToBase64 = utf8.fuse(base64);
                  String token = stringToBase64.encode(rawString);

                  final resp = await dio.post(
                    'http://$ip/auth/login',
                    options: Options(
                      headers: {
                        'Authorization': 'Basic $token',

                      },

                    ),
                  );

                  final refreshToken = resp.data['refreshToken'];
                  final accessToken = resp.data['accessToken'];
                  final storage = ref.read(secureStorageProvider);
                  
                  await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                  await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
                  print(accessToken);


                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RootTab(),
                    ),
                  );
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
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
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
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n 오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(fontSize: 16, color: BODY_TEXT_COLOR),
    );
  }
}
