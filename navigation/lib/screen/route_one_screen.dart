import 'package:flutter/material.dart';
import 'package:navigation/layout/default_layout.dart';
import 'package:navigation/screen/route_two_screen.dart';

class RouteOneScreen extends StatelessWidget {
  final int number;

  const RouteOneScreen({
    required this.number,
    super.key,
  });

  ///PopScope의 canPop 속성을 false로 지정하면, 버튼을 눌러서, 설정할것ㅅ에따라 pop() 을 통해서 pop하는 것 이외에는 pop을 할 수 가없다. 화면드래그해서 pop하기나, appbar의 뒤로가기버튼을 통해pop하는 기능의 사용이 불가능해진다.
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: DefaultLayout(
        title: 'Route One Screen',
        children: [
          Text('argument : ${number}',
          textAlign: TextAlign.center,),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop(
                456,
              );
            },
            child: Text('Pop'),
          ),
          ///위의 OutlinedButton을 누르면 OutlinedButton - onPressed(){ Navigator.of(context).pop( 456) 456이라는 데이터를 보내면서 스택에 쌓인 라우트원 페이지 빼내면서 홈스크린으로 이동.
          ///
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).maybePop(
                456,
              );
            },
            child: Text('MaybePop'),
          ),
      
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context){
                      return RouteTwoScreen();
                    },
                  settings: RouteSettings(
                    arguments: 789,
                  )
                )
              );
            },
            child: Text('Push'),
          ),
          /// 이 OutlinedButton을 누르면 Navigator.of(context).push(MaterialPageRoute(builder : (BuildContext context){return RouteTwoScreen();} , settings: RouteSettings(arguments:789,))}
          /// RouteTwoScreen으로 이동하면서, 데이터를 보낼때, RouteTwoScreen(789)처럼 보내는게 아니라, settings: RouteSetting(arguments:789) 로 arguements를 같이 전달하면서 페이지 이동.
          OutlinedButton(
            onPressed: () {
              print(Navigator.of(context).canPop()); //false 출력됨. pop을 할 수 가 없다. 라우트 스택에 유일하게 있는 라우트가 홈스크린이기때문에, pop을 할수가 없다고 판단해 false ㅊ출력.
            },
            child: Text('CanPOP'),
          ),
        ],
      ),
    );
  }
}
