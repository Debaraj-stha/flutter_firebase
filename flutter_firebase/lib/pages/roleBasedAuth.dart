import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/verifymessagepage.dart';

import 'loginPage.dart';

FirebaseAuth auth = FirebaseAuth.instance;
bool isLogined() {
  return auth.currentUser != null;
}

bool isVerified() {
  return auth.currentUser!.emailVerified;
}

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Widget buildContent() {
    if (isLogined()) {
      if (isVerified()) {
        return Scaffold(
            appBar: AppBar(
          title: const Text("Admin"),
          actions: [
            TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
                child: const Text("Logout"))
          ],
        ));
      } else {
        return VerifyMessage();
      }
    } else {
      return const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }
}

class UserPage extends StatelessWidget {
  const UserPage({super.key});
Widget buildContent(BuildContext context) {
  if(isLogined()){
    if(isVerified()){
      return Scaffold(
        appBar: AppBar(
          title: const Text("User"),
          actions: [
            TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
                child: const Text("Logout")
            )
          ]
        )
      );
      
  }
  return VerifyMessage();
}
return LoginPage();
}

  @override
  Widget build(BuildContext context) {
    return buildContent(context);
  }
}
