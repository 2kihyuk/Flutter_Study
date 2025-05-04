import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapsnsproject/user/data/login_request.dart';
import 'package:mapsnsproject/user/repository/auth_repository.dart';
import '../../common/component/custom_text_form_field.dart';
import '../../common/const/colors.dart';
import '../../common/layout/default_layout.dart';
import '../../common/view/root_tab.dart';
import 'authentication_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String userId = '';
  String password = '';
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final loginReq = LoginRequest(userId: userId, password: password);

    try {
      final loginResp = await ref.read(loginProvider(loginReq).future);
      // await _secureStorage.write(key:'accessToken', value:loginRes.accessToken);
      // await _secureStorage.write(key:'refreshToken', value:loginRes.refreshToken);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('로그인 성공!')));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => RootTab()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('로그인 실패'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('확인'),
                ),
              ],
            ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
                    userId = value;
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
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: () {
                        // _submit();
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
