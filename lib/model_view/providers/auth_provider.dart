import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googly_sign_in/features/states/auth_states/auth_reponse_states.dart';

class AuthNotifier
    extends StateNotifier<AuthResponseState<GoogleSignInAccount>> {
  AuthNotifier() : super(AuthResponseState.loggedout());
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> startSignIn() async {
    state = AuthResponseState.loading();
    // state = AuthResponseState.sign infailed("TESTING");

    // final GoogleSignInAccount? googleSignInAccount =
    //     await _googleSignIn.signIn().then((userData) {
    //   if (userData != null) {
    //     state = AuthResponseState.loggedin(userData);
    //   } else {
    //     state = AuthResponseState.signinfailed("");
    //   }
    // }).catchError((e) {
    //   state = AuthResponseState.signinfailed(e);
    //   // ignore: avoid_print
    //   print(e);
    // });

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    print(googleSignInAccount);

    if (googleSignInAccount != null) {
      state = AuthResponseState.loggedin(googleSignInAccount);
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        // ignore: unused_local_variable
        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential)
            .catchError((e) {
          print(e);
        });
        print('logged the user');
        _firestore.collection('Users').doc(userCredential.user?.uid).set({
          'uid': userCredential.user?.uid,
          'email': userCredential.user?.email,
        }, SetOptions(merge: true));
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "provider-already-linked":
            print("The provider has already been linked to the user.");
            break;
          case "invalid-credential":
            print("The provider's credential is not valid.");
            break;
          case "credential-already-in-use":
            print("The account corresponding to the credential already exists, "
                "or is already linked to a Firebase User.");
            break;
          default:
            print("Unknown error.");
        }
      }
    } else {
      print('user fire logging failed');
      state = AuthResponseState.signinfailed("Unknown Reason");
    }
  }

  Future<void> startSignOut() async {
    state = AuthResponseState.loading();
    _googleSignIn.signOut().then((value) {
      state = AuthResponseState.loggedout();
    }).catchError((e) {
      state = AuthResponseState.signoutfailed(e);
      // ignore: avoid_print
      print(e);
    });
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthResponseState>((ref) {
  return AuthNotifier();
});

// final authProvider = FutureProvider.autoDispose<GoogleSignInAccount>((ref) async {
  
//   return ;
// });