import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // NumberFormat import

class AmountInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  AmountInputField({
    required this.controller,
    required this.hintText,
  });

  @override
  _AmountInputFieldState createState() => _AmountInputFieldState();
}

class _AmountInputFieldState extends State<AmountInputField> {
  final _formatter = NumberFormat('#,###'); // 천 단위로 끊는 포맷

  // 금액을 입력할 때마다 포맷팅을 적용하는 메서드
  void _onAmountChanged(String value) {
    // 숫자가 아닌 문자는 제거
    String sanitized = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (sanitized.isNotEmpty) {
      // 숫자에 천 단위 구분 기호를 추가
      final formatted = _formatter.format(int.parse(sanitized));
      widget.controller.text = formatted + " 원"; // 원 추가
      widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length-2)); // 커서 위치 조정
    } else {
      widget.controller.text = ''; // 숫자가 없으면 빈 값
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        // color: Color(0xFFE0E0E0), // INPUT_BORDER_COLOR
        width: 1.0,
      ),
    );

    return TextFormField(
      controller: widget.controller,
      // cursorColor: Color(0xFF1976D2), // PRIMARY_COLOR
      keyboardType: TextInputType.number,
      onChanged: _onAmountChanged,  // 값이 변경될 때마다 포맷팅
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          // color: Color(0xFF757575), // BODY_TEXT_COLOR
          fontSize: 14.0,
        ),
        // fillColor: Color(0xFFF5F5F5), // INPUT_BG_COLOR
        filled: true, // 배경색 있음
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
            borderSide: baseBorder.borderSide.copyWith(
              // color: Color(0xFF1976D2), // PRIMARY_COLOR
            )
        ),
      ),
    );
  }
}
