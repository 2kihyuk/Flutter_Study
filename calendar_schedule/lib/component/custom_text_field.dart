import 'dart:math';

import 'package:calendar_schedule/const/color.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool expand;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  const CustomTextField({
    required this.validator,
    required this.onSaved,
    required this.label,
    this.expand = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        if(!expand)
        renderTextFormField(),
        if (expand)
          Expanded(
            child: renderTextFormField(),
          )
      ],
    );
  }

  renderTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
      ),
      onSaved: onSaved,  //저장했을때
      validator: validator, //검증할때 로직
      maxLines: expand? null :1,
      minLines:  expand? null : 1,
      expands: expand,
      cursorColor: Colors.grey,
    );
  }
}
