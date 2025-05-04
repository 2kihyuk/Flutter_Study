import 'package:flutter/material.dart';
import 'package:mapsnsproject/common/layout/default_layout.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final nameController = TextEditingController();
  final IdController = TextEditingController();
  final stateMController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      titleText: '프로필 수정',
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('이름 : 이기혁', style: TextStyle(fontSize: 16.0)),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                  ),
                  hintText: '변경할 이름을 입력하세요.',
                ),
              ),
              SizedBox(height: 20.0),
              Text('ID : kihyuk5566', style: TextStyle(fontSize: 16.0)),
              TextField(
                controller: IdController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                  ),
                  hintText: '변경할 ID를 입력하세요.',
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                '상태 메시지 : 안녕하세요. 저는 이기혁입니다.',
                style: TextStyle(fontSize: 16.0),
              ),
              TextField(
                controller: stateMController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                  ),
                  hintText: '변경할 상태 메시지를 입력하세요.',
                ),
              ),
              Text(''),
            ],
          ),
        ),
      ),
      IsaddButton: false,
    );
  }
}
