import 'package:flutter_riverpod/flutter_riverpod.dart';


//FamilyModifier는 언제쓰냐?
/// Provider를 생성할때 생성하는 순간에 어떤 변수를 입력해줘서 이 변수로 Provider 안의 로직을 변경을 해야한다면 Family Modifier를 쓴다.
final familyModifierProvider = FutureProvider.family<List<int>,int>((ref,data) async {
  await Future.delayed(Duration(seconds: 3));

  return List.generate(5, (index) => index *data);

  return [1,2,3,4,5,6,7,8,9,10];
});