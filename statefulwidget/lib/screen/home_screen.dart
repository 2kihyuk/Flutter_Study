import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget{

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  Color color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    print('build 실행');

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: (){
                  if(color == Colors.blue){
                    color = Colors.red;
                  }else{
                    color = Colors.blue;
                  }
                  print('색상 변경 color : $color ');

                  setState(() {});  ///setState(() {}) 실행으로 자동으로 reload가 된다.
                  ///build가 된다 다시.
                  ///setState는 build 함수를 다시 실행.
                }, child: Text(
                '색상 변경!'
            )

            ),
            SizedBox(height: 32.0),
            Container(
              width: 50.0,
              height: 50.0,
              color: color,
            )
          ],
        ),
      ),
    );
  }
}






// class HomeScreen2 extends StatelessWidget {
//   Color color = Colors.blue;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//                 onPressed: (){
//                 if(color == Colors.blue){
//                   color = Colors.red;
//                 }else{
//                   color = Colors.blue;
//                 }
//             }, child: Text(
//               '색상 변경!'
//             )
//
//             ),
//             SizedBox(height: 32.0),
//             Container(
//               width: 50.0,
//               height: 50.0,
//               color: color,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
