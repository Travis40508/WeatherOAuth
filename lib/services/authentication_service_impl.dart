
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_oauth/services/authentication_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationServiceImpl implements AuthenticationService {

  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn;

  @override
  Future<AuthResult> fetchGoogleAuthentication(final bool signInSilently) async {
    if (_auth == null) {
      _auth = FirebaseAuth.instance;
    }

    _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = signInSilently ? await _googleSignIn?.signInSilently(suppressErrors: false) : await _googleSignIn?.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    final AuthResult authResult = await _auth?.signInWithCredential(credential);

    ///throw an exception if signing in fails so that the user is kicked to the login screen
    assert(authResult.user.displayName.isNotEmpty);

    return authResult;
  }

  @override
  Future<void> signOutUser() async {
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

}