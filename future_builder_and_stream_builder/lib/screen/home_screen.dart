import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<int>(
        stream: getStreamNumbers(),
        builder: (BuildContext context , AsyncSnapshot<int> snapshot){

          print('-----data-----');
          print(snapshot.connectionState); //future의 상태를 알려줌. waiting , done 상태가 바뀔때 데이터가 바뀔때 에러가 생겼을때, 등등 상태가 변경할때마다 builder가 재실행된다.

          print(snapshot.data);

          // ConnectionState.none; -> Future또는 Stream이 입력되지 않은 상태
          // ConnectionState.active; -> Stream에서만 존재하는 상태임.Stream 아직 실행중
          // ConnectionState.waiting; -> 실행중
          // ConnectionState.done; -> Future 또는 Stream이 종료되었을때

          if(snapshot.connectionState == ConnectionState.active){
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text(snapshot.data.toString()),
                  
                ],
              ),
            );
          }
          ///error 확인 하는 방법
          // if(snapshot.hasError){
          //   final error = snapshot.error;
          //   return Center(
          //     child: Text('에러 : $error'),
          //   );
          // }
          ///데이터가 존재하는지 확인
          if(snapshot.hasData){
            final data = snapshot.data;
            return Center(
              child: Text(data.toString()),
            );
          }
          return Center(
            child: Text('데이터가 없습니다.'),
          );

        },
      ),
    );
  }

  Future<int> getNumber() async {
    await Future.delayed(Duration(seconds: 3));

    final random = Random();

    return random.nextInt(100);
  }

  Stream<int> getStreamNumbers() async*{

    for(int i =0; i<10;i++){
      await Future.delayed(Duration(seconds: 1));
      if(i==5){
        throw '던져!';
      }
      yield i;
    }
  }



}
