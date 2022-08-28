import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../value_notifiers.dart';

class CurrentUser extends ChangeNotifier {
  late String _uid;
  late String _email;

  String get getUid => _uid;
  String get getEmail => _email;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> signUpUser(
      {required String name,
      required String phoneNumber,
      required String email,
      required String password}) async {
    bool registerStatus = false;
    final user = <String, String>{
      'name': name,
      'phone': phoneNumber,
      'email': email
    };
    try {
      UserCredential userCredentials = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredentials.user != null) {
        registerStatus = true;
        userCredentials.user!.updateDisplayName(name);
        _db
            .collection('users')
            .doc(userCredentials.user?.email)
            .set(user)
            .onError((error, _) => print('Error writing document: $error'));
      }
    } on FirebaseAuthException catch (e) {
      registerStatus = false;
      showMessagePopupTextNotifier.value = e.message.toString();
      disableRegisterButtonNotifier.value = false;
    }
    return registerStatus;
  }

  Future<bool> loginWithEmail(
      {required String email, required String password}) async {
    bool loginStatus = false;

    try {
      UserCredential userCredentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredentials.user != null) {
        loginStatus = true;
        _uid = userCredentials.user!.uid;
      }
    } on FirebaseAuthException catch (e) {
      loginStatus = false;
      showMessagePopupTextNotifier.value = e.message.toString();
    }
    return loginStatus;
  }

  Future<UserCredential> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
