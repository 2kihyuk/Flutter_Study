import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  const ToggleButton({super.key});

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {


    return ToggleButtons(
      isSelected: [selectedIndex == 0, selectedIndex == 1],
      // 선택 상태 표시
      onPressed: (index) {
        setState(() {
          selectedIndex = index; // 버튼 클릭 시 선택된 인덱스 업데이트
        });
      },
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0), // 버튼 간격
          child: Text('수입',
              style: TextStyle(
                fontSize: 12,
                fontWeight: selectedIndex == 0 ? FontWeight.bold : FontWeight.normal, // 선택된 버튼은 볼드
                color: selectedIndex == 0 ? Colors.black : Colors.black.withOpacity(0.5),
              )),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0), // 버튼 간격
          child: Text('지출',
              style: TextStyle(
                fontSize: 12,
                fontWeight: selectedIndex == 1 ? FontWeight.bold : FontWeight.normal, // 선택된 버튼은 볼드
                color: selectedIndex == 1 ? Colors.black : Colors.black.withOpacity(0.5),
              )),
        ),
      ],
      borderRadius: BorderRadius.circular(10),
      // 테두리 둥글게
      borderWidth: 0,
      // 테두리 없음
      selectedBorderColor: Colors.transparent,
      // 선택된 버튼의 테두리 제거
      selectedColor: Colors.black,
      // 선택된 버튼 텍스트 색
      fillColor: Colors.transparent,
      // 배경색 투명
      color: Colors.black.withOpacity(0.5),
      // 비선택된 버튼 텍스트 색
      constraints: BoxConstraints(
        minWidth: 55, // 버튼 최소 너비
        minHeight: 40, // 버튼 최소 높이
      ),
    );
  }
}
