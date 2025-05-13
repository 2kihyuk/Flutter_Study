import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_common/vm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SnsPostModel {
  final int? userId;
  final int? markerId;
  final String placeName;
  final double placeLat;
  final double placeLng;
  final String? formattedAddress;
  final String content;
  final String imgPath;

  SnsPostModel({
    this.userId,
    this.markerId,
    required this.placeName,
    required this.placeLat,
    required this.placeLng,
    this.formattedAddress,
    required this.content,
    required this.imgPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'placeName': placeName,
      if (formattedAddress != null)
        'formattedAddress': formattedAddress,
      'placeLat': placeLat,
      'placeLng': placeLng,
      'content': content,
      'imgPath': imgPath,
    };
  }

  //서버에서 sns게시물 데이터 받아와서 매핑할때 쓸 fromJson.
  factory SnsPostModel.fromJson(Map<String, dynamic> json) {
    return SnsPostModel(
      markerId: json['markerId'] as int?,
      userId: json['userId'] as int?,
      placeName: json['placeName'],
      placeLat: json['placeLat'],
      placeLng: json['placeLng'],
      content: json['content'],
      imgPath: json['imgPath'],
    );
  }

}


final UploadImgS3Provider = FutureProvider.family<String,File>((ref,file) async{

  await Amplify.Auth.fetchAuthSession();
  // 1) AWSFilePlatform 래핑
  final awsFile = AWSFilePlatform.fromFile(file);

  // 2) S3 버킷 내 저장 경로 정의
  final key = 'user_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
  final storagePath = StoragePath.fromString(key);

  // 3) 업로드 (public-read)
  await Amplify.Storage.uploadFile(
    localFile: awsFile,
    path: storagePath,
  ).result;

  final bucket = 'mapsnsproject1504616c5-dev';
  final region = 'ap-northeast-2';
  return 'https://$bucket.s3.$region.amazonaws.com/$key';

  // final urlResult = await Amplify.Storage.getUrl(path: storagePath).result;
  //
  // return urlResult.url.toString();

});
