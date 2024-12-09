import 'package:flutter/material.dart';
import 'package:navigation/layout/default_layout.dart';
import 'package:navigation/screen/route_three_screen.dart';

class RouteTwoScreen extends StatelessWidget {
  const RouteTwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute
        .of(context)
        ?.settings
        .arguments;

    return DefaultLayout(
      title: 'Route Two Screen',
      children: [
        Text(
          arguments.toString(),
          textAlign: TextAlign.center,
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Pop'),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              '/three',
              arguments: 1111,
            );
          },
          child: Text('Push'),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder:(BuildContext context){
                      return RouteThreeScreen();
                  },
                )
            );
          },
          child: Text('Push Replacement'),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
                '/three'
            );
          },
          child: Text('Push ReplacementNamed'),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/three',
                (route){
                  ///만약에 route Stack에서 삭제할거면 false 반환
                  ///만약에 삭제하지 않을거면 true 반환
                  return route.settings.name =='/';
                }
            );
          },
          child: Text('Push Named and Remove Until'),
        )
      ],
    );
  }
}

///여기서는 arguments를 ModalRoute.of(context)?.settings.arguments; 로 데이터를 받아서, 변수화해서 사용.
///main.dart에다가 routes 에서 정의한 속성을 통해, Navigator.of(context).pushNamed('/three')를통해 RouteThreeScreen으로 간단한 코드로 이동가능.
///