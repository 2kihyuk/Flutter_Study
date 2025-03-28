import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NestedScreen extends StatelessWidget {
  final Widget child;

  const NestedScreen({required this.child, super.key});

  int getIndex(BuildContext context){
    if(GoRouterState.of(context).matchedLocation == 'nested/a'){
      return 0;
    }else  if(GoRouterState.of(context).matchedLocation == '  nested/b'){
      return 1;
    }else{
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${GoRouterState.of(context).matchedLocation}'),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: getIndex(context),
        onTap: (index){
          if(index ==0){
            context.go('/nested/a');
          }else if(index == 1){
            context.go('/nested/b');
          }else{
            context.go('/nested/c');
          }
        },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home,),label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.person,),label: 'person'),
            BottomNavigationBarItem(icon: Icon(Icons.notification_add,),label: 'notifications'),
          ]
      ),
    );
  }
}
