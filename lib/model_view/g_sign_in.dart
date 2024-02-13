import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GSignIN {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late User? user;
  bool signed = false;
  // late GoogleSignInAccount _currentUser;
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      user = userCredential.user;
      if (user != null) {
        signed = true;
        print("Sign in was successful");
      } else {
        print("Sign in failed");
      }

      print(user);
      // Use the user object for further operations or navigate to a new screen.
    } catch (e) {
      print('Error is this : ${e.toString()}');
    }
  }

  bool signInSuccessful() {
    return signed;
  }
}
