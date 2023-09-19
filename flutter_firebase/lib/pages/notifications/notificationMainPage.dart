import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/notifications/key.dart';
import 'package:flutter_firebase/pages/notifications/notification_helper.dart';
import 'package:http/http.dart' as http;

class NotificationMainPage extends StatefulWidget {
  const NotificationMainPage({super.key});

  @override
  State<NotificationMainPage> createState() => _NotificationMainPageState();
}

class _NotificationMainPageState extends State<NotificationMainPage> {
  NotificationHelper helper = NotificationHelper();
  @override
  void initState() {
    // TODO: implement initState
    helper.RequestNotificationPermission();
    helper.firebaseInit(context);
    helper.interactMessage(context);
    helper.getDeviceToken().then((value) {
      debugPrint("device token: $value");
    });
    super.initState();
  }

  void sendNotification() async {
    await helper.getDeviceToken().then((value) async {
      var data = {
        "to": value
            .toString(), //to send to another device,replace with device token
        "priority": "high",
        "notification": {
          "title": "Notification Message",
          "body": "Notification Message from one device to another device",
          "image":
              "https://www.pexels.com/photo/woman-posing-for-photo-shoot-1391498/"
        },
        "data": {"type": "msg", "id": "testid"}
      };
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json;charset=utf-8',
            'Authorization': 'key=$key'
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification page"),
      ),
      body: Center(
        child: TextButton(
            onPressed: () {
              sendNotification();
            },
            child: const Text("Send notification")),
      ),
    );
  }
}
