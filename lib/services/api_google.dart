// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toonquirrel/screens/home_screen.dart';

class GoogleService {
  Future<void> handleGoogleLogin(BuildContext context) async {
    try {
      final googleAuth = await GoogleSignIn().signIn();
      print(googleAuth);
      if (googleAuth != null) {
        print("구글로그인 진입");
        _navigateToHome(context);
      }
    } catch (error) {
      _showErrorMessage(context, 'Google Login Failed');
    }
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
