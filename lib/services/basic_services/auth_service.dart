import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Stream<User?> get onAuthStateChanged {
    return _auth.authStateChanges();
  }

  static void registerAccountUsingEmail({
    required String email,
    required String password,
    required Function(String) onError,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (err) {
      print(err);
      if (err.code == "weak-password") {
        onError("Please enter a stronger password");
      } else if (err.code == "email-already-in-use") {
        onError("This email has already been registered to another account");
      }
    } catch (err) {
      // other errors
      print(err);
    }
  }

  static void loginUsingEmail({
    required String email,
    required String password,
    required Function(String) onError,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (err) {
      if (err.code == "user-not-found") {
        onError("There is no account connected to this email address");
      } else if (err.code == "wrong-password") {
        onError("Incorrect password");
      }
    } catch (err) {
      // other errors
      print(err);
    }
  }

  static void logOut() async {
    await _auth.signOut();
  }
}
