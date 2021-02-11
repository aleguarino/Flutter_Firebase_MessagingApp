import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging_app/auth/android_auth_provider.dart';
import 'package:firebase_messaging_app/screens/components/message_form.dart';
import 'package:firebase_messaging_app/screens/components/message_wall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  final store = FirebaseFirestore.instance.collection('chat_messages');

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _signedIn = false;

  void _signIn() async {
    try {
      await AuthProvider().signInWithGoogle();
      setState(() => _signedIn = true);
    } catch (e) {
      print('Login failed: $e');
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() => _signedIn = false);
  }

  void _addMessage(String value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await widget.store.add({
        'author': user.displayName ?? 'Anonymous',
        'author_id': user.uid,
        'photo_url': user.photoURL ?? 'https://placehold.it/100x100',
        'timestamp': Timestamp.now().millisecondsSinceEpoch,
        'value': value,
      });
    }
  }

  void _deleteMessage(String docId) async {
    await widget.store.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          if (_signedIn)
            InkWell(
              onTap: _signOut,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.logout),
              ),
            ),
        ],
      ),
      backgroundColor: Color(0xFFDEE2D6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: widget.store.orderBy('timestamp').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.isEmpty) {
                      return Center(
                        child: Text('No messages to display'),
                      );
                    }
                    return MessageWall(
                      messages: snapshot.data.docs,
                      onDelete: _deleteMessage,
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            if (_signedIn)
              MessageForm(
                onSubmit: _addMessage,
              )
            else
              Container(
                padding: const EdgeInsets.all(5),
                child: SignInButton(
                  Buttons.Google,
                  onPressed: _signIn,
                  padding: const EdgeInsets.all(5),
                ),
              )
          ],
        ),
      ),
    );
  }
}
