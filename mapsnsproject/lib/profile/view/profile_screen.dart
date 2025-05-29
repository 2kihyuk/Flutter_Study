import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mapsnsproject/profile/view/profile_edit_screen.dart';
import 'package:mapsnsproject/profile/view/sns_feed_screen.dart';
import 'package:mapsnsproject/user/data/user_token.dart';
import 'package:mapsnsproject/user/repository/auth_repository.dart';
import '../../common/layout/default_layout.dart';
import '../../map/repository/marker_repository.dart';
import '../../user/data/user_data.dart';
import '../../user/view/login_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  //프로필 스크린에 대한 구조를 한개만 만들어 두고, 인자로 어떤 사용자에 대한 프로필을 받을 것인지를 받아서, 렌더링 해주는 방식으로 구현할 생각.

  ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserData();
  }
  Future<void> _getUserData() async {
    final url = Uri.parse('$baseUrl/api/users/me');
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: ACCESS_TOKEN_KEY);

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        setState(() {
          user = User.fromJson(jsonDecode(response.body));
          isLoading = false;
        });
      } else {
        print('profile_screen -getUserData - Error - ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('profile_screen - _getUserData() - Error $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final markersAsync = ref.watch(markersProvider);

    if (isLoading) {
      return DefaultLayout(
        IsaddButton: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return DefaultLayout(
        IsaddButton: false,
        child: Center(child: Text('사용자 정보를 불러오지 못했습니다.')),
      );
    }

    return DefaultLayout(
      IsaddButton: false,
      titleText: '${user?.user_ID}',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Icon(Icons.person, size: 60), // 기본 아이콘
                  ),
                  SizedBox(width: 50),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('이름 : ${user?.user_Name}'),
                      SizedBox(height: 16),
                      Text('안녕하세요. ${user?.user_Name} 입니다.'),
                      Text('번호 : ${user?.user_Number}'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            //가운데 프로필 수정 버튼.
            // renderSizedBox(),
            SizedBox(height: 20),

            markersAsync.when(
                data: (posts) {
                  final imageUrls = posts.map((e) => e.imgPath).toList();
                  return GridView.builder(
                    itemCount: imageUrls.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
                      mainAxisSpacing: 10, //수평 Padding
                      crossAxisSpacing: 10, //수직 Padding
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final url = imageUrls[index];
                      final post = posts[index];
                      return GestureDetector(
                        onTap: () {
                          //해당 피드 눌렀을때 해당 피드 디테일로 이동.
                          print(index);
                          print(post.markerId);
                          ///이 부분에 인자로 가는 MARkerId 에 post.markerId로 바꿔야함.
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=> SnsFeedScreen(markerId: post.markerId!,)));
                        },
                        //child에 사진 주소. 그럼 일단 사진 업로드부터.
                        child: Image.network(url),
                      );
                    },
                  );
                },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('게시물 로드 실패: $e')),
            ),
            //피드를 그리드뷰로 배치.

            // ElevatedButton(
            //   onPressed: () {
            //     _getData();
            //   },
            //   child: Text('게시물 불러오기'),
            // ),
            ElevatedButton(
              onPressed: () async {
                await ref.read(authRepositoryProvider).Logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (_) => false,
                );
              },
              child: Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> _getData() async {
  //
  //   final url = Uri.parse('http://43.201.222.85:8080/api/markers');
  //   final storage = FlutterSecureStorage();
  //   final token = await storage.read(key: ACCESS_TOKEN_KEY);
  //   print(token);
  //
  //   try {
  //     final response = await http.get(
  //       url,
  //       headers: {'Authorization': 'Bearer $token'},
  //     );
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print(response.body);
  //     } else {
  //       print('profile_screen - else Error - ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('profile_screen  - _getData() - try-catch Error ${e}');
  //   }
  // }



  // Widget renderSizedBox() {
  //   if (widget.user.isUserIsMe) {
  //     return SizedBox(
  //       width: double.infinity,
  //       child: ElevatedButton(
  //         style: ButtonStyle(
  //           backgroundColor: WidgetStateProperty.all(Colors.white), // 배경색 변경
  //         ),
  //         onPressed: () {
  //           Navigator.of(
  //             context,
  //           ).push(MaterialPageRoute(builder: (_) => ProfileEditScreen()));
  //         },
  //         child: Text('프로필 수정', style: TextStyle(color: Colors.black)),
  //       ),
  //     );
  //   } else {
  //     return Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         Expanded(
  //           child: ElevatedButton(
  //             style: ButtonStyle(
  //               backgroundColor: WidgetStateProperty.all(
  //                 Colors.white,
  //               ), // 배경색 변경
  //             ),
  //             onPressed: () {},
  //             child: Text('친구 삭제', style: TextStyle(color: Colors.black)),
  //           ),
  //         ),
  //         SizedBox(width: 10), // 버튼 사이에 여백 추가
  //         Expanded(
  //           child: ElevatedButton(
  //             style: ButtonStyle(
  //               backgroundColor: WidgetStateProperty.all(
  //                 Colors.white,
  //               ), // 배경색 변경
  //             ),
  //             onPressed: () {},
  //             child: Text('메시지', style: TextStyle(color: Colors.black)),
  //           ),
  //         ),
  //       ],
  //     );
  //   }
  // }
}



// Expanded(
// child: GridView.builder(
// itemCount: Imglink.length,
// shrinkWrap: true,
// gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// crossAxisCount: 3,
// childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
// mainAxisSpacing: 10, //수평 Padding
// crossAxisSpacing: 10, //수직 Padding
// ),
// itemBuilder: (BuildContext context, int index) {
// String img = Imglink[index];
// return GestureDetector(
// onTap: () {
// //해당 피드 눌렀을때 해당 피드 디테일로 이동.
// print(index);
// Navigator.of(context).push(MaterialPageRoute(builder: (_)=> SnsFeedScreen()));
// },
// //child에 사진 주소. 그럼 일단 사진 업로드부터.
// child: Image.network(img),
// );
// },
// ),
// ),