import 'package:flutter/material.dart';

class Savebutton extends StatelessWidget {
  final String content;
  final VoidCallback onSave;

  const Savebutton({required this.onSave, required this.content, super.key});

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


}

// 편의점 피존 정전기 방지 스프레이
