import 'package:flutter/material.dart';

// 'android/app/build.gradle'
void main() {
  //플러터 앱을 실행한다.
  runApp(
      MaterialApp(
          home: HomeScreen()
      )
  );
}
//stless 를 통해서 클래스를 정의해서 위젯을 만들자..
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); //super.key??

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF335CB0),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32.0
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  'asset/img/logo.png'
              ),
              SizedBox(height: 28.0), //간격을 만들때 sizedBox를 쓰는게 좋다! padding보다
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        )
      //이미지파일의 경로
    );
  }
}




// class HomeScreen extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Color(0xFF335CB0),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//                 'asset/img/logo.png'
//             ),
//             CircularProgressIndicator(
//               color: Colors.white,
//             ),
//           ],
//         )
//       //이미지파일의 경로
//     );
//   }
// }


    // //화면에 보여주고 싶은 요소를 runAPP안에 넣는다.
    // /// MaterailApp은 항상 최상위에 위치한다.
    // /// Scaffold는 바로 아래에 위치한다.
    // /// 위 두개는 절대적인것. MaterialAPP. Scaffold ->화면구성을 쉽게 해주는요소.
    // /// 위젯 Widget -> 화면에 보여주게 하는 모든 것.
    // /// center위젯 - 가운데 정렬 .
    // MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: Scaffold(
    //     backgroundColor: Colors.black,
    //     body: Center(
    //       child: Text('Code Factory',
    //           style: TextStyle(
    //             color: Colors.white,
    //           )),
    //     ),
    //   ),
    // ),



