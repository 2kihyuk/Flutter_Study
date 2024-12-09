import 'package:flutter/material.dart';
import 'package:row_and_column/screen/home_screen.dart';
// import 'package:row_and_column/screen/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomeScreen(),
    )
  );
}

//지금 이상태가 가장 기본 초기화한 상태. 이렇게 만드는게 초기화 작업이다.

//code를 이쁘게 작성하기 위해서 정리 하면서 코드 작성할건데
//어떻게 정리할거냐?

// 폴더를 만들어서 관리..
//1번째 방법. lib/screen/home_screen.dart 파일을 만들고.
//그 안에서 stless 로 HomeScreen 클래스를 작성해주면 된다.
//그리고 main.dart에서 import해서 클래스명만 가져다 쓰면 완료.


//2번째 방법. import문 없이.
//

