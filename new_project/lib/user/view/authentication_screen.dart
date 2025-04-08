import 'package:flutter/material.dart';
import 'package:new_project/common/layout/default_layout.dart';

import '../../common/component/custom_text_form_field.dart';
import '../../common/const/colors.dart';

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
                SizedBox(height: 20,),
                CustomTextFormField(
                  hintText: 'ID를 입력해주세요.',
                  // errorText: '에러가 있습니다.',
                  onChanged: (String value) {
                    userId = value;
                  },
                ),
                SizedBox(height: 20,),
                CustomTextFormField(
                  hintText: '전화번호를 입력해주세요.',
                  // errorText: '에러가 있습니다.',
                  onChanged: (String value) {
                    userNumber = value;
                  },
                ),
                SizedBox(height: 20,),
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
                SizedBox(height: 20,),
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
                SizedBox(height: 8,),
                Text(password != passwordCheck ? '비밀번호가 일치하지 않습니다. 다시 입력해주세요.' : '비밀번호가 일치합니다.'),
                SizedBox(height: 28.0,),
                ElevatedButton(
                  onPressed: () {
                    //회원가입 Post 내용이랑 성공하면 이전화면(LoginScreen)으로 돌아가기.
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
}
