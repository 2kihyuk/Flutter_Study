import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapsnsproject/user/view/login_screen.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MaterialApp(
        home: HomeScreen(),
      )
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}
