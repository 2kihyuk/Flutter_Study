import 'package:flutter/material.dart';
import 'package:go_route_prac/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

class TransitionScreenTwo extends StatelessWidget {
  const TransitionScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: Container(
        color: Colors.blue,
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: Text('Pop'),
            ),
          ],
        ),
      ),
    );
  }
}
