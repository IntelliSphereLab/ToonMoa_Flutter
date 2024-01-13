// ignore_for_file: use_build_context_synchronously, avoid_print, unused_local_variable

import 'dart:convert';

import 'package:http/http.dart' as http;
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
        User user = await UserApi.instance.me();

        await _saveTokenToSecureStorage(authCode);
        await _saveUserInfoToServer(user);
        _navigateToHome(context);
      } else {
        final authCode = await UserApi.instance.loginWithKakaoAccount();
        User user = await UserApi.instance.me();

        await _saveTokenToSecureStorage(authCode);
        await _saveUserInfoToServer(user);
        _navigateToHome(context);
      }
    } catch (error) {
      print(error);
      _showErrorMessage(context, 'Kakao Login Failed');
    }
  }

  Future<void> _saveUserInfoToServer(User user) async {
    try {
      final email = user.kakaoAccount!.email;
      final profile = user.kakaoAccount!.profile;
      final response = await http.post(
        Uri.parse('http://localhost:4000/member/saveUser'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'profile': profile}),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _saveTokenToSecureStorage(authCode) async {
    await storage.write(key: 'kakao_token', value: authCode.accessToken);
  }

  static Future<String?> getEmail() async {
    try {
      final user = await UserApi.instance.me();
      final email = user.kakaoAccount!.email;
      return email;
    } catch (error) {
      rethrow;
    }
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
