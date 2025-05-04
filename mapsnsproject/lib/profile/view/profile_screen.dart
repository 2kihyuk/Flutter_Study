import 'package:flutter/material.dart';
import 'package:mapsnsproject/profile/view/profile_edit_screen.dart';
import 'package:mapsnsproject/profile/view/sns_feed_screen.dart';

import '../../common/layout/default_layout.dart';
import '../../user/data/user_data.dart';

class ProfileScreen extends StatefulWidget {
  //프로필 스크린에 대한 구조를 한개만 만들어 두고, 인자로 어떤 사용자에 대한 프로필을 받을 것인지를 받아서, 렌더링 해주는 방식으로 구현할 생각.
  final User user;

  ProfileScreen({required this.user, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {

    List<String> Imglink = [
      'https://picsum.photos/250?image=9',
      'https://picsum.photos/250?image=9',
      'https://picsum.photos/250?image=9',
      'https://picsum.photos/250?image=9',
    ];

    return DefaultLayout(
      IsaddButton: false,
      titleText: '${widget.user.user_ID}',
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
                      Text('이름 : ${widget.user.user_Name}'),
                      SizedBox(height: 16),
                      Text('안녕하세요. ${widget.user.user_Name}입니다.'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            //가운데 프로필 수정 버튼.
            renderSizedBox(),
            SizedBox(height: 20),

            //피드를 그리드뷰로 배치.
            Expanded(
              child: GridView.builder(
                itemCount: Imglink.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
                  mainAxisSpacing: 10, //수평 Padding
                  crossAxisSpacing: 10, //수직 Padding
                ),
                itemBuilder: (BuildContext context, int index) {
                  String img = Imglink[index];
                  return GestureDetector(
                    onTap: () {
                      //해당 피드 눌렀을때 해당 피드 디테일로 이동.
                      print(index);
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=> SnsFeedScreen()));
                    },
                    //child에 사진 주소. 그럼 일단 사진 업로드부터.
                    child: Image.network(img),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderSizedBox() {
    if (widget.user.isUserIsMe) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Colors.white,
            ), // 배경색 변경
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfileEditScreen()));
          },
          child: Text('프로필 수정',style: TextStyle(color: Colors.black),),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Colors.white,
                ), // 배경색 변경
              ),
              onPressed: () {},
              child: Text('친구 삭제', style: TextStyle(color: Colors.black)),
            ),
          ),
          SizedBox(width: 10), // 버튼 사이에 여백 추가
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Colors.white,
                ), // 배경색 변경
              ),
              onPressed: () {},
              child: Text('메시지', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      );
    }
  }
}
