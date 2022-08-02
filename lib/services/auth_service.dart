import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  Future<String> registerUser(String username, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      userCredential.user!.updateDisplayName(username);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
      return e.code;
    }
  }

  Future<void> logoutUser() {
    return FirebaseAuth.instance.signOut();
  }
}
