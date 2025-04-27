import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapsnsproject/map/data/address_data.dart';
import 'package:mapsnsproject/map/layout/write_sns_screen.dart';

class GMap extends StatefulWidget {
  final Place pickPlace;

  const GMap({required this.pickPlace, super.key});

  @override
  _GMapScreenState createState() => _GMapScreenState();
}

class _GMapScreenState extends State<GMap> with AutomaticKeepAliveClientMixin<GMap>{
  late GoogleMapController mapController;
  Position? _currentPosition; // 현재 위치를 저장할 변수

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getCurrentLocation(); // 화면이 로드되면 위치를 가져옵니다
  }

  Future<void> _getCurrentLocation() async {
    // 1) 권한 / 서비스 체크
    if (!await Geolocator.isLocationServiceEnabled()) return;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    // 2) 실제 위치 가져와서 _currentPosition 에 저장
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() => _currentPosition = pos);

    // 3) 지도가 준비되어 있으면 카메라 이동
    mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(pos.latitude, pos.longitude),
      ),
    );
  }

  void _zoomIn() {
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  // 줌아웃
  void _zoomOut() {
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              // 위치가 아직 없으면 기본 좌표
              target: _currentPosition != null
                  ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                  : LatLng(37.42796133580664, 126.085749655962),
              zoom: 14.0,
            ),
            mapToolbarEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (LatLng position) {
              print(position);
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: Text('피드 작성하기'),
                  content: Text('해당 장소에 기록을 남기시겠습니까?'),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: Text('취소')),
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => WriteSnsScreen(position: position,)));
                    }, child: Text('작성')),
                  ],
                );
              });
            },
            markers: {
              //이부분에는 백엔드에서 위치를 받아와서 마커를 표시하는 것으로 수정해야함.
              Marker(
                markerId: MarkerId(widget.pickPlace.name),
                position: LatLng(
                  widget.pickPlace.geometry.location.lat,
                  widget.pickPlace.geometry.location.lng,
                ),
                infoWindow: InfoWindow(
                  title: widget.pickPlace.name,
                  snippet: widget.pickPlace.formatted_address,
                ),
                onTap: () {
                  print(widget.pickPlace.name);
                },
              ),
            },
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
                  backgroundColor: Colors.white.withOpacity(0.5),
                  // 배경색 투명
                  tooltip: 'Zoom In',
                  heroTag: 'zoomInButton',
                ),
                SizedBox(height: 10),
                // Zoom Out Button
                FloatingActionButton(
                  onPressed: _zoomOut,
                  child: Icon(Icons.remove),
                  backgroundColor: Colors.white.withOpacity(0.5),
                  // 배경색 투명
                  tooltip: 'Zoom Out',
                  heroTag: 'zoomOutButton',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}


//Future<void> _getCurrentLocation() async {
// bool serviceEnabled;
// LocationPermission permission;
//
// // 위치 서비스가 활성화되어 있는지 확인
// serviceEnabled = await Geolocator.isLocationServiceEnabled();
// if (!serviceEnabled) {
//   // 위치 서비스가 비활성화되어 있으면 에러 처리
//   return;
// }
//
// // 위치 권한 확인
// permission = await Geolocator.checkPermission();
// if (permission == LocationPermission.denied) {
//   permission = await Geolocator.requestPermission();
//   if (permission == LocationPermission.denied) {
//     // 권한 거부 처리
//     return;
//   }
// }
//
// // 위치를 기반으로 카메라 이동
// //이 _currentPosition은 시뮬레이터상으로 찍히는 위도와 경도. 강서힐스테이트임.
// mapController.animateCamera(
//   CameraUpdate.newLatLng(
//     LatLng(_currentPosition.latitude, _currentPosition.longitude),
//   ),
// );
//}
