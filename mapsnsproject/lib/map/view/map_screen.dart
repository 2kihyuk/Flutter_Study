// import 'package:flutter/material.dart';
// import 'package:flutter_naver_map/flutter_naver_map.dart'; // FlutterNaverMap 사용
// import 'package:mapsnsproject/common/component/custom_text_form_field.dart';
// import '../../common/const/colors.dart';
// import '../../common/layout/default_layout.dart';
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});
//
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   late NaverMapController controller;
//   double _zoomlevel = 13.0;
//
//   @override
//   Widget build(BuildContext context) {
//     String searchQuery = '';
//     double _zoomLevel = 13; // 초기 줌 레벨 설정
//
//     return DefaultLayout(
//       titleText: '홈',
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             CustomTextFormField(
//               onChanged: (String value) {
//                 searchQuery = value;
//               },
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 print(searchQuery);
//               },
//               child: Text('장소 검색', style: TextStyle(color: Colors.white)),
//               style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
//             ),
//             SizedBox(height: 20),
//             Expanded(child: Map()),
//           ],
//         ),
//       ),
//       IsaddButton: false,
//     );
//   }
// }
//
// class Map extends StatelessWidget {
//   const Map({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         NaverMap(
//           options: NaverMapViewOptions(
//             indoorEnable: false,
//             locationButtonEnable: true,
//             scrollGesturesEnable: true,
//             consumeSymbolTapEvents: true,
//             initialCameraPosition: NCameraPosition(
//               target: NLatLng(37.566, 126.979),
//               zoom: 13,
//               bearing: 0,
//               tilt: 0,
//             ),
//           ),
//           onMapReady: (controller) {
//             controller = controller; // 지도 컨트롤러 초기화
//             final marker = NMarker(
//               id: 'test',
//               position: NLatLng(37.506932467450326, 127.05578661133796),
//             );
//             final marker1 = NMarker(
//               id: 'test1',
//               position: NLatLng(37.606932467450326, 127.05578661133796),
//             );
//             controller.addOverlayAll({marker, marker1});
//             final OnMarkerInfoMap = NInfoWindow.onMarker(
//               id: marker.info.id,
//               text: "웅이네 떡볶이",
//             );
//             marker.openInfoWindow(OnMarkerInfoMap);
//             marker.setIconTintColor(Colors.blueAccent);
//           },
//           onMapTapped: (point, latLng) {
//             debugPrint("${latLng.latitude}、${latLng.longitude}");
//           },
//         ),
//         Positioned(
//           child: Column(
//             children: [
//               ElevatedButton(
//                 onPressed: () {},
//                 child: Icon(Icons.add),
//                 style: ElevatedButton.styleFrom(
//                   shape: CircleBorder(),
//                   backgroundColor: Colors.transparent,
//                   padding: EdgeInsets.all(10), // 원하는 색상으로 설정
//                 ),
//               ),
//               SizedBox(height: 10),
//               // 줌 아웃 버튼
//               ElevatedButton(
//                 onPressed: () {},
//                 child: Icon(Icons.remove),
//                 style: ElevatedButton.styleFrom(
//                   shape: CircleBorder(),
//                   backgroundColor: Colors.transparent,
//                   padding: EdgeInsets.all(10), // 원하는 색상으로 설정
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mapsnsproject/common/layout/default_layout.dart';
import 'package:mapsnsproject/map/data/map_data.dart';
import '../../common/component/custom_text_form_field.dart';
import '../../common/const/colors.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String searchQuery = '';
    return DefaultLayout(
      titleText: '홈',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFormField(
              onChanged: (String value) {
                searchQuery = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print(searchQuery);
                _getData(searchQuery);
              },
              child: Text('장소 검색', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
            ),
            SizedBox(height: 20),
            Expanded(child: GoogleMapScreen()),
          ],
        ),
      ),
      IsaddButton: false,
    );
  }
  Future<void> _getData(String query) async{
    // final apiKey = 'AIzaSyC_o3QsipOt5oOuXr_ju4q-zs6r-budsYs'; // API 키를 실제 키로 변경
    final url = Uri.parse('https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$mapKey');


    try {
      // POST 요청 보내기
      final response = await http.post(url);

      if (response.statusCode == 200) {
        // 요청 성공, 응답 처리
        final data = json.decode(response.body);

        if (data != null && data['results'] != null) {
          for (var result in data['results']) {
            final placeName = result['name'] ?? 'No name';
            final formattedAddress = result['formatted_address'] ?? 'No address';
            final latitude = result['geometry']?['location']?['lat'] ?? 0.0;
            final longitude = result['geometry']?['location']?['lng'] ?? 0.0;

            print('Place Name: $placeName');
            print('Address: $formattedAddress');
            print('Latitude: $latitude');
            print('Longitude: $longitude');
          }
        } else {
          print('No results found.');
        }
        // print('Response data: $data');
        // 여기서 받은 데이터를 UI에 표시하거나 다른 로직을 처리합니다.
      } else {
        // 요청 실패
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

class GoogleMapScreen extends StatefulWidget {
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;
  late Position _currentPosition; // 현재 위치를 저장할 변수
  final LatLng _center = const LatLng(37.42796133580664, 126.085749655962);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 비활성화되어 있으면 에러 처리
      return;
    }

    // 위치 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 권한 거부 처리
        return;
      }
    }

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print('현재 위치: ${position.latitude}, ${position.longitude}');

    // 위치를 기반으로 카메라 이동
    mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(_currentPosition.latitude, _currentPosition.longitude),
      ),
    );
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, 126.085749655962),
    zoom: 14.4746,
  );

  void _zoomIn() {
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  // 줌아웃
  void _zoomOut() {
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // 화면이 로드되면 위치를 가져옵니다

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            // onTap: (){
            //
            // },
            // markers: [],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Zoom In Button
                FloatingActionButton(
                  onPressed: _zoomIn,
                  child: Icon(Icons.add),
                  backgroundColor: Colors.white.withOpacity(0.5), // 배경색 투명
                  tooltip: 'Zoom In',
                    heroTag: 'zoomInButton'
                ),
                SizedBox(height: 10),
                // Zoom Out Button
                FloatingActionButton(
                  onPressed: _zoomOut,
                  child: Icon(Icons.remove),
                  backgroundColor: Colors.white.withOpacity(0.5), // 배경색 투명
                  tooltip: 'Zoom Out',
                    heroTag: 'zoomOutButton'
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
