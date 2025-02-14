import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ready_project/common/layout/default_layout.dart';

import '../../common/const/data.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {

  double monthly_expense_total = 0.0;
  double monthly_income_total = 0.0;

  @override
  void initState() {
    super.initState();
    getCumulativeData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'AI 서비스',
      child: Column(
        children: [
          // ElevatedButton들을 그리드 형태로 배치
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('AI를 활용한 자산 분석하기'),
                  SizedBox(height: 10.0,),
                  OutlinedButton(
                    onPressed: (){},
                    child: Text('저번 달 소비패턴 분석하기'),
                  ),
                  OutlinedButton(
                    onPressed: (){},
                    child: Text('다음 달엔 어떻게 아끼지?'),
                  ),
                  OutlinedButton(
                    onPressed: (){},
                    child: Text('어디에 가장 많이 소비해?'),
                  ),
                  OutlinedButton(
                    onPressed: (){},
                    child: Text('이번 달은 어떻게 하지?'),
                  ),
                ],
              ),
            ),
          ),
        Divider(),
          // 나머지 화면 내용
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('이번 달 누적 지출 금액 : ${NumberFormat('#,###').format(monthly_expense_total)}원'),
                  Text('이번 달 누적 수입 금액 : ${NumberFormat('#,###').format(monthly_income_total)}원'),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getCumulativeData()async {
    String? token = await storage.read(key: 'JWT_TOKEN');
    final dio = Dio();
    try{
      final resp =await dio.get('http://$ip/transactions/monthly-summary',
            options: Options(
        headers: {
          'Authorization' : 'Bearer $token'
        }

        // resp['monthly_expense_total']
      ));
      if(resp.statusCode == 200){
        setState(() {
          monthly_expense_total = resp.data['monthly_expense_total'];
          monthly_income_total = resp.data['monthly_income_total'];
        });
      }else{
        print('getCumulativeData - API 요청 실패: ${resp.statusCode}');
      }
    }catch(e){
      print('에러 발생: AI_Chat_Screen - getCumulativeData -  $e');
    }
  }
}
