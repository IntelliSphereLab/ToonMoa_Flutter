// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:toonquirrel/models/webtoon_model.dart';
import 'package:toonquirrel/services/api_service.dart';
import 'package:toonquirrel/widgets/webtoon_widget.dart';

class NaverHotScreen extends StatefulWidget {
  const NaverHotScreen({Key? key});

  @override
  _NaverWebtoonScreenState createState() => _NaverWebtoonScreenState();
}

class _NaverWebtoonScreenState extends State<NaverHotScreen> {
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

    ApiService.getNaverToons(page: currentPage, perPage: itemsPerPage)
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

      ApiService.getNaverToons(page: currentPage, perPage: itemsPerPage)
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
                padding: const EdgeInsets.only(top: 25.0),
                child: PageView.builder(
                  itemCount: webtoonList.length,
                  itemBuilder: (context, index) {
                    var webtoon = webtoonList[index];
                    final itemNumber = index + 1;
                    return Column(
                      children: [
                        Webtoon(
                          title: webtoon.title,
                          thumb: webtoon.thumb,
                          author: webtoon.author,
                          id: webtoon.id,
                          url: webtoon.url,
                          date: webtoon.date,
                        ),
                        Transform.translate(
                          offset: const Offset(90, 120),
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
