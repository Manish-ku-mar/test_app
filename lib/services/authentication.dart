import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/screen_director/authToInfo.dart';

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? userId() {
    if (auth.currentUser == null) return null;
    return auth.currentUser!.uid;
  }

  String? getPhoneNumber() {
    if (auth.currentUser == null) return null;
    return auth.currentUser!.phoneNumber;
  }

  Stream<User?> isAuthenticated() {
    return FirebaseAuth.instance.authStateChanges();
  }

  Future<void> phoneSignIn(PhoneAuthCredential credential) async {
    try {
      await auth.signInWithCredential(credential);
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> verifyPhoneNumber(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await phoneSignIn(credential);
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      Navigator.of(context).pushNamed(AuthToInfo.route);
    } on Exception catch (e) {
      throw e;
    }
  }
}
