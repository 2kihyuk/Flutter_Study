import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapsnsproject/common/layout/default_layout.dart';
import 'package:mapsnsproject/map/layout/write_sns_screen.dart';
import 'package:mapsnsproject/map/repository/map_repository.dart';
import 'package:mapsnsproject/map/layout/g_map.dart';
import 'package:mapsnsproject/map/repository/place_repository.dart';
import '../../common/component/custom_text_form_field.dart';
import '../model/address_data.dart';
import '../repository/marker_repository.dart';

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
  bool listIsExpanded = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final placesAsyncValue = ref.watch(placesProvider);
    // ChIJhUS2MhKcfDUR30HeqHh32O8
    final markersAsync = ref.watch(markersProvider);

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
                          onCameraIdle:
                              _CheckFeedAlertDialog, //onCameraIdle로 다이얼로그를 띄우는 함수를 GMap에 넘겨서 , GMap에서 CameraAnimate().then으로 카메라 이동이 끝나면, 해당 함수를 바로 실행할 수 있게 설정.
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),


            /// ExpansionTile에 방문했던 장소들 리스트로 띄워주기... 그리고 방문했던 장소들에 대한 위도 경도 좌표 받아서, 마커로 세팅 해두기. 클릭하면 해당 장소에 대한 피드 보이게.
              // ExpansionTile(
              //   leading: Icon(Icons.list_outlined),
              //   title: Text(
              //     listIsExpanded ? '리스트 접기' : '리스트 펼치기',
              //     style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
              //   ),
              //   initiallyExpanded: listIsExpanded,
              //   onExpansionChanged: (bool expanding) {
              //     setState(() {
              //       listIsExpanded = expanding;
              //     });
              //   },
              //   children: [
              //     ListView.separated(
              //       itemBuilder: (context, index) {
              //         final item = list[index];
              //         return ListTile(
              //           title: item.placeName,
              //           subtitle: item.formattedAddress,
              //         );
              //       },
              //       separatorBuilder: (context, index) {
              //         return Divider();
              //       },
              //       itemCount: list.length,
              //     ),
              //   ],
              // ),

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

/// 화면 이동 순서와 어떻게 할것인지를 세세하게 생각해봐야하는데,,,
/// 검색창에 장소를 검색해서 결과가 리스트로 나온다.
/// 리스트(결과) 중 찾던 장소를 클릭하면 AlertDialog를 통해 WriteSnsScreen으로 이동이 가능한데, 이때 클릭한 해당 장소에  pickPlace(Place의 인스턴스)가 GMap 클래스에 인자로 넘어가
/// 구글맵에도 마커가 실시간으로 찍히는 것을 볼 수 있다. -> 이 마커 표시는 차후에 백엔드에 SNS 기록을 남긴 장소의 위도 경도를 불러와서 마커를 찍어 주는 방식으로 수정 해야하며.
///
/// 지금 확실하게 해야하는 것은 검색이나 지도를 확대해서 사용자가 직접 장소를 클릭했을때에도 WriteSnsScreen으로 이동해야하는 것이다.
/// GoogleMap()의 onTap(LatLng position) 으로 클릭한곳의 위도 경도를 받아오는데에는 문제가 없지만, 해당 장소의 지명 예를 들어 투썸플레이스 라는 지명을 가져오지는 못한다..
/// 또한 해당 위도와 경도에는 투썸플레이스 이외에도 다른 지명을 가진 장소가 존재 할 수 있기때문에.. 지도에서 직접 클릭을 통한 피드 작성 방식에는 사용자가 직접 장소명을 지정해야할 것  같다.
///  ExpansionTile(
//                 title: Text('내가 남긴 피드 (${markersAsync.asData?.value.length ?? 0})'),
//                 // 들어가자마자 펼쳐지게 하려면:
//                 initiallyExpanded: true,
//                 childrenPadding: EdgeInsets.symmetric(horizontal: 16),
//                 children: [
//                   markersAsync.when(
//                     data: (markers) {
//                       if (markers.isEmpty) {
//                         return Padding(
//                           padding: EdgeInsets.all(16),
//                           child: Text('등록된 피드가 없습니다.'),
//                         );
//                       }
//                       // ExpansionTile 의 children 은 List<Widget> 이어야 하므로
//                       return Column(
//                         children: markers.map((m) {
//                           return ListTile(
//                             leading: Image.network(
//                               m.imgPath,
//                               width: 48,
//                               height: 48,
//                               fit: BoxFit.cover,
//                             ),
//                             title: Text(m.placeName),
//                             subtitle: Text(
//                               m.content,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             // onTap: () {
//                             //   // 상세화면으로 이동
//                             //   Navigator.of(context).push(
//                             //     MaterialPageRoute(
//                             //       builder: (_) => SnsFeedScreen(/* pass model or id */),
//                             //     ),
//                             //   );
//                             // },
//                           );
//                         }).toList(),
//                       );
//                     },
//                     loading: () => Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Center(child: CircularProgressIndicator()),
//                     ),
//                     error: (e, _) => Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Text('에러가 발생했습니다: $e'),
//                     ),
//                   )
//                 ],
//               ),



