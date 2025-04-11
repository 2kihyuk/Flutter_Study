import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:new_project/common/layout/default_layout.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      titleText: '홈',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 300,
              child: NaverMap(
                options: const NaverMapViewOptions(),
                onMapReady: (controller) {
                  print("네이버 맵 로딩됨!");
                },
              ),
            ),
          ],
        ),
      ),
      IsaddButton: false,
    );
  }
}
