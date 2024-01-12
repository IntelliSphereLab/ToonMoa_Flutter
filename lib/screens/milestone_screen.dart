// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:toonquirrel/screens/mypage_screen.dart';
import 'package:toonquirrel/services/api_choice.dart';

class MilestoneScreen extends StatelessWidget {
  const MilestoneScreen({super.key});

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => ChoiceService.choiceService(context, "naver"),
              child: const Text('Naver Webtoon'),
            ),
            ElevatedButton(
              onPressed: () => ChoiceService.choiceService(context, "kakao"),
              child: const Text('Kakao Webtoon'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyPage(),
                  ),
                );
              },
              child: const Text('MyPage'),
            )
          ],
        ),
      ),
    );
  }
}
