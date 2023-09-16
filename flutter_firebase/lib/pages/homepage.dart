import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/addPostPage.dart';
import 'package:flutter_firebase/pages/loginPage.dart';

import 'package:timeago/timeago.dart' as timeago;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String username = "";
  String userId = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    getUserName();
    super.initState();
  }

  Future<void> getUserName() async {
    CollectionReference userReference = firestore.collection("users");
    String userId = getUserId();
    QuerySnapshot snapshot =
        await userReference.where('uid', isEqualTo: userId).get();

    if (snapshot.docs.isNotEmpty) {
      username = snapshot.docs[0]['name'] as String;
      userId = snapshot.docs[0].id;
      debugPrint(username);

      setState(() {});
    }
  }

  Future<String> getAccountHolderName(String userId) async {
    return firestore.collection("users").doc(userId).get().then((value) {
      debugPrint(value.toString());
      print(userId);
      return value.data()?['name'];
    });
  }

  String getUserId() {
    return auth.currentUser!.uid;
  }

  void handleTap(int type, String id) async {
    CollectionReference reference = firestore.collection('posts');
    switch (type) {
      case 1:
        DocumentSnapshot snapshot = await reference.doc(id).get();
        String currentTitle = snapshot['title'];

        await reference
            .doc(id)
            .update({"title": "$currentTitle updated title"});
        break;
      case 2:
        reference.doc(id).delete();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(username),
          actions: [
            TextButton(
                onPressed: () {
                  auth.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Text("Logout")),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddPost(userId: userId)));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  constraints: const BoxConstraints(maxHeight: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Add Post",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('posts').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError)
                return Text("Error: ${snapshot.error}");
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = snapshot.data!.docs[index];
                  final image = data['image'];
                  debugPrint(image.toString());
                  Timestamp timestamp = data['created_at'];
                  DateTime postDate = timestamp.toDate();
                  return Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "asset/cool-profile-pic-matheus-ferrero.jpeg"),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder(
                                        future: getAccountHolderName(
                                            data['userId']),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                                snapshot.data.toString());
                                          } else {
                                            return const Text("l");
                                          }
                                        },
                                      ),
                                      Text(timeago.format(postDate)),
                                      // Text(.toString())
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(data['title']),
                              const SizedBox(
                                height: 5,
                              ),
                              if (image != 0 ||
                                  image != null ||
                                  image == []) ...[
                                GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: image.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: const BorderSide(
                                                width: 1, color: Colors.blue),
                                          ),
                                          child: Image(
                                              image:
                                                  NetworkImage(image[index])),
                                        ),
                                      );
                                    })
                              ],
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () async {
                                        handleTap(1, data.id);
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                        size: 25,
                                      )),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        handleTap(2, data.id);
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 25,
                                      ))
                                ],
                              ),
                              const Divider(
                                thickness: 1,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ],
                      ));
                },
              );
            }));
  }
}
