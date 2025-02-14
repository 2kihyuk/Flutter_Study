import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/const/data.dart';

class Safebox extends StatefulWidget {
  const Safebox({super.key});

  @override
  State<Safebox> createState() => _SafeboxState();
}

class _SafeboxState extends State<Safebox> {
  double? safe_box;

  @override
  void initState() {
    getSafeBoxData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 아이콘과 텍스트 간 간격을 확보
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/money_icon.png',
                width: 25,
                height: 25,
              ),
              SizedBox(width: 15), // 아이콘과 텍스트 간 간격
              Text(
                '세이프박스',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // ElevatedButton(
          //   onPressed: (){
          //     dateOver();
          //   },
          //   child: Text('1'),
          // ),
          // ElevatedButton(
          //   onPressed: (){
          //     dateBack();
          //   },
          //   child: Text('2'),
          // ),
          // ElevatedButton(
          //   onPressed: (){
          //     initial();
          //   },
          //   child: Text('3'),
          // ),

          Text(
            '${NumberFormat('#,###').format(safe_box ?? 0.0)}원',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> initial() async{
  //   final dio = Dio();
  //
  //   final token = await storage.read(key: JWT_TOKEN);
  //
  //   try {
  //     final response = await dio.patch(
  //       'http://$ip/reset-safe-box',
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           "Content-Type": "application/json"
  //         },
  //       ),
  //     );
  //     if (response.statusCode == 200) {
  //       print("SafeBox : initial : ${response.data}");
  //
  //     } else {
  //       print('API 요청 실패: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('에러 발생: SafeBox - initial -  $e');
  //   }
  // }
  //
  // Future<void> dateBack() async{
  //   final dio = Dio();
  //
  //   final token = await storage.read(key: JWT_TOKEN);
  //
  //   try {
  //     final response = await dio.get(
  //       'http://$ip/test-reset-to-yesterday',
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           "Content-Type": "application/json"
  //         },
  //       ),
  //     );
  //     if (response.statusCode == 200) {
  //       print("SafeBox : dateBack : ${response.data}");
  //
  //     } else {
  //       print('API 요청 실패: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('에러 발생: SafeBox - dateBack -  $e');
  //   }
  // }
  //
  // Future<void> dateOver() async{
  //   final dio = Dio();
  //
  //   final token = await storage.read(key: JWT_TOKEN);
  //
  //   try {
  //     final response = await dio.get(
  //       'http://$ip/test-reset-daily-budget',
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           "Content-Type": "application/json"
  //         },
  //       ),
  //     );
  //     if (response.statusCode == 200) {
  //       print("SafeBox : dateOver : ${response.data}");
  //
  //
  //     } else {
  //       print('API 요청 실패: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('에러 발생: SafeBox - dateOver -  $e');
  //   }
  // }

  Future<void> getSafeBoxData() async {
    final dio = Dio();

    final token = await storage.read(key: JWT_TOKEN);

    try {
      final response = await dio.get(
        'http://$ip/user-info',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        print("SafeBox : getSafeBoxData : ${response.data}");
        print("SafeBox : getSafeBoxData : ${response.data['safeBox']}");
        double fetchedSafeBox = response.data['safeBox'] ?? 0.0;
        setState(() {
          safe_box = fetchedSafeBox;
          print("Updated safe_box: $safe_box");
        });
      } else {
        print('API 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: SafeBox - getSafeBoxData -  $e');
    }
  }
}
