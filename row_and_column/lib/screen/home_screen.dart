import 'package:flutter/material.dart';
import 'package:row_and_column/screen/const/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( //상단 하단바를 제외한 공간에만 적용시키고 싶다면 Scaffold 바로 하단에 SafeArea로 감싸고 시작.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: colors.
              map(
                      (e) => Container(
                        height: 50.0,
                        width: 50.0,
                        color: e,
                      ),

              ).toList()
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50.0,
                  width: 50.0,
                  color: Colors.orange,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
                children: colors.
                map(
                      (e) => Container(
                    height: 50.0,
                    width: 50.0,
                    color: e,
                  ),

                ).toList()
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50.0,
                  width: 50.0,
                  color: Colors.green
                )
              ],
            )
          ],
        )
      ),
    );
  }
}


//Container위젯: 다른 위젯을 담는 위젯.
//먼저 넣어주는 이유는 칼럼위젯의 크기가 얼만큼 차지하고 있는지 확인하기위해서

//