import 'package:flutter/material.dart';
import 'package:new_project/common/layout/default_layout.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Center(child: Text('홈 화면 여기에 지도 추가할거임.')),
      IsaddButton: false,
    );
  }
}
