import 'package:firebase_auth/firebase_auth.dart';
import 'package:integration_bee_helper/services/settings_service/settings_service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Stream<User?> get onAuthStateChanged {
    return _auth.authStateChanges();
  }

  static Future registerAccountUsingEmail({
    required String email,
    required String password,
    required Function(String) onError,
  }) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await SettingsService().createSettings(uid: credentials.user!.uid);
    } on FirebaseAuthException catch (err) {
      if (err.code == "weak-password") {
        onError("Please enter a stronger password");
      } else if (err.code == "email-already-in-use") {
        onError("This email has already been registered to another account");
      }
    } catch (err) {
      // other errors
    }
  }

  static Future loginUsingEmail({
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
    }
  }

  static void logOut() async {
    await _auth.signOut();
  }
}
