import 'dart:io';
import 'dart:io' as io;

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_common/vm.dart';
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
import 'package:mapsnsproject/map/repository/place_repository.dart';
import '../data/address_data.dart';
import '../repository/image_repository.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class WriteSnsScreen extends ConsumerWidget {
  final LatLng? position;

  const WriteSnsScreen({this.position, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final place = ref.watch(pickPlaceProvider.notifier).state;
    final XFile? _image = ref.watch(imageProvider);
    final ImagePicker imagePicker = ref.watch(imagePickerProvider);
    final positionPlaceName = ref.watch(positionPlaceNameProvider);

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
                            ref.read(positionPlaceNameProvider.notifier).state =
                                value;
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
                onPressed: () async {
                  try{
                    final file = File(_image!.path);

                    final imgUrl = await ref.read(
                      UploadImgS3Provider(file).future,
                    );
                    print(imgUrl);

                    final model = position == null ? _MakePlacePostModel(place, contentController.text, imgUrl) :  _MakePositionPlaceModel(
                      position!,
                      positionPlaceName,
                      contentController.text,
                      imgUrl,
                    );
                    ///model을 post 하는 방식으로..
                    ///repository에 post하는 코드를 작성해서 riverPod.

                    // await ref.read(mapRepositoryProvider).createPost(model);

                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('성공'),
                        content: Text('피드가 성공적으로 등록되었습니다.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('확인'),
                          ),
                        ],
                      ),
                    );

                    // 5) 다이얼로그 닫힌 뒤, 화면도 pop
                    Navigator.of(context).pop();
                  }catch(e){
                    // 6) 실패 다이얼로그
                    await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                      title: Text('실패'),
                      content: Text('피드 등록에 실패했습니다.\n$e'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('확인'),
                        ),
                      ],
                    ),
                    );
                  }


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

  SnsPostModel _MakePlacePostModel(Place place, String content, String imgUrl) {
    SnsPostModel placeModel = SnsPostModel(
      placeName: place.name,
      formatted_address: place.formatted_address,
      placeLat: place.geometry.location.lat,
      placeLng: place.geometry.location.lng,
      content: content,
      ImgPath: imgUrl,
    );
    print(
      'placeModel : ${placeModel.placeName} , ${placeModel.formatted_address} , ${placeModel.placeLat} / ${placeModel.placeLng} ,${placeModel.content} , ${placeModel.ImgPath}',
    );
    return placeModel;
  }

  SnsPostModel _MakePositionPlaceModel(
    LatLng position,
    String positionPlaceName,
    String content,
    String imgUrl,
  ) {
    SnsPostModel positionModel = SnsPostModel(
      placeName: positionPlaceName,
      placeLat: position.latitude,
      placeLng: position.longitude,
      content: content,
      ImgPath: imgUrl,
    );

    print(
      'positionModel : ${positionModel.placeName} , ${positionModel.placeLat} / ${positionModel.placeLng} ,${positionModel.content} , ${positionModel.ImgPath}',
    );
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

/// S3에 업로드하고, 업로드된 퍼블릭 URL을 반환합니다.
// Future<String> uploadImageToS3(io.File imageFile) async {
//   // 1) S3 내에 저장할 “key” (파일 경로)
//   final key = 'user_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
//
//   // 2) String → StoragePath 변환
//   final storagePath = StoragePath.fromString(key);
//   final awsFile = AWSFilePlatform.fromFile(imageFile);
//
//
//   // 3) 파일 업로드
//   await Amplify.Storage.uploadFile(
//     localFile: awsFile,              // dart:io File
//     path: storagePath,             // StoragePath
//   );
//
//   // 4) 업로드된 객체의 URL 얻기
//   final urlResult = await Amplify.Storage.getUrl(
//     path: storagePath,             // StoragePath
//   );
//
//   // 5) URL 반환
//   return urlResult.url;
// }

/// 선택된 io.File을 S3에 업로드하고, public URL만 반환합니다.
// Future<String> uploadImageToS3(io.File file) async {
//   await Amplify.Auth.fetchAuthSession();
//   // 1) AWSFilePlatform 래핑
//   final awsFile = AWSFilePlatform.fromFile(file);
//
//   // 2) S3 버킷 내 저장 경로 정의
//   final key = 'user_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
//   final storagePath = StoragePath.fromString(key);
//
//   // 3) 업로드 (public-read)
//   await Amplify.Storage.uploadFile(
//     localFile: awsFile,
//     path: storagePath,
//   ).result;
//
//   final urlResult = await Amplify.Storage.getUrl(path: storagePath).result;
//
//   return urlResult.url.toString();
// }
