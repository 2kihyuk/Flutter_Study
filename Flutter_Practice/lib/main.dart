import 'package:flutter/material.dart';
import 'package:go_route_prac/route/router.dart';

void main() {
  runApp( _App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
