
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationService {

  ///signInSilently will control whether or not the user is signed in via animation or behind the scenes
  Future<AuthResult> fetchGoogleAuthentication(final bool signInSilently);
}