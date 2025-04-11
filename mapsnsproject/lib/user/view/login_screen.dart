import 'package:flutter/material.dart';


import '../../common/component/custom_text_form_field.dart';
import '../../common/const/colors.dart';
import '../../common/layout/default_layout.dart';
import '../../common/view/root_tab.dart';
import 'authentication_screen.dart';

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
    return DefaultLayout(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                _SubTitle(),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요.',
                  // errorText: '에러가 있습니다.',
                  onChanged: (String value) {
                    userName = value;
                  },
                ),
                SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  // errorText: '에러가 있습니다.',
                  obscureText: true,
                  onChanged: (String value) {
                    password = value;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    //로그인 post. 로그인 성공하면 Root_Tab 이동 및 자동 로그인 유지하기.
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => RootTab()), (Route<dynamic> route) => false );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  child: Text('로그인', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => AuthenticationScreen()),
                    );
                  },
                  child: Text('회원가입', style: TextStyle(color: Colors.black)),
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
      '이메일과 비밀번호를 입력해서 로그인 해주세요 :)',
      style: TextStyle(fontSize: 16, color: Color(0XFF868686)),
    );
  }
}
