// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:toonquirrel/screens/gallary_screen.dart';
import 'package:toonquirrel/screens/galleryme_screen.dart';
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
            fontFamily: 'TTMilksCasualPie',
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/ToonMilestoon.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: const Alignment(-0.8, -0.97),
                child: IconButton(
                  onPressed: () =>
                      ChoiceService.choiceService(context, "naver"),
                  icon: const Icon(Icons.web),
                  iconSize: 120.0,
                  color: Colors.green,
                ),
              ),
              Align(
                alignment: const Alignment(0.8, -0.67),
                child: IconButton(
                  onPressed: () =>
                      ChoiceService.choiceService(context, "kakao"),
                  icon: const Icon(Icons.web),
                  iconSize: 120.0,
                  color: Colors.yellow,
                ),
              ),
              Align(
                alignment: const Alignment(-0.7, -0.27),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GalleryScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.photo_library),
                  iconSize: 110.0,
                  color: Colors.lightBlue,
                ),
              ),
              Align(
                alignment: const Alignment(0.8, 0.04),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MyGalleryScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.photo_album),
                  iconSize: 110.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
