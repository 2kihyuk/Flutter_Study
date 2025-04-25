import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mapsnsproject/common/component/custom_text_form_field.dart';
import 'package:mapsnsproject/common/const/colors.dart';
import 'package:mapsnsproject/common/layout/default_layout.dart';
import 'package:mapsnsproject/map/data/sns_post_data.dart';
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
    String positionPlaceName = '';

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

                          onChanged: (String value) {
                            positionPlaceName = value;
                          },
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
                        ? Icon(
                          Icons.photo_outlined,
                          size: 50,
                          color: Colors.white,
                        )
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
                onPressed: () async{


                  // if (position == null) {
                  //   _MakePlacePostModel(place, contentController.text);
                  // } else {
                  //   _MakePositionPlaceModel(position!,positionPlaceName,contentController.text);
                  // }


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


  ///사진 업로드 방식 : AWS S3를 이용하여, 앱에서 전송 버튼 클릭 시  우선적으로 S3에 사진을 업로드 한 후, 해당 이미지의 경로를 반환 받아서, 그 경로를 데이터모델에 넣어서 서버에 post해야함.

  // Future<String> UploadImgS3(File imageFile) async {
  //   try {
  //     final String bucketName = 'mapsnsproject1504';
  //     final String accessKey = 'YOUR_AWS_ACCESS_KEY';
  //     final String secretKey = 'YOUR_AWS_SECRET_KEY';
  //     final String region = 'ap-northeast-2'; // 예시 리전
  //
  //     final String filePath = 'user_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
  //     final uri = Uri.parse('https://$bucketName.s3.$region.amazonaws.com/$filePath');
  //
  //     // HTTP PUT 요청을 사용하여 파일을 S3로 업로드
  //     final request = http.MultipartRequest('PUT', uri);
  //     request.headers['x-amz-acl'] = 'public-read';  // 퍼블릭 읽기 권한 설정
  //     request.headers['Content-Type'] = 'image/jpeg';  // 이미지 타입 설정
  //
  //     // 업로드할 파일을 첨부
  //     request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
  //
  //     // 요청을 서버로 전송
  //     final response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       // 업로드 성공 시 파일 URL을 반환
  //       final imageUrl = 'https://$bucketName.s3.$region.amazonaws.com/$filePath';
  //       print('Image uploaded successfully: $imageUrl');
  //       return imageUrl;  // 이미지 URL 반환
  //     } else {
  //       print('Image upload failed with status code: ${response.statusCode}');
  //       return '';  // 실패 시 빈 문자열 반환
  //     }
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //     return '';  // 오류 발생 시 빈 문자열 반환
  //   }
  // }

  SnsPostModel _MakePlacePostModel(Place place, String content) {
    SnsPostModel placeModel = SnsPostModel(
      placeName: place.name,
      formatted_address: place.formatted_address,
      placeLat: place.geometry.location.lat,
      placeLng: place.geometry.location.lng,
      content: content,
      ImgPath: 'ImgPath',
    );
    print(
      'placeModel : ${placeModel.placeName} , ${placeModel.formatted_address} , ${placeModel.placeLat} / ${placeModel.placeLng} ,${placeModel.content} , ${placeModel.ImgPath}',
    );
    return placeModel;
  }

  SnsPostModel _MakePositionPlaceModel(LatLng position, String positionPlaceName, String content) {
    SnsPostModel positionModel = SnsPostModel(
      placeName: positionPlaceName,
      placeLat: position.latitude,
      placeLng: position.longitude,
      content: content,
      ImgPath: 'ImgPath',
    );

    print('positionModel : ${positionModel.placeName} , ${positionModel.placeLat} / ${positionModel.placeLng} ,${positionModel.content} , ${positionModel.ImgPath}',);
    return positionModel;
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
