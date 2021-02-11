import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging_app/auth/auth_provider_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

class _AndroidAuthProvider implements AuthProviderBase {
  @override
  Future<FirebaseApp> initialize() async {
    return await Firebase.initializeApp(
      name: 'The Chat Crew',
      options: FirebaseOptions(
        apiKey: "AIzaSyAhOd7O5yvnAYFfkYHTrKNTk70OJy4BpyQ",
        authDomain: "the-chat-crew-cac90.firebaseapp.com",
        projectId: "the-chat-crew-cac90",
        storageBucket: "the-chat-crew-cac90.appspot.com",
        messagingSenderId: "255072907531",
        appId: "1:255072907531:android:ff35fa1b1aa8f6b9e5320e",
      ),
    );
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

class AuthProvider extends _AndroidAuthProvider {}
