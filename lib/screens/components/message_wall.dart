import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging_app/screens/components/chat_message_other.dart';
import 'package:flutter/material.dart';

class MessageWall extends StatelessWidget {
  final List<QueryDocumentSnapshot> messages;

  const MessageWall({
    Key key,
    @required this.messages,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ChatMessageOther(
          index: index,
          data: messages[index].data(),
        );
      },
    );
  }
}
