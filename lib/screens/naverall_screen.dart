// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:toonquirrel/models/webtoon_model.dart';
import 'package:toonquirrel/screens/naverday_screen.dart';
import 'package:toonquirrel/screens/naverhot_screen.dart';

class NaverAllScreen extends StatefulWidget {
  const NaverAllScreen({super.key});

  @override
  _DaysScreenState createState() => _DaysScreenState();
}

class _DaysScreenState extends State<NaverAllScreen> {
  Map<String, List<WebtoonModel>> webtoonsByDay = {};

  @override
  void initState() {
    super.initState();
  }

  void navigateToNaverDayWebtoonScreen(String day) {
    if (day == 'ALL Favorite') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const NaverHotScreen(),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NaverDayScreen(
            day: day,
          ),
        ),
      );
    }
  }

  ElevatedButton buildDayButton(String day) {
    return ElevatedButton(
      onPressed: () => navigateToNaverDayWebtoonScreen(day),
      child: Text(
        day,
        style: const TextStyle(
          fontSize: 15,
          fontFamily: 'TTMilksCasualPie',
          color: Color(0xFFEC6982),
        ),
      ),
    );
  }

  Widget buildButtonRow(List<String> days) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 45.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) => buildDayButton(day)).toList(),
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
            fontFamily: 'TTMilksCasualPie',
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/ToonSelect.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 45.0),
                child: Text(
                  "Naver",
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'TTMilksCasualPie',
                    color: Colors.white,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 40.0),
                child: Text(
                  "WebToon",
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'TTMilksCasualPie',
                    color: Colors.white,
                  ),
                ),
              ),
              buildButtonRow(['ALL Favorite', 'naverDaily']),
              buildButtonRow(['mon', 'tue', 'wed', 'thu']),
              buildButtonRow(['fri', 'sat', 'sun', 'Finished']),
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
                            day,
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
        ],
      ),
    );
  }
}
