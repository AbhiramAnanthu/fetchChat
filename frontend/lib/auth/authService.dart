import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/screens/welcome.dart';
import 'package:frontend/screens/home.dart';

class AuthService {
  Future<void> signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == "weak-password") {
        message = "Password provided is too weak";
      } else if (e.code == "email-already-in-use") {
        message = "Email already in use";
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == "user-not-found") {
        message = "user not found";
      } else if (e.code == "wrong-password") {
        message = "Incorrect password";
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }
}
