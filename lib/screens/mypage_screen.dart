import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

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
          )),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is the My Webtoon Page'),
          ],
        ),
      ),
    );
  }
}
