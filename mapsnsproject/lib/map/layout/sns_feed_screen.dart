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
            Container(
              height: 400,
              decoration: BoxDecoration(),
              child: Image.network(
                'https://mapsnsproject1504616c5-dev.s3.ap-northeast-2.amazonaws.com/user_images/1745745367536.jpg',
              ),
            ),
          ],
        ),
      ),
      IsaddButton: false,
    );
  }
}
