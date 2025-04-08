import 'package:flutter/material.dart';
import 'package:new_project/common/data/user_data.dart';
import 'package:new_project/common/layout/default_layout.dart';
import 'package:new_project/friend/view/add_friend_screen.dart';
import 'package:new_project/profile/view/profile_screen.dart';

class FriendListScreen extends StatelessWidget {
  const FriendListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> friendList = ["1", "2", "3", "4", "5"];
    List<String> friendIDList = ["a", "b", "c", "d", "e"];
    List<String> friendNumberList = [
      "010-1111-1111",
      "010-2222-2222",
      "010-3333-3333",
      "010-4444-4444",
      "010-5555-5555",
    ];

    return DefaultLayout(
      IsaddButton: true,
      // IsaddButton 속성을 true로 DefaultLayout에 넘겨주어, 이 화면에만 타이틀바 오른쪽에 친구 추가 버튼 생성.
      titleText: '친구 목록',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (_, index) {
            String name = friendList[index];
            String number = friendNumberList[index];
            String Id = friendIDList[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => ProfileScreen(
                          user: User(
                            user_Name: name,
                            user_ID: Id,
                            user_Number: number,
                            isUserIsMe: false,
                          ),
                        ),
                  ),
                );
              },
              child: ListTile(
                title: Text(name),
                subtitle: Text('번호 : $number'),
              ),
            );
          },
          separatorBuilder: (_, index) {
            return Divider();
          },
          itemCount: friendList.length,
        ),
      ),
      onAddButtonPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => AddFriendScreen()));
      },
    );
  }
}
