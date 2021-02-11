import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging_app/screens/components/chat_message.dart';
import 'package:firebase_messaging_app/screens/components/chat_message_other.dart';
import 'package:flutter/material.dart';

class MessageWall extends StatelessWidget {
  final List<QueryDocumentSnapshot> messages;
  final ValueChanged<String> onDelete;

  const MessageWall({
    Key key,
    @required this.messages,
    @required this.onDelete,
  }) : super(key: key);

  bool _shoudDisplayAvatar(int index) {
    if (index == 0) return true;
    final previousId = messages[index - 1].data()['author_id'];
    final authorId = messages[index].data()['author_id'];
    return authorId != previousId;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final data = messages[index].data();
        final user = FirebaseAuth.instance.currentUser;

        if (user != null && user.uid == data['author_id'])
          return Dismissible(
            onDismissed: (direction) => onDelete(messages[index].id),
            key: ValueKey(data['timestamp']),
            child: ChatMessage(
              index: index,
              data: data,
            ),
          );
        return ChatMessageOther(
          index: index,
          data: data,
          showAvatar: _shoudDisplayAvatar(index),
        );
      },
    );
  }
}
