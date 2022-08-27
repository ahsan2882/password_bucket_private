import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../value_notifiers.dart';

class CurrentUser extends ChangeNotifier {
  late String _uid;
  late String _email;

  String get getUid => _uid;
  String get getEmail => _email;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> signUpUser(
      {name: String,
      phoneNumber: String,
      email: String,
      password: String}) async {
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
        _db
            .collection('users')
            .doc(userCredentials.user?.uid)
            .set(user)
            .onError((error, _) => print('Error writing document: $error'));
      }
    } catch (e) {
      registerStatus = false;
      showMessagePopup.value = true;
      int startIndex = e.toString().indexOf(']');
      showMessagePopupText.value =
          e.toString().substring(startIndex + 1).trim();
      disableRegisterButton.value = false;
      await Future.delayed(const Duration(seconds: 5));
      showMessagePopup.value = false;
      showMessagePopupText.value = '';
    }
    return registerStatus;
  }
}
