import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase/pages/notifications/messageScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void RequestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        announcement: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("user granted permission");
    } else {
      debugPrint("user denied permission");
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      debugPrint("token refresh");
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        debugPrint(message.notification!.title.toString());
        debugPrint(message.notification!.body.toString());
      }
      if (Platform.isAndroid) {
        initNotification(context, message);
        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }

  void initNotification(BuildContext context, RemoteMessage message) async {
    var androidInitializationSetting =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iocinitialization = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
        android: androidInitializationSetting, iOS: iocinitialization);
    await _notificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
          handleMessage(context, message);
        });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        "high importance notification",
        importance: Importance.max);
    AndroidNotificationDetails details = AndroidNotificationDetails(
        channel.id, channel.name,
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        channelDescription: "channel description");
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    NotificationDetails notificationDetails =
        NotificationDetails(android: details, iOS: darwinNotificationDetails);
    Future.delayed(Duration.zero, () {
      _notificationsPlugin.show(1, message.notification!.title.toString(),
          message.notification!.body.toString(), notificationDetails);
    });
  }
Future<void> interactMessage(BuildContext context)async{
  RemoteMessage?message =await FirebaseMessaging.instance.getInitialMessage();
  if(message!=null){
    handleMessage(context, message);
  }
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    handleMessage(context, event);
  });
}
  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msg') {
      final data = message.data;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MessageScreen(message: data['message'], id: data['id'])));
    }
  }
}
