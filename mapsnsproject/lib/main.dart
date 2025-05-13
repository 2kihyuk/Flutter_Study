import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapsnsproject/common/view/splash_screen.dart';
import 'package:mapsnsproject/user/view/login_screen.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'amplifyconfiguration.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Amplify.addPlugins([
    AmplifyAuthCognito(),    // ← 이거 꼭 먼저
    AmplifyStorageS3(),
  ]);
  await Amplify.configure(amplifyconfig);
  runApp(
      ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      )
  );
}

Future<void> _configureAmplify() async {
  // 1) Auth 먼저
  // Amplify.addPlugins([AmplifyAuthCognito(), AmplifyStorageS3()]);

  // 2) 그리고 설정 문자열로 configure
  await Amplify.configure(amplifyconfig);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
