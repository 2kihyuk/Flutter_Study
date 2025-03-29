import 'package:flutter/material.dart';
import 'package:go_route_prac/layout/default_layout.dart';
import 'package:go_router/go_router.dart';


class PushScreen extends StatelessWidget {
  const PushScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(body: ListView(
      children: [
        ElevatedButton(onPressed: (){context.push('/basic');}, child: Text('Push_Basic')),
        ElevatedButton(onPressed: (){context.go('/basic');}, child: Text('Go Basic')),

      ],
    ));
  }
}
