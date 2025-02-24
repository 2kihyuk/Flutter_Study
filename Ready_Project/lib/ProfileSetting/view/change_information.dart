import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ready_project/common/layout/default_layout.dart';

import '../../common/const/data.dart';

class ChangeInformation extends StatefulWidget {
   ChangeInformation({super.key});

  @override
  State<ChangeInformation> createState() => _ChangeInformationState();
}

class _ChangeInformationState extends State<ChangeInformation> {
  TextEditingController beforeController = TextEditingController();

  TextEditingController afterController = TextEditingController();

  TextEditingController checkController = TextEditingController();

  String beforepassword =" ";

  String afterpassword=" ";

  bool isPassword = false;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '비밀번호 변경하기',
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: beforeController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: "현재 비밀번호를 입력해주세요.",
                labelStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
              onChanged: (value) {
                beforepassword = value;
              },
            ),
            TextFormField(
              controller: afterController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: '변경할 비밀번호를 입력해주세요.',
                labelStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
              onChanged: (value) {
                afterpassword = value;
              },
            ),
            TextFormField(
              controller: checkController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: '변경할 비밀번호를 다시 입력해주세요.',
                labelStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  isPassword = value == afterpassword;
                });
              },
            ),
            SizedBox(height: 16.0,),
            if(!isPassword)
              Container(
                child: Center(
                  child: Text('변경할 비밀번호가 일치하지 않습니다.'),
                ),
              ),
            SizedBox(height: 16.0,),

            OutlinedButton(
              onPressed: (){
                if(isPassword){
                  changePassword();
                }
              },
              child: Text('비밀번호 변경하기'),
            ),

          ],
        ),
      ),
    );
  }

   Future<void> changePassword() async {
     final dio = Dio();
     final storage = FlutterSecureStorage();

     final token = await storage.read(key: JWT_TOKEN);

     try {
       final response = await dio.patch(
         'http://$ip/auth/change-password',
         options: Options(
           headers: {
             'Authorization': 'Bearer $token',
           },
         ),

         data: {
           "currentPassword" : beforepassword,
           "newPassword" : afterpassword
         }
       );
       if (response.statusCode == 200) {
         print("change_information : changePassword : ${response.data}");
         Navigator.of(context).pop();

       } else {
         print('API 요청 실패: ${response.statusCode}');
       }
     } catch (e) {
       print('에러 발생: change_information - changePassword -  $e');
     }
   }
}


