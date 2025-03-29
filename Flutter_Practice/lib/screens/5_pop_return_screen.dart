import 'package:flutter/material.dart';
import 'package:go_route_prac/layout/default_layout.dart';
import 'package:go_router/go_router.dart';


class PopReturnScreen extends StatelessWidget {
  const PopReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(body: ListView(
      children: [
        ElevatedButton(onPressed: (){
          context.pop('Code Factory');
        }, child: Text('Pop')),
      ],
    ));
  }
}
