import 'package:flutter/material.dart';
import 'package:toonquirrel/services/api_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _handleKakaoLogin(BuildContext context) async {
    final kakaoService = KakaoService();
    kakaoService.handleKakaoLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color(0xFFEC6982),
        foregroundColor: Colors.white,
        title: const Text(
          "TOONQUIRREL",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/ToonBack.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ElevatedButton.icon(
            onPressed: () => _handleKakaoLogin(context),
            icon: const ImageIcon(
              AssetImage('assets/ToonLogin.png'),
              size: 250,
              color: Colors.black,
            ),
            label: const Text(""),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}
