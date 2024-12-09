import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  disabledBackgroundColor: Colors.grey,
                  //버튼이 비활성화됬을때의 색깔.
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.red,
                  shadowColor: Colors.green,
                  elevation: 10,
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
                  padding: EdgeInsets.all(32.0),
                  side: BorderSide(
                    ///테두리.
                    color: Colors.black,
                    width: 4.0,
                  ),
                  //minimumSize: Size(200,150),
                  //maximumSize: Size(100, 150)
                  fixedSize: Size(150, 200)),
              child: Text('Elevated Button'),
            ),

            OutlinedButton(
              onPressed: () {},
              style: ButtonStyle(

                  ///Material State
                  ///
                  /// hovered - 호버링 상태( 마우스 커서를 올려놓은 상태)
                  /// focused - 포커스 됐을때 (텍스트 필드)
                  /// pressed - 눌렀을때 (o)
                  /// dragged - 드래그 됐을때
                  /// selected - 선택 됐을때 (체크박스, 라디오버튼)
                  /// scrollUnder - 다른 컴포넌트 밑으로 스크롤링 됐을떄
                  /// disable - 비활성화 됐을때 (o)
                  /// error - 에러 상태일때
                  /// WidgetStateProperty.all()은 그 어떤 상태이든 해당 디자인을유지해라.
                  ///
                  backgroundColor: WidgetStateProperty.all(
                    Colors.red,
                  ),
                  minimumSize: WidgetStateProperty.all(
                    Size(200, 150),
                  )),
              child: Text('Outlined Button'),
            ),

            TextButton(
              onPressed: null,
              style: ButtonStyle(backgroundColor:
                  WidgetStateProperty.resolveWith((Set<WidgetState> states) {
                //states
                if (states.contains(WidgetState.pressed)) {
                  return Colors.red;
                }
                return Colors.black;
              }), foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.black;
                }
                if (states.contains(WidgetState.disabled)) {
                  return Colors.red;
                }
                return Colors.white;
              }), minimumSize: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return Size(200, 150);
                }
                return Size(300, 200);
              })),
              child: Text('Text Button'),
            ),

            ///버튼의 생김새를 변경할 수 있는,
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                  shape: CircleBorder(eccentricity: 1)),
              child: Text('Shape'),
            ),
            ElevatedButton.icon(
              onPressed: (){},
              icon: Icon(
                Icons.keyboard_alt_outlined,
              ),
              label: Text('키보드'),
            ),
            TextButton.icon(
              onPressed: (){},
              icon: Icon(
                Icons.keyboard_alt_outlined,
              ),
              label: Text('키보드'),
            ),
            OutlinedButton.icon(
              onPressed: (){},
              icon: Icon(
                Icons.keyboard_alt_outlined,
              ),
              label: Text('키보드'),
            )
          ],
        ),
      ),
    );
  }
}
