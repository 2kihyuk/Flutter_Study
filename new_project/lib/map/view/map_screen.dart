// import 'package:flutter/material.dart';
// import 'package:flutter_naver_map/flutter_naver_map.dart';
// import 'package:new_project/common/layout/default_layout.dart';
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});
//
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   late NaverMapController _controller;
//   bool _isMapInitialized = false; // 지도 초기화 여부 확인용
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     NaverMapSdk.instance.initialize(
//       clientId: 'jtcaxatytt',  // 네이버 지도 API 클라이언트 ID를 입력하세요.
//     ).then((_) {
//       setState(() {
//         print('Naver Map Initialize - setState');
//         _isMapInitialized = true; // 초기화 완료
//       });
//     }).catchError((e) {
//       print('Naver Map Initialization Failed: $e');
//     });
//      // NaverMapSdk.instance.initialize(clientId: 'jtcaxatytt');
//      // NaverMapSdk.instance.initialize(
//      //    clientId: 'jtcaxatytt',
//      //    onAuthFailed: (ex) {
//      //      print("********* 네이버맵 인증오류 : $ex *********");
//      //    });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_isMapInitialized) {
//       return Center(child: CircularProgressIndicator()); // 초기화 대기 중
//     }
//
//     return DefaultLayout(
//       titleText: '홈',
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             SizedBox(
//               height: 300,
//               child: NaverMap(
//                 // options: const NaverMapViewOptions(),
//                 onMapReady: (controller) {
//                   _controller = controller;
//                 },
//
//               ),
//             ),
//           ],
//         ),
//       ),
//       IsaddButton: false,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:new_project/common/layout/default_layout.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late NaverMapController _controller;
  bool _isMapInitialized = false; // 지도 초기화 여부 확인용

  @override
  void initState() {
    super.initState();
    // 네이버 맵 SDK 초기화
    NaverMapSdk.instance.initialize(
      clientId: 'jtcaxatytt',  // 네이버 지도 API 클라이언트 ID를 입력하세요.
    ).then((_) {
      setState(() {
        print('Naver Map Initialize - setState');
        _isMapInitialized = true; // 초기화 완료
      });
    }).catchError((e) {
      print('Naver Map Initialization Failed: $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isMapInitialized) {
      return Center(child: CircularProgressIndicator()); // 초기화 대기 중
    }

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
                onMapReady: (controller) {
                  _controller = controller; // 지도 컨트롤러 초기화
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
