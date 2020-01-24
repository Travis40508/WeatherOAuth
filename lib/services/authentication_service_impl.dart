
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_oauth/services/authentication_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationServiceImpl implements AuthenticationService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<AuthResult> fetchGoogleAuthentication() async {
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn?.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    final AuthResult authResult = await _auth?.signInWithCredential(credential);

    return authResult;
  }

}