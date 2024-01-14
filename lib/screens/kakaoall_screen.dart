// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:toonquirrel/models/webtoon_model.dart';
import 'package:toonquirrel/screens/kakaoday_screen.dart';
import 'package:toonquirrel/screens/kakaohot_screen.dart';

class KakaoAllScreen extends StatefulWidget {
  const KakaoAllScreen({super.key});

  @override
  _DaysScreenState createState() => _DaysScreenState();
}

class _DaysScreenState extends State<KakaoAllScreen> {
  Map<String, List<WebtoonModel>> webtoonsByDay = {};

  @override
  void initState() {
    super.initState();
  }

  void navigateToKakaoDayWebtoonScreen(day) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const KakaoDayScreen(
          date: 'day',
        ),
      ),
    );
  }

  void navigateToKakaoHotWebtoonScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const KakaoHotScreen(),
      ),
    );
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
            fontFamily: 'TTMilksCasualPie'
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("KaKao WebToon"),
          ElevatedButton(
            onPressed: navigateToKakaoHotWebtoonScreen,
            child: const Text('전체 인기순'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => navigateToKakaoDayWebtoonScreen('mon'),
                child: const Text('월요일'),
              ),
              ElevatedButton(
                onPressed: () => navigateToKakaoDayWebtoonScreen('tuo'),
                child: const Text('화요일'),
              ),
              ElevatedButton(
                onPressed: () => navigateToKakaoDayWebtoonScreen('wed'),
                child: const Text('수요일'),
              ),
              ElevatedButton(
                onPressed: () => navigateToKakaoDayWebtoonScreen('thu'),
                child: const Text('목요일'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => navigateToKakaoDayWebtoonScreen('fri'),
                child: const Text('금요일'),
              ),
              ElevatedButton(
                onPressed: () => navigateToKakaoDayWebtoonScreen('sat'),
                child: const Text('토요일'),
              ),
              ElevatedButton(
                onPressed: () => navigateToKakaoDayWebtoonScreen('sun'),
                child: const Text('일요일'),
              ),
              ElevatedButton(
                onPressed: () => navigateToKakaoDayWebtoonScreen('finished'),
                child: const Text('완결'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: webtoonsByDay.keys.length,
              itemBuilder: (context, index) {
                String day = webtoonsByDay.keys.elementAt(index);
                List<WebtoonModel> webtoons = webtoonsByDay[day] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '$day 요일',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: webtoons.length,
                      itemBuilder: (context, index) {
                        WebtoonModel webtoon = webtoons[index];

                        return ListTile(
                          title: Text(webtoon.title),
                          subtitle: Text(webtoon.author),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
