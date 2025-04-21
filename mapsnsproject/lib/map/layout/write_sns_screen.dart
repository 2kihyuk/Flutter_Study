import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapsnsproject/common/layout/default_layout.dart';
import 'package:mapsnsproject/map/repository/map_repository.dart';

import '../data/address_data.dart';

class WriteSnsScreen extends ConsumerWidget {
  final LatLng? position;
  const WriteSnsScreen({this.position,super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final place = ref.watch(pickPlaceProvider.notifier).state;

    return DefaultLayout(
      titleText: '피드 작성',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///만약 position값이 존재한다면 -> 검색이 아닌 구글맵에서 직접 클릭한 장소의 좌표만 가지고 글 작성을 하는 것이기 때문에, 장소명과 다른 정보들을 입력할 수 있는 텍스트 필드를 만들기.
            ///position이 없다? -> 검색을 통해 찾은 장소 정보를 모두 가지고와서 글 작성 하는 것이기 때문에 , state에 담긴 정보를 그대로 넣어둔 상태로 sns글 작성하면 된다.
          Text(place.name),
          Text(place.formatted_address),
          Text('${place.geometry.location.lat}'), Text('${place.geometry.location.lng}'),
          Text('${place.user_ratings_total}'),
            Text('-------------------------'),
            Text('지도에서 직접 클릭한 장소의 좌표 : ${position?.latitude} , ${position?.longitude}')
        ],
        ),
      ),
      IsaddButton: false,
    );
  }
}
