import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/promt.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;

class AddPost extends StatefulWidget {
  const AddPost({super.key, required this.userId});
  final String userId;

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _timer;
  double? progress;
  resetTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 5), () {
      // Unfocus the text field after 5 seconds of inactivity
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        resetTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  final List<XFile> _files = [];
  final List<String> _imageUrls = [];
  pickImage(BuildContext context) async {
    final image = await ImagePicker().pickMultiImage();
    _files.addAll(image);
    setState(() {});
  }

  void post() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String folderName = 'images';

    if (_titleController.text.isEmpty || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Title cannot be empty"),
        showCloseIcon: true,
        closeIconColor: Colors.black,
      ));
      return;
    }

    try {
      if (_files.isNotEmpty) {
        for (var file in _files) {
          storage.Reference reference = storage.FirebaseStorage.instance
              .ref()
              .child(folderName)
              .child("${DateTime.now().millisecondsSinceEpoch}.jpg");
          storage.UploadTask task = reference.putFile(File(file.path));

          await Future.value(task);
          String url = await reference.getDownloadURL();
          _imageUrls.add(url);
        }

        setState(() {});
      }

      firestore.collection('posts').add({
        'title': _titleController.text,
        'userId': widget.userId,
        'image': _imageUrls,
        'created_at': Timestamp.now()
      }).then((value) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Promt()));
      });
    } on FirebaseException {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Exception has occurred: ")));
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _timer?.cancel();
    _titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(width: 1, color: Colors.blue),
              ),
              child: TextFormField(
                onChanged: (value) {
                  resetTimer();
                },
                focusNode: _focusNode,
                controller: _titleController,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Caption here...",
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              pickImage(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            child: const Text(
              "Pick image",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (_files.isNotEmpty) ...[
            GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _files.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(width: 1, color: Colors.blue),
                      ),
                      child: Image.file(File(_files[index].path)),
                    ),
                  );
                })
          ],
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              post();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text(
              "POST",
              style: TextStyle(color: Colors.white),
            ),
          ),
          // SizedBox(
          //   height: 100, // Set your desired height here
          //   width: 100,
          //   child: LinearProgressIndicator(
          //     value: progress,
          //     borderRadius: BorderRadius.circular(5),
          //     color: const Color.fromARGB(255, 214, 210, 210),
          //     valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          //   ),
          // )
        ],
      ),
    );
  }
}
