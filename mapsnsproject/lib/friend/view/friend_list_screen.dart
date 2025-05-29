import 'package:flutter/material.dart';

import '../../common/layout/default_layout.dart';
import '../../profile/view/profile_screen.dart';
import '../../user/data/user_data.dart';
import 'add_friend_screen.dart';

class FriendListScreen extends StatefulWidget {
  const FriendListScreen({super.key});

  @override
  State<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
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

    ///친구 리스트에서 친구를 삭제하기 위해서 리스트 각 항목을 왼쪽으로 스와이프 하여 삭제 다이얼로그를 보여주어 삭제 로직을 진행할 계획. -> Dismissible Widget으로 감쌀거고
    ///confirmDismiss 속성함수를 통해 다이얼로그 띄우고, 확인 버튼 클릭시 , 삭제 로직을 진행하면 된다. , dismissible은 어떤 아이템을 삭제할 것인지 인지시켜줘야하기때문에 key값이 꼭 필요한데
    /// 필수 인자로 key: ObjectKey(item.id)를 지정해주어 인지시켜줌. -> 이렇게 로직을 추가해야함. -> 추가 완료.
    ///
    ///1.  나중에 백엔드에서 실제 친구 목록을 가져와서 리스트뷰에 매핑 시켜줘야함.
    ///2.  백엔드에서 불러오는 코드 및친구를 추가하고 삭제하는 부분 모두 riverPod으로 감싸서 코드 간결하게 하기.

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
            return Dismissible(
              key: ObjectKey(Id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                final shouldDelete = await showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text('삭제 확인'),
                      content: Text('“${name}” 을(를) 친구애서 삭제하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('취소'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('삭제'),
                        ),
                      ],
                    );
                  },
                );
                shouldDelete == true;
              },
              onDismissed: (direction) async {
                setState(() {
                  friendList.removeAt(index);
                  friendIDList.removeAt(index);
                  friendNumberList.removeAt(index);
                });
                await showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text('친구 삭제 완료'),
                      content: Text('${name}님과 친구관계가 끊어졌습니다!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('확인'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => ProfileScreen(

                          ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(name),
                  subtitle: Text('번호 : $number'),
                ),
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
