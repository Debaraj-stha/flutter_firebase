import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  FocusNode namefocusNode = FocusNode();
  FocusNode passwordfocusNode = FocusNode();
  FocusNode emailfocusNode = FocusNode();
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    emailfocusNode.dispose();
    passwordfocusNode.dispose();
    namefocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
        ),
        body: ListView(
          children: [
            generatetextField(emailController, "Email", emailfocusNode),
            SizedBox(
              height: 20,
            ),
            generatetextField(passwordController, "Password", passwordfocusNode,
                isObsecured: true),
            SizedBox(
              height: 20,
            ),
            generatetextField(nameController, "Name", namefocusNode),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Sign Up"),
              ),
            )
          ],
        ));
  }

  Widget generatetextField(
      TextEditingController controller, String label, FocusNode focusNode,
      {bool isObsecured = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(width: 1, color: Colors.blue)),
        child: TextFormField(
          obscureText: isObsecured,
          focusNode: focusNode,
          controller: controller,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: label,
              contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 7)),
        ),
      ),
    );
  }
}
