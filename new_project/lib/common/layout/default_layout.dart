import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final String? titleText;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final bool IsaddButton;
  final VoidCallback? onAddButtonPressed;

  const DefaultLayout({
    required this.child,
    this.titleText,
    this.backgroundColor,
    this.bottomNavigationBar,
    required this.IsaddButton,
    this.onAddButtonPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    if (titleText == null) {
      return null;
    } else if (IsaddButton == true) {
      return AppBar(
        actions: [IconButton(onPressed: onAddButtonPressed, icon: Icon(Icons.add))],
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          titleText!,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        foregroundColor: Colors.black,
      );
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          titleText!,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}
