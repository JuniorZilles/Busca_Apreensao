import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthImplementation {
  Future<User> signIn(String email, String password);
  Future<User> createUser(String email, String password);
  Future<void> requestNewPassword(String email);
  Future<User> getCurrentUser();
  Future<void> signOut();
}

class Auth implements AuthImplementation {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> signIn(String email, String password) async {
    User user;
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (result != null) {
      user = result.user;
    }
    return user;
  }

  @override
  Future<User> createUser(String email, String password) async {
    User user;
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (result != null) {
      user = result.user;
    }
    return user;
  }

  Future<User> getCurrentUser() async {
    User user = await _firebaseAuth.currentUser;
    return user;
  }

  Future<void> requestNewPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
}
