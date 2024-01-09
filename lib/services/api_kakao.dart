// ignore_for_file: use_build_context_synchronously, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../screens/home_screen.dart';

class KakaoService {
  Future<void> handleKakaoLogin(BuildContext context) async {
    try {
      final installed = await isKakaoTalkInstalled();

      if (installed) {
        final authCode = await UserApi.instance.loginWithKakaoTalk();
        _navigateToHome(context);
      } else {
        final authCode = await UserApi.instance.loginWithKakaoAccount();
        _navigateToHome(context);
      }
    } catch (error) {
      print(error);
      _showErrorMessage(context, 'Kakao Login Failed');
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
