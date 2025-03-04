import 'package:ready_project/AIServiceScreen/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ready_project/common/const/category.dart';

class PieChartSample3 extends StatefulWidget {
  final double monthly_expense_total;
  final Map<String, double> categoryExpenses;

  const PieChartSample3({required this.monthly_expense_total, required this.categoryExpenses, super.key});

  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State<PieChartSample3> {
  int touchedIndex = -1;

  final Map<String, Color> categoryColors = {
    '커피': AppColors.contentColorBlue,
    '보험': AppColors.contentColorYellow,
    '교육': AppColors.contentColorPurple,
    '취미': AppColors.contentColorGreen,
    '식비': AppColors.contentColorRed,
    '교통': AppColors.contentColorCyan,
    '쇼핑': AppColors.contentColorPink,
    '기타': AppColors.contentColorOrange,
    // 추가 카테고리가 있으면 여기에 더 추가
  };

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: showingSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    double totalSum = widget.categoryExpenses.values.fold(0.0, (sum, value) => sum + value);  // 전체 금액 합계

    return List.generate(widget.categoryExpenses.length, (i) {
      final category = widget.categoryExpenses.keys.elementAt(i);
      final expense = widget.categoryExpenses[category]!;
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      // 각 카테고리의 비율 계산
      double percentage = (expense / totalSum) * 100;

      // 색상은 카테고리별로 다르게 설정하거나 고정할 수 있음
      // Color sectionColor = AppColors.contentColorBlue;  // 여기에 카테고리별 색상 로직 추가 가능
      Color sectionColor = categoryColors[category] ?? AppColors.contentColorBlue;

      String imagePath = categories.firstWhere(
            (cat) => cat['label'] == category, // category의 이름과 일치하는 'label'을 찾기
        orElse: () => {'image': 'assets/images/etc.png'},  // 일치하는 항목이 없으면 기본 '기타' 이미지
      )['image']!;

      // 섹션을 생성하고 반환
      return PieChartSectionData(
        color: sectionColor,
        value: expense,
        title: '${percentage.toStringAsFixed(1)}%',  // 비율 계산된 값
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
        badgeWidget: _Badge(
          imagePath,  // 여기에 아이콘을 동적으로 설정할 수도 있음
          size: widgetSize,
          borderColor: AppColors.contentColorBlack,
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.svgAsset, {
    required this.size,
    required this.borderColor,
  });

  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black,
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Image.asset(
          svgAsset,
        ),
      ),
    );
  }
}




// class PieChartSample3 extends StatefulWidget {
//   final double monthly_expense_total;
//   final Map<String,double> categoryExpenses;
//
//   const PieChartSample3({required this.monthly_expense_total,required this.categoryExpenses, super.key});
//
//   @override
//   State<StatefulWidget> createState() => PieChartSample3State();
// }
//
// class PieChartSample3State extends State<PieChartSample3> {
//   int touchedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.3,
//       child: AspectRatio(
//         aspectRatio: 1,
//         child: PieChart(
//           PieChartData(
//             pieTouchData: PieTouchData(
//               touchCallback: (FlTouchEvent event, pieTouchResponse) {
//                 setState(() {
//                   if (!event.isInterestedForInteractions ||
//                       pieTouchResponse == null ||
//                       pieTouchResponse.touchedSection == null) {
//                     touchedIndex = -1;
//                     return;
//                   }
//                   touchedIndex =
//                       pieTouchResponse.touchedSection!.touchedSectionIndex;
//                 });
//               },
//             ),
//             borderData: FlBorderData(
//               show: false,
//             ),
//             sectionsSpace: 0,
//             centerSpaceRadius: 0,
//             sections: showingSections(widget.monthly_expense_total),
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<PieChartSectionData> showingSections(double total) {
//
//     //여기에 totalSum을 확실히 지정해준 후에 value에다가 totalSum에 대한 각 카테고리의 값을 정확히 비율대로 지정해주어야 함.
//     return List.generate(widget.categoryExpenses.length, (i) {
//       final isTouched = i == touchedIndex;
//       final fontSize = isTouched ? 20.0 : 16.0;
//       final radius = isTouched ? 110.0 : 100.0;
//       final widgetSize = isTouched ? 55.0 : 40.0;
//       const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
//
//       switch (i) {
//         case 0:
//           return PieChartSectionData(
//             color: AppColors.contentColorBlue,
//             value: 2000000,
//             title: '${((200000/total)*100).toStringAsFixed(1)}%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: shadows,
//             ),
//             badgeWidget: _Badge(
//               'assets/icons/ophthalmology-svgrepo-com.svg',
//               size: widgetSize,
//               borderColor: AppColors.contentColorBlack,
//             ),
//             badgePositionPercentageOffset: .98,
//           );
//         case 1:
//           return PieChartSectionData(
//             color: AppColors.contentColorYellow,
//             value: 10000,
//             title: '${((10000/total)*100).toStringAsFixed(1)}%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: shadows,
//             ),
//             badgeWidget: _Badge(
//               'assets/icons/librarian-svgrepo-com.svg',
//               size: widgetSize,
//               borderColor: AppColors.contentColorBlack,
//             ),
//             badgePositionPercentageOffset: .98,
//           );
//         case 2:
//           return PieChartSectionData(
//             color: AppColors.contentColorPurple,
//             value: 2000000,
//             title: '${((200000/total)*100).toStringAsFixed(1)}%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: shadows,
//             ),
//             badgeWidget: _Badge(
//               'assets/icons/fitness-svgrepo-com.svg',
//               size: widgetSize,
//               borderColor: AppColors.contentColorBlack,
//             ),
//             badgePositionPercentageOffset: .98,
//           );
//         case 3:
//           return PieChartSectionData(
//             color: AppColors.contentColorGreen,
//             value: 600000,
//             title: '${((600000/total)*100).toStringAsFixed(1)}%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: shadows,
//             ),
//             badgeWidget: _Badge(
//               'assets/icons/worker-svgrepo-com.svg',
//               size: widgetSize,
//               borderColor: AppColors.contentColorBlack,
//             ),
//             badgePositionPercentageOffset: .98,
//           );
//         default:
//           throw Exception('Oh no');
//       }
//     });
//   }
// }
//
// class _Badge extends StatelessWidget {
//   const _Badge(this.svgAsset, {
//     required this.size,
//     required this.borderColor,
//   });
//
//   final String svgAsset;
//   final double size;
//   final Color borderColor;
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: PieChart.defaultDuration,
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: borderColor,
//           width: 2,
//         ),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//             color: Colors.black,
//             offset: const Offset(3, 3),
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       padding: EdgeInsets.all(size * .15),
//       child: Center(
//         child: SvgPicture.asset(
//           svgAsset,
//         ),
//       ),
//     );
//   }
// }

