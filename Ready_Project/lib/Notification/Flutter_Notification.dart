import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:timezone/data/latest.dart' as tz_data;

class FlutterLocalNotification {
  FlutterLocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static init() async {
    tz_data.initializeTimeZones();

    // 'Asia/Seoul' 타임존을 로컬 타임존으로 설정
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    AndroidInitializationSettings androidInitializationSettings =
    const AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
    const DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false);

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static requestNotificationPermission() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    if (Platform.isAndroid) {
      final storage = FlutterSecureStorage();
      storage.write(key: 'notificationsEnabled', value: 'true');
    }
  }

  static Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'channeld Id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: false,
      icon: 'drawable/ic_launcher',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: DarwinNotificationDetails(badgeNumber: 1));

    await flutterLocalNotificationsPlugin.show(
        0, 'FinCare', '오늘 사용내역을 입력하셨나요?', notificationDetails);
  }

  static Future<void> scheduleDailyNotification() async {
    final storage = FlutterSecureStorage();
    String? isNotificationEnabled = await storage.read(key: 'notificationsEnabled');

    if (isNotificationEnabled == 'true') {
      const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        'channeld Id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        priority: Priority.max,
        showWhen: false,
        icon: 'drawable/ic_launcher',
      );

      const NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails, iOS: DarwinNotificationDetails(badgeNumber: 1));
      // var scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(seconds: 10));
      var scheduledTime = _makeTime(21, 00, 00);
      // tz.initializeTimeZones();
      print("Local Time Zone: ${tz.local}");
      print("Scheduled time: ${scheduledTime}");
      print("Current time: ${tz.TZDateTime.now(tz.local)}");  // 'Asia/Seoul' 타임존에 맞게 출력됩니다.

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'FinCare',
        '오늘 사용내역을 입력하셨나요?',
        scheduledTime,
        notificationDetails,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exact,
      );
    }
  }

  static tz.TZDateTime _makeTime(int hour, int min, int sec) {
    var now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, sec);

    if (when.isBefore(now)) {
      when = when.add(Duration());
    }

    return when;
  }
}




