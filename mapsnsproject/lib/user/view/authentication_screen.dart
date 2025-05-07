import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/component/custom_text_form_field.dart';
import '../../common/const/colors.dart';
import '../../common/layout/default_layout.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  String userName = '';
  String password = '';
  String passwordCheck = '';
  String userId = '';
  String userNumber = '';

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      titleText: '회원가입',
      child: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextFormField(
                  hintText: '이름을 입력해주세요.',
                  // errorText: '에러가 있습니다.',
                  onChanged: (String value) {
                    userName = value;
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  hintText: 'ID를 입력해주세요.',
                  // errorText: '에러가 있습니다.',
                  onChanged: (String value) {
                    userId = value;
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  hintText: '전화번호를 입력해주세요.',
                  // errorText: '에러가 있습니다.',
                  onChanged: (String value) {
                    userNumber = value;
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  // errorText: '에러가 있습니다.',
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  hintText: '비밀번호를 다시 입력해주세요.',
                  // errorText: '에러가 있습니다.',
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {
                      passwordCheck = value;
                    });
                  },
                ),
                SizedBox(height: 8),
                Text(
                  password != passwordCheck
                      ? '비밀번호가 일치하지 않습니다. 다시 입력해주세요.'
                      : '비밀번호가 일치합니다.',
                ),
                SizedBox(height: 28.0),
                ElevatedButton(
                  onPressed: () {
                    //회원가입 Post 내용이랑 성공하면 이전화면(LoginScreen)으로 돌아가기.
                    _Auth();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  child: Text('회원가입', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
      IsaddButton: false,
    );
  }

  Future<void> _Auth() async {
    final url = Uri.parse('http://43.201.222.85:8080/api/auth/signup');

    final body = {
      'username': userName,
      'loginId': userId,
      'phoneNumber': userNumber,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('회원가입이 완료되었습니다.')));
        Navigator.of(context).pop(); // 이전 화면으로 돌아가기
      } else {
        // 서버가 에러 메시지를 돌려준다면 파싱해서 보여줄 수도 있습니다.
        final error = jsonDecode(response.body)['message'] ?? '회원가입에 실패했습니다.';
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text(error)));
        await showDialog(context: context, builder: (_) {
          return AlertDialog(
            title: Text('회원 가입 실패'),
            content: Text('${error}'),
            actions: [
              TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('확인'))
            ],
          );
        });
      }
    } catch (e) {
      print('authentication_Screen  - _Auth() - try-catch Error ${e}');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('네트워크 오류가 발생했습니다.')),
      // );
      await showDialog(context: context, builder: (_) {
        return AlertDialog(
          title: Text('회원 가입 실패'),
          content: Text('네트워크 오류가 발생했습니다. 잠시후 다시 시도해주세요.'),
          actions: [
            TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('확인'))
          ],
        );
      });
    }
  }
}
