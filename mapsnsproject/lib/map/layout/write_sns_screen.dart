import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapsnsproject/common/component/custom_text_form_field.dart';
import 'package:mapsnsproject/common/const/colors.dart';
import 'package:mapsnsproject/common/layout/default_layout.dart';
import 'package:mapsnsproject/map/repository/map_repository.dart';

import '../data/address_data.dart';
import '../repository/image_repository.dart';

class WriteSnsScreen extends ConsumerWidget {
  final LatLng? position;

  const WriteSnsScreen({this.position, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final place = ref.watch(pickPlaceProvider.notifier).state;
    final XFile? _image = ref.watch(imageProvider);
    final ImagePicker imagePicker = ref.watch(imagePickerProvider);

    TextEditingController contentController = TextEditingController();

    Future getImage(ImageSource imageSource) async {
      final XFile? pickedFile = await imagePicker.pickImage(
        source: imageSource,
      );
      if (pickedFile != null) {
        // 이미지를 선택한 후 StateProvider에 저장
        ref.read(imageProvider.notifier).state = pickedFile;
      }
    }

    return DefaultLayout(
      titleText: '피드 작성',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    position == null
                        ? Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.green),
                            SizedBox(width: 8.0),
                            Text('지명(장소명) : ${place.name}'),
                          ],
                        )
                        : CustomTextFormField(
                          onChanged: (String value) {},
                          hintText: '장소명을 입력하세요.',
                        ),
                    SizedBox(height: 8.0),

                    position == null
                        ? Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.green),
                            SizedBox(width: 8.0),
                            Text('주소 : ${place.formatted_address}'),
                          ],
                        )
                        : Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.green),
                            SizedBox(width: 8.0),
                            Text(
                              '위치 : ${position?.latitude} / ${position?.longitude}',
                            ),
                          ],
                        ),
                    SizedBox(height: 8.0),
                    if (position == null)
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.orange),
                          SizedBox(width: 8.0),
                          Text(
                            place.openingHours?.openNow == true
                                ? '영업중'
                                : '영업 종료',
                          ),
                        ],
                      ),
                    SizedBox(height: 8.0),
                    if (position == null)
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          SizedBox(width: 8.0),
                          Text('별점 : ${place.rating}'),
                        ],
                      ),
                    SizedBox(height: 8.0),
                    if (position == null)
                      Row(
                        children: [
                          Icon(Icons.comment, color: Colors.grey),
                          SizedBox(width: 8.0),
                          Text('리뷰 개수 : ${place.user_ratings_total}'),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
                child: Text(_image == null ? '사진 추가' : '사진 변경'),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Colors.grey,
                ),
                child:
                    _image == null
                        ? Icon(Icons.photo_outlined, size: 50, color: Colors.white)
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            File(_image!.path),
                            fit: BoxFit.cover, // 비율을 유지하면서 영역을 덮음
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
              ),
              SizedBox(height: 16.0),
              Text('본문 작성'),
              SizedBox(height: 8.0),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.greenAccent,
                      width: 2.0,
                    ),
                  ),
                ),
                maxLines: 7,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  ///1번 데이터 모델 : 장소를 검색해서 들어왔다면, place객체에 존재하는 지명, 좌표, 사진, 본문내용을 묶어서 서버에 post.
                  ///2번 데이터 모델 : 지도에서 장소를 찍어서 들어왔다면, 지명텍스트필드에 입력한 사용자 지정 장소명 , position.latitude를 위도, position.longtitude를 경도, 사진, 본문내용을
                  ///묶어서 서버에 post.
                  ///position이 NULL값인지 아닌지를 구분해서 데이터모델을 어떤걸 선택할 것인지 분리하는 로직을 작성해야함.
                },
                style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
                child: Text('작성 하기 ', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
      IsaddButton: false,
    );
  }
}

//만약 position값이 존재한다면 -> 검색이 아닌 구글맵에서 직접 클릭한 장소의 좌표만 가지고 글 작성을 하는 것이기 때문에, 장소명과 다른 정보들을 입력할 수 있는 텍스트 필드를 만들기.
///position이 없다? -> 검색을 통해 찾은 장소 정보를 모두 가지고와서 글 작성 하는 것이기 때문에 , state에 담긴 정보를 그대로 넣어둔 상태로 sns글 작성하면 된다.
// Text('장소 이름 : ${place.name}'),
// Text('장소 주소 : ${place.formatted_address}'),
// Text('장소 위도/ 경도 : ${place.geometry.location.lat}'), Text('${place.geometry.location.lng}'),
// Text('장소 평점 : ${place.rating}'),
// Text('장소 리뷰 갯수 : ${place.user_ratings_total}'),
//   Text('-------------------------'),
//   Text('지도에서 직접 클릭한 장소의 좌표 : ${position?.latitude} , ${position?.longitude}')
