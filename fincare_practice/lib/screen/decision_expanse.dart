// import 'package:fincare_practice/Component/category_modal.dart';
// import 'package:fincare_practice/Component/savebutton.dart';
// import 'package:fincare_practice/Component/toggle_button.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class DecisionExpanse extends StatefulWidget {
//   const DecisionExpanse({super.key});
//
//   @override
//   State<DecisionExpanse> createState() => _DecisionExpanseState();
// }
//
// class _DecisionExpanseState extends State<DecisionExpanse> {
//   String categoryItemString = "선택된 카테고리 없음";
//   TextEditingController _controller = TextEditingController();
//   int selectedExpanseIndex = 0;
//
//   TextInputFormatter _currencyFormatter = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Scaffold(
//       appBar: AppBar(),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 20.0, left: 24.0, right: 24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '남은 일정과 금액',
//                 style: TextStyle(
//                   fontFamily: 'Pretendard',
//                   fontWeight: FontWeight.w700,
//                   fontSize: 20,
//                 ),
//               ),
//               Text(
//                 'D-15 / 300000원',
//                 style: TextStyle(
//                   fontFamily: 'Pretendard',
//                   fontWeight: FontWeight.w500,
//                   fontSize: 12.0,
//                 ),
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       inputFormatters: [_currencyFormatter],
//                       decoration: InputDecoration(
//                           border: UnderlineInputBorder(),
//                           floatingLabelBehavior: FloatingLabelBehavior.never,
//                           labelText: '금액을 입력하세용',
//                           labelStyle: TextStyle(
//                             fontSize: 30,
//                           )),
//                       onChanged: (value){
//                         setState(() {
//                           String amount = value.replaceAll(RegExp(r'[^0-9]'), '');
//                           if (amount.isNotEmpty) {
//                             String formattedValue = "$amount 원";
//                             if (selectedExpanseIndex == 0) {
//                               _controller.text = "+$formattedValue";
//                             } else {
//                               _controller.text = "-$formattedValue";
//                             }
//                           }
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 50.0,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text('분류'),
//                   ),
//                   SizedBox(
//                     width: 16.0,
//                   ),
//                   ToggleButton(
//                     selectedIndex: selectedExpanseIndex,
//                     onSelectionChanged: (index){
//                       setState(() {
//                         selectedExpanseIndex = index;
//                         String amount = _controller.text.replaceAll(RegExp(r'[^0-9]'), ''); // 숫자만 가져오기
//                         if (amount.isNotEmpty) {
//                           // 선택 상태에 따라 텍스트 필드에 부호 추가
//                           String formattedValue = "$amount 원";
//                           if (selectedExpanseIndex == 0) {
//                             _controller.text = "+$formattedValue";
//                           } else {
//                             _controller.text = "-$formattedValue";
//                           }
//                         }
//                       });
//                     },
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text('카테고리'),
//                   ),
//                   Text('${categoryItemString}'),
//                   IconButton(
//                     ///클릭시 카테고리 선택하는 모달화면 올라옴.
//                     onPressed: () async {
//                       final selectedCategoryItem =
//                           await showModalBottomSheet<Map<String, String>>(
//                         context: context,
//                         builder: (context) => CategoryModal(),
//                       );
//                       if (selectedCategoryItem != null) {
//                         setState(() {
//                           categoryItemString = selectedCategoryItem[
//                               'label']!; // 선택된 카테고리 이름 업데이트
//                         });
//                       }
//                     },
//                     icon: Icon(Icons.u_turn_right_outlined),
//
//                     ///아이콘 바꿔야함.
//                   )
//                 ],
//               ),
//               Spacer(),
//               Savebutton(content: '저장'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// ///화면 최상단 왼쪽에는 뒤로가기 버튼 - navigator.of(context).pop();
// ///밑에는 Text('남은 일정과 금액') 크게
// ///바로 밑에 Text('D-한달중 남은일수 / ${총액 중 남아있는 금액}')
// ///
// /// 밑에 회색글씨로 크게 TextField이고 placeholder로는 -> ('하루 예산 ${총액/한달일수}원');
// ///
// /// 화면 중간 왼쪽에 Row( Text(분류)  , TextButton? 수입 과 지출 선택할 수 있는 버튼)
// /// 밑에 Row( Text(카테고리) , >아이콘 버튼 )
// ///     >아이콘 버튼 클릭시 그리드 형태로 모달올라오면서 카테고리 선택가능
// ///
// /// 화면 최하단에 SaveButton()
// ///
// ///
// /// Logic => TextField에 금액 입력후  수입 및 지출 중 하나를 택. 수입을 택할시 +금액 / 지출을 택할시 -금액
// /// 카테고리를 선택.
// /// 금액 선택과 가격에 따라서 하루 예산변수에다가 +/- 를 해줘야하며 , 총액에도 반영을 해줘야하며, 달력에도 반영을 해줘여함. 이 내용들은 stateful이니 변수를 외부에서 받아놓고 반영할수 있어야함.
//
// ///아이콘 어디서 폰트어디서


/// ------------------------------------------------------------------------------------------------------------------------------------------------------
import 'package:fincare_practice/Component/category_modal.dart';
import 'package:fincare_practice/Component/savebutton.dart';
import 'package:fincare_practice/Component/toggle_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecisionExpanse extends StatefulWidget {

  final String initialAmount;

  const DecisionExpanse({
    required this.initialAmount,
    super.key});

  @override
  State<DecisionExpanse> createState() => _DecisionExpanseState();
}

class _DecisionExpanseState extends State<DecisionExpanse> {
  String categoryItemString = "선택된 카테고리 없음";
  TextEditingController _controller = TextEditingController();
  int selectedExpanseIndex = 0; // 0: 수입, 1: 지출

  @override
  void initState() {
    super.initState();
    // 텍스트 필드 초기 값 설정
    _controller.text = widget.initialAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
            '남은 일정과 금액',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          Text(
            'D-15 / 300000원',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 12.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: '금액을 입력하세용',
                    labelStyle: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onChanged: (value) {
                    _updateAmountWithSign(value);
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50.0,
          ),
          Row(
            children: [
              Expanded(
                child: Text('분류'),
              ),
              SizedBox(
                width: 16.0,
              ),
              ToggleButton(
                selectedIndex: selectedExpanseIndex,
                onSelectionChanged: (index) {
                  setState(() {
                    selectedExpanseIndex = index;
                    _updateAmountWithSign(_controller.text);
                  });
                },
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Expanded(
                child: Text('카테고리'),
              ),
              Text('${categoryItemString}'),
              IconButton(
                onPressed: () async {
                  final selectedCategoryItem =
                  await showModalBottomSheet<Map<String, String>>(
                    context: context,
                    builder: (context) => CategoryModal(),
                  );
                  if (selectedCategoryItem != null) {
                    setState(() {
                      categoryItemString = selectedCategoryItem['label']!;
                    });
                  }
                },
                icon: Icon(Icons.u_turn_right_outlined),

                ///여기 아이콘 바꿔야함.
              ),
            ],
          ),
          Spacer(),
          ElevatedButton(
            onPressed: (){
              String updatedAmount = _controller.text.replaceAll(RegExp(r'[^0-9]'), '');
              if (selectedExpanseIndex == 0) {
                updatedAmount = "+$updatedAmount";
              } else {
                updatedAmount = "-$updatedAmount";
              }

              // 데이터를 보내기
              Navigator.pop(context, updatedAmount);
            },
            child: Text(
              '저장',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(400, 50),
              backgroundColor: Colors.blue,
            ),
          ),
          ],
        ),
      ),
    ),);
  }

  void _updateAmountWithSign(String value) {
    // 숫자만 추출하여 '원' 붙이기
    String amount = value.replaceAll(RegExp(r'[^0-9]'), ''); // 숫자만 추출
    if (amount.isNotEmpty) {
      String formattedValue = "$amount 원";
      if (selectedExpanseIndex == 0) {
        // 수입 선택 시 '+' 부호
        _controller.text = "+$formattedValue";
      } else {
        // 지출 선택 시 '-' 부호
        _controller.text = "-$formattedValue";
      }

      // 커서 위치 유지
      _controller.selection =
          TextSelection.collapsed(offset: _controller.text.length);
    } else {
      _controller.text = "원";
    }
  }
}


