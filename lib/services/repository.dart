

import 'package:firebase_auth/firebase_auth.dart';

abstract class Repository {

  Stream<String> authenticateUser();

}