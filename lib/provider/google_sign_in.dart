import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();

    /// If User doesn't select any account
    if (googleUser == null) return;
    _user = googleUser;
    var email = googleUser.email;

    ///  Check the existence
    var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await FirebaseAuth.instance.signInWithCredential(credential);

    if (!methods.contains('google.com')) {
      ///  User is trying to sign-up for first time
      final user = result.user;
      Map map = {
        "uid": user!.uid,
        "username": user.displayName,
        "email": user.email,
        "photoUrl": user.photoURL,
        "bio": "",
        "followers": jsonEncode([]),
        "following": jsonEncode([])
      };
      final res = await http.post(
          Uri.parse(
              "https://us-central1-highin-e8645.cloudfunctions.net/uploadUserLoginDataToFirebase"),
          body: map);
      if (res.statusCode == 401) {
        if (kDebugMode) {
          print("Some error occurred");
        }
      }
    }
    notifyListeners();
  }

  Future googleSignOut() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
