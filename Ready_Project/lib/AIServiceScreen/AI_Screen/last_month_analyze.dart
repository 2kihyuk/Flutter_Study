import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ready_project/common/layout/default_layout.dart';

import '../../common/const/data.dart';

class LastMonthAnalyze extends StatefulWidget {

  final String p;
  const LastMonthAnalyze({required this.p, super.key});

  @override
  State<LastMonthAnalyze> createState() => _LastMonthAnalyzeState();
}

class _LastMonthAnalyzeState extends State<LastMonthAnalyze> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '저번 달 소비패턴 분석하기',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('${widget.p}'),
          ],
        ),
    );
  }


  // Future<void> postPrompt() async{
  //   final dio = Dio();
  //
  //   try{
  //     final resp = dio.post("https://$ip/")
  //   }catch(e){
  //
  //   }
  // }
}
