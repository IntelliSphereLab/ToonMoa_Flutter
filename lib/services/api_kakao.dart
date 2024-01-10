// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:toonquirrel/screens/milestone_screen.dart';

class KakaoService {
  final storage = const FlutterSecureStorage();

  Future<void> handleKakaoLogin(BuildContext context) async {
    try {
      final installed = await isKakaoTalkInstalled();

      if (installed) {
        final authCode = await UserApi.instance.loginWithKakaoTalk();
        await _saveTokenToSecureStorage(authCode);
        _navigateToHome(context);
      } else {
        final authCode = await UserApi.instance.loginWithKakaoAccount();
        await _saveTokenToSecureStorage(authCode);
        _navigateToHome(context);
      }
    } catch (error) {
      _showErrorMessage(context, 'Kakao Login Failed');
    }
  }

  Future<void> _saveTokenToSecureStorage(authCode) async {
    await storage.write(key: 'kakao_token', value: authCode.accessToken);
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MilestoneScreen()),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
