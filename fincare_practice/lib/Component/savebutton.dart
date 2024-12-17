import 'package:flutter/material.dart';

class Savebutton extends StatelessWidget {
  final String content;

  const Savebutton({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onSave,
      child: Text(
        content,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(400, 50),
        backgroundColor: Colors.blue,
      ),
    );
  }

  onSave() {}
}

// 편의점 피존 정전기 방지 스프레이
