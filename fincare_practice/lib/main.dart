// import 'package:fincare_practice/budgetmodel.dart';
// import 'package:fincare_practice/screen/authentication_start.dart';
// import 'package:fincare_practice/screen/home_screen.dart';
// import 'package:fincare_practice/screen/login_page.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';  // intl 패키지
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:provider/provider.dart';
//
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized(); // 위젯 트리 초기화
//
//   // 로케일 데이터 초기화
//   await initializeDateFormatting('ko_KR', null); // 'ko_KR'을 사용하여 한국어 로케일 초기화
//
//   runApp(
//     MaterialApp(
//       home:AuthenticationStart(),
//     )
//   );
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => BudgetModel(), // BudgetModel을 Provider로 감쌈
//       child: MaterialApp(
//         home: AuthenticationStart(),
//       ),
//     );
//   }
// }
import 'package:fincare_practice/screen/authentication_start.dart';
import 'package:fincare_practice/screen/home_screen.dart';
import 'package:fincare_practice/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';  // intl 패키지
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart'; // provider 패키지

import 'package:fincare_practice/model/budgetmodel.dart'; // BudgetModel을 가져옵니다.

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 위젯 트리 초기화

  // 로케일 데이터 초기화
  await initializeDateFormatting('ko_KR', null); // 'ko_KR'을 사용하여 한국어 로케일 초기화
  final appDocumentDir = await getApplicationDocumentsDirectory();

  // Hive 초기화
  await Hive.initFlutter(appDocumentDir.path);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BudgetModel(),  // BudgetModel을 ChangeNotifierProvider로 감쌈
      child: MaterialApp(
        home: AuthenticationStart(),
      ),
    );
  }
}
