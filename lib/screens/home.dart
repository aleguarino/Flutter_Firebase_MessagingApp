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
                stream: FirebaseFirestore.instance
                    .collection('chat_messages')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return MessageWall(
                      messages: snapshot.data.docs,
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
                onSubmit: (value) => print('==> $value'),
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
