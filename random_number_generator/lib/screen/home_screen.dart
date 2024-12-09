import 'package:flutter/material.dart';
import 'package:random_number_generator/component/number_to_image.dart';
import 'package:random_number_generator/constant/color.dart';
import 'dart:math';

import 'package:random_number_generator/screen/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> numbers = [123, 456, 789];
  int maxNumber = 1000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ///제목과 아이콘 버튼이 있는곳
              _Header(
                onPressed: onSettingIconPressed,
              ),

              ///숫자가 있는 곳
              _Body(
                numbers: numbers,
              ),

              ///버튼이 있는 곳
              _Footer(onPressed: generateRandomNumber),
            ],
          ),
        ),
      ),
    );
  }

  onSettingIconPressed() async {
//push()한곳에서 pop()매개변수안에 들려서 오는 result 값을 받을수 있다.

      final result = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context){
            return SettingScreen(
              maxNumber: maxNumber,
            );
          },
      ),
    );
      maxNumber = result;
  }


  generateRandomNumber() {
    final rand = Random();

    final Set<int> newNumbers = {};

    while (newNumbers.length < 3) {
      final randomNumber = rand.nextInt(maxNumber);
      newNumbers.add(randomNumber);
    }
    // final randomNumber1 = rand.nextInt(1000); //0~999
    // final randomNumber2 = rand.nextInt(1000); //0~999
    // final randomNumber3 = rand.nextInt(1000); //0~999

    setState(() {
      numbers = newNumbers.toList();
    });
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onPressed;

  const _Header({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '랜덤 숫자 생성기',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        IconButton(
            color: redColor,
            onPressed: onPressed,
            icon: Icon(
              Icons.settings,
            )),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final List<int> numbers;

  const _Body({required this.numbers, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: numbers
            .map((e) =>NumberToImage(number: e))
            .toList(),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onPressed;

  const _Footer({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: redColor,
        foregroundColor: Colors.white,
      ),
      child: Text('생성하기!'),
    );
  }
}

// Row(
// children: ['1', '2', '3']
//     .map(
// (e)=>Text(
// e,
// style: TextStyle(
// color: Colors.white,
// ),
// ),
//
// ).toList(),
// ),
