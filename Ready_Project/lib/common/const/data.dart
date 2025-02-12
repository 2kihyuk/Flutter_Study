import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

 const JWT_TOKEN = 'JWT_TOKEN';
 const daily_remain_budget = 0;
//
// const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

final storage = FlutterSecureStorage();

final emulatorIp = '52.79.158.63:8080';
final simulatorIp = '52.79.158.63:8080';

final ip = Platform.isIOS ? simulatorIp : emulatorIp;