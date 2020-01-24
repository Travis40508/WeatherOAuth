import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: Text(
          'OAuth!',
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: Center(
        child: RaisedButton(
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.white
            ),
          ),
          color: Colors.blueAccent,
          onPressed: () async {
            print('logging in');
            final GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();
            final GoogleSignInAuthentication googleSignInAuthentication =
                await googleSignInAccount.authentication;

            final AuthCredential credential = GoogleAuthProvider.getCredential(
              accessToken: googleSignInAuthentication.accessToken,
              idToken: googleSignInAuthentication.idToken,
            );

            final AuthResult authResult = await _auth.signInWithCredential(credential);
            final FirebaseUser user = authResult.user;

            print('Signed in with $user');
          },
        ),
      ),
    );
  }
}
