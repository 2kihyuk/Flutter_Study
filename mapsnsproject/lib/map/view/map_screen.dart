import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart'; // FlutterNaverMap 사용
import 'package:mapsnsproject/common/component/custom_text_form_field.dart';
import '../../common/const/colors.dart';
import '../../common/layout/default_layout.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late NaverMapController controller;

  @override
  void initState() {
    super.initState();
    // `NaverMap`을 사용하여 초기화 처리
  }

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
              },
              child: Text('장소 검색', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: NaverMap(
                options: NaverMapViewOptions(
                  mapType: NMapType.terrain,
                  indoorEnable: false,
                  locationButtonEnable: true,
                  scrollGesturesEnable: true,
                  consumeSymbolTapEvents: true,
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(37.566, 126.979),
                    zoom: 13,
                    bearing: 0,
                    tilt: 0,
                  ),
                ),
                onMapReady: (controller) {
                  controller = controller; // 지도 컨트롤러 초기화
                  final marker = NMarker(
                      id: 'test',
                      position: NLatLng(37.506932467450326, 127.05578661133796));
                  final marker1 = NMarker(
                      id: 'test1',
                      position: NLatLng(37.606932467450326, 127.05578661133796));
                  controller.addOverlayAll({marker, marker1});
                  final OnMarkerInfoMap =
                  NInfoWindow.onMarker(id: marker.info.id, text: "웅이네 떡볶이");
                  marker.openInfoWindow(OnMarkerInfoMap);
                  // marker.setIconTintColor(Colors.blueAccent);
                },
                onMapTapped: (point, latLng) {
                  debugPrint("${latLng.latitude}、${latLng.longitude}");
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
