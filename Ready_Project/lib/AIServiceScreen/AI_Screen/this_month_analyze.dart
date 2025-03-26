import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ready_project/common/layout/default_layout.dart';

import '../../common/const/data.dart';

class ThisMonthAnalyze extends StatefulWidget {
  final String prompt;
  const ThisMonthAnalyze({required this.prompt,super.key});

  @override
  State<ThisMonthAnalyze> createState() => _ThisMonthAnalyzeState();
}

class _ThisMonthAnalyzeState extends State<ThisMonthAnalyze> {
  String? answer;

  @override
  void initState() {
    super.initState();
    postPrompt();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '이번 달 소비패턴 분석하기',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 내가 보낸 메시지 (widget.p)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, left: 60, right: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Text(
                widget.prompt,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          // 상대방의 메시지 (answer)
          answer == null
              ? CircularProgressIndicator()
              : Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 60),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                answer!,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> postPrompt() async {
    final dio = Dio();
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: "JWT_TOKEN");
    try {
      final resp = await dio.post("http://$ip/chatbot",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          }),
          data: jsonEncode({"message": widget.prompt})
      );

      if (resp.statusCode == 200) {
        print('${resp.data['response']}');
        setState(() {
          answer = resp.data['response'];
        });
      } else {
        print(
            'this_month_analyze - postPrompt - Status is Not 200 Error - ${resp.statusCode} / ${resp.statusMessage}');
      }
    } catch (e) {
      print('this_month_analyze - postPrompt - try-Catch Error - ${e}');
    }
  }

}
