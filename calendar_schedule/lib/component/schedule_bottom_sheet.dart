import 'package:flutter/material.dart';
import 'package:calendar_schedule/const/color.dart';
import 'package:calendar_schedule/component/custom_text_field.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;
  String? category;

  String selectedColor = categoryColors.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 600,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _Time(
                  onEndSaved: onEndTimeSave,
                  onEndValidate: onEndTimeValidate,
                  onStartSaved: onStartTimeSaved,
                  onStartValidate: onStartTimeValidate,
                ),
                SizedBox(height: 8.0),
                _Content(
                  onSaved: onContentSaved,
                  onValidate: onContentValidate,
                ),
                SizedBox(height: 8.0),
                _Categories(
                  selectedColor: selectedColor,
                  onTap: (String color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                _SaveButton(
                  onPressed: onSavePressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onStartTimeSaved(String? val) {
    if (val == null) {
      return;
    }
    startTime = int.parse(val);
  }

  String? onStartTimeValidate(String? val) {
    if(val == null){
      return '값을 입력해주세요';
    }
    if(int.tryParse(val) == null){
      return '숫자를 입력해주세요';
    }

    final time = int.parse(val);

    if(time > 24 || time <0 ){
      return '0과 24 사이의 숫자를 입력해주세요';
    }
  }

  void onEndTimeSave(String? val) {
    if (val == null) {
      return;
    }
    endTime = int.parse(val);
  }

  String? onEndTimeValidate(String? val) {
    if(val == null){
      return '값을 입력해주세요';
    }
    if(int.tryParse(val) == null){
      return '숫자를 입력해주세요';
    }
    final time = int.parse(val);

    if(time > 24 || time <0 ){
      return '0과 24 사이의 숫자를 입력해주세요';
    }
  }

  void onContentSaved(String? val) {
    if (val == null) {
      return;
    }
    content = val;
  }

  String? onContentValidate(String? val) {
    if(val == null){
      return '내용을 입력해주세요';
    }
    if(val.length < 5){
      return '5자 이상을 입력해주세요';
    }

    return null;
  }

  void onSavePressed(){
    final isValid = formKey.currentState!.validate();

    if(isValid){
      formKey.currentState!.save();
      print('---------------');
      print(startTime);
      print(endTime);
      print(content);
      print(category);
    }


  }
}

class _Time extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey();
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final FormFieldValidator<String> onStartValidate;
  final FormFieldValidator<String> onEndValidate;

  _Time({
    required this.onStartSaved,
    required this.onEndSaved,
    required this.onStartValidate,
    required this.onEndValidate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: '시작 시간',
                onSaved: onStartSaved,
                validator: onStartValidate,
              ),
            ),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: CustomTextField(
                label: '마감 시간',
                onSaved: onEndSaved,
                validator: onEndValidate,
              ),
            ),
          ],
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     formKey.currentState!.save(); //Form이 감싸고 있는 모든 onSave()함수를 실행한다.
        //     // final validated = formKey.currentState!.validate(); //Form이 감싸고 있는 모든 validate()함수를 실행한다.
        //     // print('-----------');
        //     // print(validated);
        //   },
        //   child: Text('Save'),
        // )
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> onValidate;

  const _Content({required this.onSaved, required this.onValidate, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '내용',
        expand: true,
        onSaved: onSaved,
        validator: onValidate,
      ),
    );
  }
}

typedef OnColorSelected = void Function(String color);

class _Categories extends StatelessWidget {
  final String selectedColor;
  final OnColorSelected onTap;

  const _Categories({
    required this.onTap,
    required this.selectedColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        children: categoryColors
            .map((e) => Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      onTap(e);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(
                          int.parse(
                            'FF$e',
                            radix: 16,
                          ),
                        ),
                        border: e == selectedColor
                            ? Border.all(
                                color: Colors.black,
                                width: 4.0,
                              )
                            : null,
                        shape: BoxShape.circle,
                      ),
                      width: 32.0,
                      height: 32.0,
                    ),
                  ),
                ))
            .toList());
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('저장'),
          ),
        ),
      ],
    );
  }
}
