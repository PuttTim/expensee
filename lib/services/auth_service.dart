import 'package:expensee/models/response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  Future<Response> registerUser({required String username, required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      userCredential.user!.updateDisplayName(username);
      return Response(status: Status.success);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
      return Response(status: Status.error, message: e.code);
    }
  }

  Future<void> verifyEmail({required String email}) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> logoutUser() {
    return FirebaseAuth.instance.signOut();
  }

  Future<Response> loginUser({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Response(status: Status.success);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
      return Response(status: Status.error, message: e.code);
    }
  }

  Future<Response> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return Response(status: Status.success);
    } on FirebaseAuthException catch (e) {
      debugPrint('error: ${e.code}');
      return Response(status: Status.error, message: e.code);
    }
  }
}
