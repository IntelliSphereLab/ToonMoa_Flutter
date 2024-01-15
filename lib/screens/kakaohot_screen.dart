// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:toonquirrel/models/webtoon_model.dart';
import 'package:toonquirrel/services/api_service.dart';
import 'package:toonquirrel/widgets/episode_widget.dart';
import 'package:toonquirrel/widgets/webtoon_widget.dart';

class KakaoHotScreen extends StatefulWidget {
  const KakaoHotScreen({super.key});

  @override
  _KakaoWebtoonScreenState createState() => _KakaoWebtoonScreenState();
}

class _KakaoWebtoonScreenState extends State<KakaoHotScreen> {
  List<WebtoonModel> webtoonList = [];
  int currentPage = 1;
  int itemsPerPage = 10;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() {
    setState(() {
      isLoading = true;
    });

    ApiService.getKakaoToons(page: currentPage, perPage: itemsPerPage)
        .then((initialWebtoons) {
      setState(() {
        webtoonList = initialWebtoons;
        isLoading = false;
      });
    });
  }

  void loadNextPage() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
        currentPage++;
      });

      ApiService.getKakaoToons(page: currentPage, perPage: itemsPerPage)
          .then((newWebtoons) {
        if (newWebtoons.isEmpty) {
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            webtoonList.addAll(newWebtoons);
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            if (scrollNotification.metrics.pixels >=
                scrollNotification.metrics.maxScrollExtent) {
              loadNextPage();
            }
          }
          return false;
        },
        child: Stack(
          children: [
            Image.asset(
              'assets/ToonHot.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: PageView.builder(
                  itemCount: webtoonList.length,
                  itemBuilder: (context, index) {
                    var webtoon = webtoonList[index];
                    final itemNumber = index + 1;
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Episode(
                                  initialUrl: webtoon.url,
                                  title: webtoon.title,
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: const BoxDecoration(),
                                child: Webtoon(
                                  title: webtoon.title,
                                  thumb: webtoon.thumb,
                                  author: webtoon.author,
                                  id: webtoon.id,
                                  url: webtoon.url,
                                  date: webtoon.date,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 350.0),
                                child: Text(
                                  webtoon.title,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(90, 220),
                          child: Text(
                            '$itemNumber',
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
