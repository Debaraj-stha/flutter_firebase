import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/notifications/notification_helper.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
