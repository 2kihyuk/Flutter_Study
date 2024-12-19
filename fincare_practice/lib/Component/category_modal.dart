import 'package:fincare_practice/Component/savebutton.dart';
import 'package:flutter/material.dart';

class CategoryModal extends StatefulWidget {
  const CategoryModal({super.key});

  @override
  State<CategoryModal> createState() => _CategoryModalState();
}

class _CategoryModalState extends State<CategoryModal> {
  @override
  Widget build(BuildContext context) {

    int selectedIndex = -1;
    final List<Map<String, String>> categories = [
      {'image': 'assets/images/food.png', 'label': '식비'},
      {'image': 'assets/images/coffee.png', 'label': '커피'},
      {'image': 'assets/images/traffic.png', 'label': '교통'},
      {'image': 'assets/images/hobby.png', 'label': '취미'},
      {'image': 'assets/images/shopping.png', 'label': '쇼핑'},
      {'image': 'assets/images/study.png', 'label': '교육'},
      {'image': 'assets/images/insurance.png', 'label': '보험'},
      {'image': 'assets/images/etc.png', 'label': '기타'},
    ];

    return Scaffold(
        body: GridView.builder(
          padding: EdgeInsets.all(30.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: categories.length,
      itemBuilder: (context , index){
            bool isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: (){
                setState(() {
                  selectedIndex = isSelected ? -1 : index;
                  print(selectedIndex);
                  if (!isSelected) {
                    Navigator.pop(context, categories[index]); // 모달 닫고 선택된 카테고리 정보 반환
                  }
                  // 선택/해제
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.blue : Colors.grey[200],
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(color: Colors.blue, blurRadius: 10.0)
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        categories[index]["image"]!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20.0,),
                      Text(
                        categories[index]['label']!,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                    ],
                  ),
                ),
              ),
              

            );
      },
    ),
    );
  }
}
