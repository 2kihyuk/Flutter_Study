import 'package:json_annotation/json_annotation.dart';

import '../../common/const/data.dart';
import '../../common/utils/data_utils.dart';
part 'restaurant_model.g.dart';
enum RestaurantPriceRange {
  expensive,
  medium,
  cheap
}

///속성들은 api요청에 의해 받을 변수들인데,
///fromJson에 보면 반복적으로 속성들을 넣어주고있다.
///뭔가 반복적인 작업이 있다면 자동화가 안될까? 해야한다. 이 자동화를 해주는게 JsonSerializable
///이 클래스를 JsonSerializable로 자동으로 코드를 생성시킬거다.




@JsonSerializable()
class RestaurantModel {
  final String id;
  final String name;
  @JsonKey(
      fromJson: DataUtils.pathToUrl,  ///Json으로 부터 인스턴스를 만들고 싶을때 실행할 함수 , thumbUrl을
      )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;


  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });



  factory RestaurantModel.fromJson(Map<String,dynamic> json)
  => _$RestaurantModelFromJson(json);

  Map<String,dynamic> toJson() => _$RestaurantModelToJson(this);



  // factory RestaurantModel.fromJson({
  //   required Map<String, dynamic> json,
  // }){
  //   return RestaurantModel(
  //     id: json['id'],
  //     name: json['name'],
  //     thumbUrl: 'http://$ip${json['thumbUrl']}',
  //     tags: List<String>.from(json['tags']),
  //     priceRange: RestaurantPriceRange.values.firstWhere((
  //         e) => e.name == json['priceRange'],),
  //     ratings: json['ratings'],
  //     ratingsCount: json['ratingsCount'],
  //     deliveryTime: json['deliveryTime'],
  //     deliveryFee: json['deliveryFee'],
  //   );
  // }


}