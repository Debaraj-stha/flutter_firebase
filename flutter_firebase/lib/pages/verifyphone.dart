import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class VerifyPhone extends StatefulWidget {
  const VerifyPhone({super.key, required this.id, required this.code});
  final String id;
  final int code;
  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final TextEditingController _phoneController = TextEditingController();
  FocusNode focusNode = FocusNode();
  verify() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signInWithCredential(PhoneAuthProvider.credential(
        verificationId: widget.id, smsCode: _phoneController.text));
    debugPrint("verified");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Verifying...',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(width: 1, color: Colors.blue)),
                child: TextFormField(
                  focusNode: focusNode,
                  controller: _phoneController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Verification code",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 7)),
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  verify();
                },
                child: const Text("Verify")),
          ],
        ),
      ),
    );
  }
}
