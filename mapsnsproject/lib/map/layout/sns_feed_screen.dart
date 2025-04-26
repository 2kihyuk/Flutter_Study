import 'package:flutter/material.dart';
import 'package:mapsnsproject/common/layout/default_layout.dart';

class SnsFeedScreen extends StatelessWidget {
  const SnsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      titleText: '피드',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('SnspostPage'),
          ],
        ),
      ),
      IsaddButton: false,
    );
  }
}
