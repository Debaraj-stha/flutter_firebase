import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  void getResetLink() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.sendPasswordResetEmail(email: controller.text).then((value) {
      focusNode.unfocus();
      controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "We have send a password  reset link to your email address.Check your email address and  reset the password"),
          showCloseIcon: true,
          closeIconColor: Colors.red,
        ),
      );
    }).onError((error, stackTrace){
      debugPrint("error: " + error.toString());
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Forgot Password"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const Text(
            "Have you forgot your password,no worry,you can reset your password by entering yout email address",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                focusNode: focusNode,
                controller: controller,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Email address",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 7)),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              getResetLink();
            },
            child: const Text("Get Link"),
          ),
        ],
      ),
    );
  }
}
