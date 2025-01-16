import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ready_project/riverpod/budget_notifier.dart';
import 'package:ready_project/start_budget_management/component/close_budget.dart';
import 'package:ready_project/start_budget_management/component/incomeorexpense.dart';

class StartBudgetManagementMiddle extends ConsumerWidget {
  const StartBudgetManagementMiddle({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    return Column(
      children: [
        // Slider(),
        Incomeorexpense(),
        CloseBudget(),
      ],
    );
  }
}


///Slider. 한달 사용금액 슬라이더

// Slider(
//   value: value,
//   max: ,
//   onChanged: onChanged,
// ),

/// MonthExpanseCheck. 하루 지출 및 수입 입력후 저장(백엔드 전송-post)
///
///  /// EndSpend.하루 지출 마감 (백엔드에서 오늘날짜 지출 및 수입 데이터받아와서 카드 형태로 렌더링 - get) 보여주고 이후 마감or 세이프박스 버튼 클릭시 저장후 변수값 초기화 하는 로직.
//           /// 변수 값 초기화란, 오늘 사용 할 수 있는 Daily_budget값의 금액보다 오늘 지출 금액이 적다면 남은 금액은 safeBox값에 누적으로 + 시키고 저장.
//           /// 오늘 사용할 수 있는 Daily_Budget값의 금액보다 오늘 지출 금액이 많다면 , 예산 초과 , 즉 -값이기 때문에 다른 날의 daily_budget값에서 값을 빼오게 선택할 수 있어야함.