
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationService {

  ///Fetches Google authentication
  ///signInSilently will control whether or not the user is signed in via animation or behind the scenes
  Future<AuthResult> fetchGoogleAuthentication(final bool signInSilently);

  ///signs user out from both Firebase and Google
  Future<void> signOutUser();
}