import 'package:fincare_practice/Component/savebutton.dart';
import 'package:fincare_practice/Component/toggle_button.dart';
import 'package:flutter/material.dart';

class DecisionExpanse extends StatelessWidget {
  const DecisionExpanse({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    int selectedIndex = 0;

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
              SizedBox(height: 20.0,),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: '금액을 입력하세용',
                          labelStyle: TextStyle(
                            fontSize: 20,
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50.0,),
              Row(
                children: [
                  Expanded(
                    child: Text('분류'),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  ToggleButton()
                ],
              ),
              SizedBox(height: 20.0,),
              Row(
                children: [
                  Expanded(
                    child: Text('카테고리'),
                  ),
                  Text('미분류'),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_){
                          return Container(

                          );
                        },
                      );
                    },
                    icon: Icon(Icons.u_turn_right_outlined),
                  )
                ],
              ),
              Spacer(),
              Savebutton(content: '저장'),
            ],
          ),
        ),
      ),
    );
  }
}

///화면 최상단 왼쪽에는 뒤로가기 버튼 - navigator.of(context).pop();
///밑에는 Text('남은 일정과 금액') 크게
///바로 밑에 Text('D-한달중 남은일수 / ${총액 중 남아있는 금액}')
///
/// 밑에 회색글씨로 크게 TextField이고 placeholder로는 -> ('하루 예산 ${총액/한달일수}원');
///
/// 화면 중간 왼쪽에 Row( Text(분류)  , TextButton? 수입 과 지출 선택할 수 있는 버튼)
/// 밑에 Row( Text(카테고리) , >아이콘 버튼 )
///     >아이콘 버튼 클릭시 그리드 형태로 모달올라오면서 카테고리 선택가능
///
/// 화면 최하단에 SaveButton()
///
///
/// Logic => TextField에 금액 입력후  수입 및 지출 중 하나를 택. 수입을 택할시 +금액 / 지출을 택할시 -금액
/// 카테고리를 선택.
/// 금액 선택과 가격에 따라서 하루 예산변수에다가 +/- 를 해줘야하며 , 총액에도 반영을 해줘야하며, 달력에도 반영을 해줘여함. 이 내용들은 stateful이니 변수를 외부에서 받아놓고 반영할수 있어야함.


///아이콘 어디서 폰트어디서