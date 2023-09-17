import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/loginPage.dart';
import 'package:flutter_firebase/pages/roleBasedAuth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'homepage.dart';

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

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String role = "user";
  bool isLoading = false;
  void navigateToLogin(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void signupwithGoogle() async {
    try {
      GoogleSignInAccount? account = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? authentication =
          await account?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authentication?.accessToken,
        idToken: authentication?.idToken,
      );
      UserCredential userCredential =
          await auth.signInWithCredential(credential).then((value) {
        firebaseFirestore.collection('users').add({
          "uid": value.user!.uid,
          "name": account!.displayName,
          "profile": account.photoUrl,
          "role": 'user'
        }).then((value) => debugPrint("User created"));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AdminPage()));
        return value;
      });
      debugPrint("UserCredential$userCredential");
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  void signUp() async {
    setState(() {
      isLoading = true;
    });
    await auth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      firebaseFirestore.collection('users').add({
        "uid": value.user!.uid,
        "name": nameController.text,
        "role": role
      }).then((value) {
        auth.currentUser!.sendEmailVerification();
        if (auth.currentUser!.emailVerified) {
          role == "user"
              ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UserPage()))
              : Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AdminPage()));
        }

        debugPrint("User created");
      });
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      namefocusNode.unfocus();
      passwordfocusNode.unfocus();
      emailfocusNode.unfocus();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            generatetextField(emailController, "Email", emailfocusNode),
            const SizedBox(
              height: 20,
            ),
            generatetextField(passwordController, "Password", passwordfocusNode,
                isObsecured: true),
            const SizedBox(
              height: 20,
            ),
            generatetextField(nameController, "Name", namefocusNode),
            Row(
              children: [
                Radio(
                  value: "user",
                  groupValue: role, // Use the role variable here
                  onChanged: (value) {
                    setState(() {
                      role = value.toString(); // Convert value to String
                    });
                  },
                ),
                const Text("user"),
                Radio(
                  value: "admin",
                  groupValue: role, // Use the role variable here
                  onChanged: (value) {
                    setState(() {
                      role = value.toString(); // Convert value to String
                    });
                    debugPrint(role);
                  },
                ),
                const Text("admin")
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                signUp();
              },
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Sign Up"),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Already have an account?",
              textAlign: TextAlign.center,
            ),
            TextButton(
                onPressed: () {
                  navigateToLogin(context);
                },
                child: const Text("Login")),
            TextButton(
                onPressed: () {
                  signupwithGoogle();
                },
                child: const Text("Sign up with Google"))
          ],
        ),
      ),
    ));
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
