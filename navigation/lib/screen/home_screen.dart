import 'package:flutter/material.dart';
import 'package:navigation/layout/default_layout.dart';
import 'package:navigation/screen/route_one_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'HomeScreen',
        children:[
          OutlinedButton(
            onPressed: ()async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder:(BuildContext context){
                  return RouteOneScreen(
                    number: 20,
                  );
                }
                ),
              );
              print(result);
            },
            child: Text('Push'),
          ),
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
          ///maybePop은, pop할 수 있는 상황이면 pop을 해라. 라는 기능을 가짐.
          ///만약 홈스크린에서 그냥 pop을 하게되면, 홈스크린 이전에는 라우트 스택에 아무런 라우트가 없어서 검은 빈화면이 나오게되는데, 이때 maybePop을 하게되면 pop이 실행되지 않느낟.
          OutlinedButton(
            onPressed: () {
              print(Navigator.of(context).canPop()); //false 출력됨. pop을 할 수 가 없다. 라우트 스택에 유일하게 있는 라우트가 홈스크린이기때문에, pop을 할수가 없다고 판단해 false ㅊ출력.


            },
            child: Text('CanPOP'),
          ),
        ]
    );
  }
}

///homeScreen 에서 버튼을 누르면, OutlinedButton-onPressed()async - await Navigator.of(context).push( MaterialPageRoute(builder : (Buildcontext context){ return RouteOneScreen(number : 20)}
///이렇게 RouteOneScreen으로 number arguments에 20이라는 데이터를 함께 보내면서 페이지 이동. 동시에, RouteOneScreen에서 pop()을 하면서 다시 HomeScreen으로 돌아오면서 await로 result 값을 받아오기.