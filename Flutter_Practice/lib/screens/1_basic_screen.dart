import 'package:flutter/material.dart';
import 'package:go_route_prac/layout/default_layout.dart';

class BasicScreen extends StatelessWidget {
  const BasicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(body: Center(child: Text('Basic Screen')));
  }
}
