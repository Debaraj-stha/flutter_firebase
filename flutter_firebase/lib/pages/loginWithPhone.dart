import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/verifyphone.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  TextEditingController _phoneController = TextEditingController();
  FocusNode focusNode = FocusNode();
  void login() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      auth.verifyPhoneNumber(
        phoneNumber: _phoneController.text,
          verificationCompleted: (_) {},
          verificationFailed: (e) {
            debugPrint(e.toString());
          },
          codeSent: (String id, int? code) {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyPhone(id:id,code:code!)));
          },
          codeAutoRetrievalTimeout: (e) {
            debugPrint("timeout");
          });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          generatetextField(_phoneController, "Phone", focusNode),
          TextButton(
              onPressed: () {
                login();
              },
              child: const Text("Login")),
        ],
      )),
    );
  }

  Widget generatetextField(
      TextEditingController controller, String label, FocusNode focusNode,
      {bool isObsecured = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(width: 1, color: Colors.blue)),
        child: TextFormField(
          obscureText: isObsecured,
          focusNode: focusNode,
          controller: controller,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: label,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 7)),
        ),
      ),
    );
  }
}
