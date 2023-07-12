import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSetting =
      AndroidInitializationSettings('logo');

  void initialiseNotifications() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: _androidInitializationSetting,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNoti(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }
}




class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {
    try {
      print("In Notification method");
      // int id = DateTime.now().microsecondsSinceEpoch ~/1000000;
      // Random random = new Random();
      // int id = random.nextInt(1000);
      int id = 1;
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "channelId",
        "my chanel",
        importance: Importance.max,
        priority: Priority.high,
      ));
      print("my id is ${id.toString()}");
      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.title,
        notificationDetails,
      );
    } on Exception catch (e) {
      print('Error>>>$e');
    }
  }
}
