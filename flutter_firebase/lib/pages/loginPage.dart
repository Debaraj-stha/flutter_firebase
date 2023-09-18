import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/forgotPasswordPage.dart';
import 'package:flutter_firebase/pages/homepage.dart';
import 'package:flutter_firebase/pages/roleBasedAuth.dart';
import 'package:flutter_firebase/pages/signinpage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode passwordfocusNode = FocusNode();
  FocusNode emailfocusNode = FocusNode();
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();

    emailfocusNode.dispose();
    passwordfocusNode.dispose();

    super.dispose();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool isLoading = false;
  void navigateToSignUp(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignInPage()));
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
          await auth.signInWithCredential(credential);
      debugPrint("UserCredential$userCredential");
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  void login() async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await auth
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) {
        return value;
      });
      debugPrint("UserCredential$userCredential");
      String uid = userCredential.user!.uid;
      CollectionReference reference = firebaseFirestore.collection("users");
      String role = "";
      QuerySnapshot snapshots =
          await reference.where('uid', isEqualTo: uid).get();

      if (snapshots.docs.isNotEmpty) {
        DocumentSnapshot snapshot = snapshots.docs[0];
        role = snapshot['role'];
        setState(() {});
      }

      debugPrint("role: $role");
      role == 'user'
          ? Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UserPage()))
          : Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AdminPage()));
      // if (userCredential.user != null) {
      //   Navigator.pushReplacement(context,
      //       MaterialPageRoute(builder: (context) => const MyHomePage()));
      // }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 30,
          ),
          const Center(
            child: Text(
              "Welcome back",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          generatetextField(emailController, "Email", emailfocusNode),
          const SizedBox(
            height: 10,
          ),
          generatetextField(passwordController, "Pasword", passwordfocusNode),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage()));
              },
              child: const Text(
                "Forgot Password?",
                textAlign: TextAlign.end,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              )),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () {
              login();
            },
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text("Login"),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Donot have an account?",
            textAlign: TextAlign.center,
          ),
          TextButton(
              onPressed: () {
                navigateToSignUp(context);
              },
              child: const Text("SignUp")),
          TextButton(
              onPressed: () {
                signupwithGoogle();
              },
              child: const Text("Sign up with Google"))
        ],
      ),
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
