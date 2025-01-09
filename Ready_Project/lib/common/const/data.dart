import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

 const JWT_TOKEN = 'JWT_TOKEN';
//
// const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

final storage = FlutterSecureStorage();

final emulatorIp = '10.0.0.2:3000';
final simulatorIp = '52.79.158.63:8080';

final ip = Platform.isIOS ? simulatorIp : emulatorIp;