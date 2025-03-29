import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  final String Error;

  const ErrorScreen({required this.Error, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: ListView(
        children: [
          Text('Error : ${Error}'),
          ElevatedButton(
            onPressed: () {
              context.go('/');
            },
            child: Text('홈으로'),
          ),
        ],
      ),
    );
  }
}
