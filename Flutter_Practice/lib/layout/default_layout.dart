import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DefaultLayout extends StatelessWidget {
  final Widget body;

  const DefaultLayout({required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(GoRouterState.of(context).matchedLocation)),
      body: Padding(padding: EdgeInsets.all(8.0), child: body),
    );
  }
}
