// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:toonquirrel/screens/kakaoall_screen.dart';
import 'package:toonquirrel/screens/naverall_screen.dart';

class ChoiceService {
  static Future<void> choiceService(
      BuildContext context, String service) async {
    switch (service) {
      case 'naver':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NaverAllScreen()),
        );
        break;
      case 'kakao':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const KakaoAllScreen()),
        );
        break;
      default:
        break;
    }
  }
}
