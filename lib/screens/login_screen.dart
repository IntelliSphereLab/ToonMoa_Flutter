// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:toonflix/screens/home_screen.dart';
import '../services/api_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _handleKakaoLogin(BuildContext context) async {
    try {
      // 카카오 계정으로 로그인을 시도합니다.
      final authCode = await UserApi.instance.loginWithKakaoAccount();

      print('카카오 계정으로 로그인 성공: $authCode');

      // 사용자 정보를 가져오는 예제:
      final User user = await UserApi.instance.me();
      print(user);
      // 홈 화면으로 이동하는 예제:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (error) {
      print('카카오 계정으로 로그인 실패: $error');
      _showErrorMessage(context, 'Kakao Login Failed');
    }
  }

  Future<void> _handleGoogleLogin(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ['email']).signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        bool isSuccess = await ApiService.loginWithGoogle(googleAuth.idToken!);
        if (isSuccess) {
          _navigateToHome(context);
        } else {
          _showErrorMessage(context, 'Google Login Failed');
        }
      } else {
        _showErrorMessage(context, 'Google Login Canceled');
      }
    } catch (e) {
      _showErrorMessage(context, 'Google Login Error: $e');
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
