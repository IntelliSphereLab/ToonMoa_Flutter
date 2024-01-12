// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:toonquirrel/models/webtoon_model.dart';


class DaysScreen extends StatefulWidget {
  const DaysScreen({super.key});

  @override
  _DaysScreenState createState() => _DaysScreenState();
}

class _DaysScreenState extends State<DaysScreen> {
  Map<String, List<WebtoonModel>> webtoonsByDay = {};

  @override
  void initState() {
    super.initState();
    // webtoonListByDay 함수를 호출하여 요일별 웹툰 데이터를 받아옴
    webtoonListByDay().then((data) {
      setState(() {
        webtoonsByDay = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('요일별 웹툰'),
      ),
      body: ListView.builder(
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
                physics: const NeverScrollableScrollPhysics(),
                itemCount: webtoons.length,
                itemBuilder: (context, index) {
                  WebtoonModel webtoon = webtoons[index];

                 
                  return ListTile(
                    title: Text(webtoon.title),
                    subtitle: Text(webtoon.author),
                 
                    onTap: () {
                      // 웹툰 상세 화면으로 이동하는 코드
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
