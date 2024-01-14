// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:toonquirrel/services/api_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHovered = false;

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
          child: MouseRegion(
            onEnter: (event) {
              setState(() {
                isHovered = true;
              });
            },
            onExit: (event) {
              setState(() {
                isHovered = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.identity()..scale(isHovered ? 1.1 : 1.0),
              child: ElevatedButton.icon(
                onPressed: () => _handleKakaoLogin(context),
                icon: ImageIcon(
                  const AssetImage('assets/ToonLogin.png'),
                  size: isHovered ? 300 : 270,
                  color: isHovered ? Colors.yellow : Colors.black,
                ),
                label: const Text(""),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
