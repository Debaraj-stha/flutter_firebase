import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/signinpage.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
      ),
      body: SignInPage(),
    );
  }
}
