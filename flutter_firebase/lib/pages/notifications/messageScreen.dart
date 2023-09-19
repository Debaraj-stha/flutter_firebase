import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key, required this.message, required this.id});
  final String message;
  final String id;
  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message"),
      ),
      body: ListView(children: [
        Text(widget.message),
        Text(widget.id),
      ]),
    );
  }
}
