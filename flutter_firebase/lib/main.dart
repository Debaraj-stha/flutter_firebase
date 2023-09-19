import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/forgotPasswordPage.dart';
import 'package:flutter_firebase/pages/loginWithPhone.dart';
import 'package:flutter_firebase/pages/notifications/notificationMainPage.dart';

import 'package:flutter_firebase/pages/signinpage.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'pages/homepage.dart';
import 'pages/roleBasedAuth.dart';

void main() async {
//  FlutterDownloader.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseDatabase.instance.setLoggingEnabled(true);
  await FlutterDownloader.initialize();
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
//  ZegoUikitSignalingPlugin.init();
  runApp(const myApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isUserAlreadyLoggedIn() {
    User? user = auth.currentUser;
    return user != null;
  }

  Future<Widget> checkRole(BuildContext context) async {
    if (isUserAlreadyLoggedIn()) {
      final FirebaseAuth auth = FirebaseAuth.instance;
      String userId = auth.currentUser!.uid;
      final firestore = FirebaseFirestore.instance.collection('users');
      QuerySnapshot snapshots = await firestore
          .where(
            'uid',
            isEqualTo: userId,
          )
          .get();
      if (snapshots.docs.isNotEmpty) {
        DocumentSnapshot snapshot = snapshots.docs[0];
        String role = snapshot['role'];
        return role == 'user' ? const MyHomePage() : const AdminPage();
      }
    }
    return const SignInPage();
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<Widget>(
    //   future: checkRole(context),
    //   builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const CircularProgressIndicator(); // Loading indicator.
    //     } else if (snapshot.hasError) {
    //       return Text('Error: ${snapshot.error}'); // Handle errors.
    //     } else {
    //       return MaterialApp(
    //         title: 'Flutter Demo',
    //         debugShowCheckedModeBanner: false,
    //         theme: ThemeData(brightness: Brightness.dark),
    //         themeMode: ThemeMode.dark,
    //         darkTheme: ThemeData.dark(),
    //         home:ForgotPasswordPage() //snapshot.data, // Display the widget.
    //       );
    //     }
    //   },
    // );
    return const MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: NotificationMainPage(//snapshot.data, // Display the widget.

            ));
  }
}

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Background message$message");
}

class myApp extends StatefulWidget {
  const myApp({super.key});

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: NotificationMainPage(//snapshot.data, // Display the widget.

            ));
  }
}
