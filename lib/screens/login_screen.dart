// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:toonquirrel/services/api_google.dart';
import '../services/api_kakao.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _handleKakaoLogin(BuildContext context) async {
    final kakaoService = KakaoService();
    kakaoService.handleKakaoLogin(context);
  }

  Future<void> _handleGoogleLogin(BuildContext context) async {
    final googleService = GoogleService();
    googleService.handleGoogleLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _handleKakaoLogin(context),
              child: const Text('Kakao Login'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _handleGoogleLogin(context),
              child: const Text('Google Login'),
            ),
          ],
        ),
      ),
    );
  }
}
