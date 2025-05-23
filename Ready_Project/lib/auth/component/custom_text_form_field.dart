import 'package:flutter/material.dart';

import '../../common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autoFocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({required this.onChanged,this.autoFocus =false, this.obscureText = false, this.hintText,this.errorText, super.key,});

  @override
  Widget build(BuildContext context) {

    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(

        width: 1.0,
      ),
    );

    return TextFormField(
      // cursorColor: PRIMARY_COLOR,
      //비밀번호 입력할때
      obscureText: obscureText,
      autofocus: autoFocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(
          fontSize: 14.0,
        ),
        // fillColor: INPUT_BG_COLOR,
        // filled: true, ///배경색 있음 true / 배경색 없음 false.
        //모든 Input상태의 기본 스타일 세팅.
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
            borderSide: baseBorder.borderSide.copyWith(

            )
        ),
      ),
    );
  }
}