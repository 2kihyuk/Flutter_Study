class SnsPostModel {
  final String placeName;
  final double placeLat;
  final double placeLng;
  final String? formatted_address;
  final String content;
  final String ImgPath;

  SnsPostModel({
    required this.placeName,
    required this.placeLat,
    required this.placeLng,
    this.formatted_address,
    required this.content,
    required this.ImgPath,
  });

  //서버에서 sns게시물 데이터 받아와서 매핑할때 쓸 fromJson.
  factory SnsPostModel.fromJson(Map<String, dynamic> json) {
    return SnsPostModel(
      placeName: json['placeName'],
      placeLat: json['placeLat'],
      placeLng: json['placeLng'],
      content: json['content'],
      ImgPath: json['ImgPath'],
    );
  }

}
