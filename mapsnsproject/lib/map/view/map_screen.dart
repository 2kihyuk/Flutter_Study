import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mapsnsproject/common/layout/default_layout.dart';
import 'package:mapsnsproject/map/data/address_data.dart';
import 'package:mapsnsproject/map/data/map_data.dart';
import 'package:mapsnsproject/map/layout/write_sns_screen.dart';
import 'package:mapsnsproject/map/repository/map_repository.dart';
import 'package:mapsnsproject/map/layout/g_map.dart';
import 'package:mapsnsproject/map/repository/place_repository.dart';
import '../../common/component/custom_text_form_field.dart';
import '../../common/const/colors.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  String searchQuery = '';
  List<Place> places = []; // 검색된 결과들을 저장할 리스트
  // late Place pickPlace;
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final placesAsyncValue = ref.watch(placesProvider);
    // ChIJhUS2MhKcfDUR30HeqHh32O8

    return DefaultLayout(
      titleText: '홈',
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                onChanged: (String value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              ),
              SizedBox(height: 30),

              placesAsyncValue.when(
                data: (places) {
                  if (places!.isNotEmpty) {
                    return SizedBox(
                      height: 150,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: places!.length,
                        itemBuilder: (context, index) {
                          final place = places[index];
                          return ListTile(
                            title: Text(place.name),
                            subtitle: Text(place.formatted_address),
                            onTap: () {
                              // 장소를 클릭했을 때 처리
                              print('선택된 장소: ${place.name}');
                              ref.read(pickPlaceProvider.notifier).state =
                                  place;
                              // Future.delayed(Duration(seconds: 5));
                              // _CheckFeedAlertDialog();
                              //여기에 이제 다이얼로그를 띄워서 해당 장소에 추억을 기록하겠냐고 물어봐야함.
                              //여기서 pickPlace를 인자로 넣어서 구글맵에 함수를 실행시켜야함.
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(child: Text("검색 결과가 없습니다."));
                  }
                },
                loading: () => Center(child: CircularProgressIndicator()),
                // 로딩 중 처리
                error:
                    (error, stack) =>
                        Center(child: Text("에러: $error")), // 에러 처리
              ),
              SizedBox(height: 40),

              ExpansionTile(
                leading: Icon(Icons.map_sharp),
                title: Text(
                  isExpanded ? '지도 접기' : '지도 펼치기',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                ),
                initiallyExpanded: isExpanded,
                onExpansionChanged: (bool expanding) {
                  setState(() {
                    isExpanded = expanding;
                  });
                },
                children: [
                  Container(
                    height: 500,
                    child: Consumer(
                      builder: (context, watch, child) {
                        final pickPlace = ref.watch(pickPlaceProvider);
                        return GMap(
                          pickPlace: pickPlace,
                          onCameraIdle: _CheckFeedAlertDialog, //onCameraIdle로 다이얼로그를 띄우는 함수를 GMap에 넘겨서 , GMap에서 CameraAnimate().then으로 카메라 이동이 끝나면, 해당 함수를 바로 실행할 수 있게 설정.
                        );
                      },
                    ),
                  ),
                ],
              ),

              


              SizedBox(height: 20),

              //방문했던 장소들을 요약해서 보여주고, places api ai를 활용하여, 요약?
              //방문했던 장소들을 모아둔 맵 리스트 하나 해두고, 해당 장소 리뷰 요약한거 받기.
            ],
          ),
        ),
      ),
      IsaddButton: false,
    );
  }

  _CheckFeedAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('피드 작성하기'),
          content: Text(
            '${ref.read(pickPlaceProvider.notifier).state.name}에 기록을 남기시겠습니까?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => WriteSnsScreen()));
              },
              child: Text('작성'),
            ),
          ],
        );
      },
    );
  }
}

// class GoogleMapScreen extends StatefulWidget {
//
//   @override
//   _GoogleMapScreenState createState() => _GoogleMapScreenState();
// }
//
// class _GoogleMapScreenState extends State<GoogleMapScreen> {
//   late GoogleMapController mapController;
//   late Position _currentPosition; // 현재 위치를 저장할 변수
//   final LatLng _center = const LatLng(37.42796133580664, 126.085749655962);
//
//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }
//
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // 위치 서비스가 활성화되어 있는지 확인
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // 위치 서비스가 비활성화되어 있으면 에러 처리
//       return;
//     }
//
//     // 위치 권한 확인
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // 권한 거부 처리
//         return;
//       }
//     }
//
//     // 현재 위치 가져오기
//     // Position position = await Geolocator.getCurrentPosition(
//     //   desiredAccuracy: LocationAccuracy.high,
//     // );
//     //
//     // print('현재 위치: ${position.latitude}, ${position.longitude}');
//
//     // 위치를 기반으로 카메라 이동
//     mapController.animateCamera(
//       CameraUpdate.newLatLng(
//         LatLng(_currentPosition.latitude, _currentPosition.longitude),
//       ),
//     );
//   }
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, 126.085749655962),
//     zoom: 14.4746,
//   );
//
//   void _zoomIn() {
//     mapController.animateCamera(CameraUpdate.zoomIn());
//   }
//
//   // 줌아웃
//   void _zoomOut() {
//     mapController.animateCamera(CameraUpdate.zoomOut());
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation(); // 화면이 로드되면 위치를 가져옵니다
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: _kGooglePlex,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             // onTap: (){
//             //
//             // },
//             // markers: [],
//           ),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 // Zoom In Button
//                 FloatingActionButton(
//                   onPressed: _zoomIn,
//                   child: Icon(Icons.add),
//                   backgroundColor: Colors.white.withOpacity(0.5),
//                   // 배경색 투명
//                   tooltip: 'Zoom In',
//                   heroTag: 'zoomInButton',
//                 ),
//                 SizedBox(height: 10),
//                 // Zoom Out Button
//                 FloatingActionButton(
//                   onPressed: _zoomOut,
//                   child: Icon(Icons.remove),
//                   backgroundColor: Colors.white.withOpacity(0.5),
//                   // 배경색 투명
//                   tooltip: 'Zoom Out',
//                   heroTag: 'zoomOutButton',
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Future<void> _getData(String query) async {
//   final url = Uri.parse(
//     'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$mapKey&language=ko',
//   );
//
//   try {
//     // GET 요청 보내기
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       // 요청 성공, 응답 처리
//       final data = json.decode(response.body);
//       print("응답 데이터: $data"); // 응답 데이터 확인
//       PlaceResponse placeResponse = PlaceResponse.fromJson(data);
//       setState(() {
//         places = placeResponse.results; // 응답 데이터를 리스트에 저장
//         int i = 1;
//         for (var place in places) {
//           print('${i++}번째 결과');
//           print('Place Name: ${place.name}');
//           print('Address: ${place.formatted_address}');
//           print('Latitude: ${place.geometry.location.lat}');
//           print('Longitude: ${place.geometry.location.lng}');
//           print('Rating: ${place.rating}');
//         }
//       });
//     } else {
//       print('Request failed with status: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }

// ElevatedButton(
//   onPressed: () {
//     // _getData(searchQuery);
//     // ref.refresh(placesProvider);
//   },
//   child: Text('장소 검색', style: TextStyle(color: Colors.white)),
//   style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
// ),

// if (!places.isEmpty)
//   SizedBox(
//     height: 200,
//     child: ListView.builder(
//       itemBuilder: (context, index) {
//         final place = places[index];
//         return ListTile(
//           title: Text(place.name),
//           subtitle: Text(place.formatted_address),
//           trailing: Text('별점 : ${place.rating}'),
//           onTap: () {
//             setState(() {
//               pickPlace = Place(
//                 formatted_address: place.formatted_address,
//                 geometry: place.geometry,
//                 name: place.name,
//                 rating: place.rating,
//                 user_ratings_total: place.user_ratings_total,
//               );
//               places = [];
//             });
//           },
//         );
//       },
//       itemCount: places.length,
//     ),
//   ),

/// 화면 이동 순서와 어떻게 할것인지를 세세하게 생각해봐야하는데,,,
/// 검색창에 장소를 검색해서 결과가 리스트로 나온다.
/// 리스트(결과) 중 찾던 장소를 클릭하면 AlertDialog를 통해 WriteSnsScreen으로 이동이 가능한데, 이때 클릭한 해당 장소에  pickPlace(Place의 인스턴스)가 GMap 클래스에 인자로 넘어가
/// 구글맵에도 마커가 실시간으로 찍히는 것을 볼 수 있다. -> 이 마커 표시는 차후에 백엔드에 SNS 기록을 남긴 장소의 위도 경도를 불러와서 마커를 찍어 주는 방식으로 수정 해야하며.
///
/// 지금 확실하게 해야하는 것은 검색이나 지도를 확대해서 사용자가 직접 장소를 클릭했을때에도 WriteSnsScreen으로 이동해야하는 것이다.
/// GoogleMap()의 onTap(LatLng position) 으로 클릭한곳의 위도 경도를 받아오는데에는 문제가 없지만, 해당 장소의 지명 예를 들어 투썸플레이스 라는 지명을 가져오지는 못한다..
/// 또한 해당 위도와 경도에는 투썸플레이스 이외에도 다른 지명을 가진 장소가 존재 할 수 있기때문에.. 지도에서 직접 클릭을 통한 피드 작성 방식에는 사용자가 직접 장소명을 지정해야할 것  같다.
