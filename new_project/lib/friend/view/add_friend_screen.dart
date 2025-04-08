import 'package:flutter/material.dart';
import 'package:new_project/common/component/custom_text_form_field.dart';
import 'package:new_project/common/layout/default_layout.dart';

import '../../common/const/colors.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  String friendIdOrNumber = '';
  bool isFriendExist = false;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      titleText: '친구 추가',
      IsaddButton: false,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFormField(
              hintText: '추가할 친구의 ID나 전화번호를 입력하세요.',
              onChanged: (String value) {
                friendIdOrNumber = value;
              },
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                //여기에 백엔드에 ID나 전화번호를 토대로 사용자 검색 post.
              },
              child: Text('검색', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
            ),
            SizedBox(height: 30.0),

            // if(!isFriendExist)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(width: 2, color: Colors.black),
              ),
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('이기혁'),
                subtitle: Text('안녕하세요. 이기혁입니다.'),
                trailing: IconButton(
                  onPressed: () {
                    CheckAddFriend();
                  },
                  icon: Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CheckAddFriend() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('이기혁님을 친구 추가 하시겠습니까?'),
          title: Text('친구 추가'),
          actions: [
            TextButton(
              onPressed: () {
                //친구추가하는 post메소드 요청하고 성공후에 pop
                Navigator.of(context).pop();
                //pop()하고 나서는 alertDialog하나더 , 누구 님을 친구추가 하였습니다.
              },
              child: Text('추가'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }
}
