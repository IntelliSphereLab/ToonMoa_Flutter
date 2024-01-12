// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:toonquirrel/models/webtoon_model.dart';
import 'package:toonquirrel/services/api_service.dart';
import 'package:toonquirrel/widgets/webtoon_widget.dart';

class NaverDayScreen extends StatefulWidget {
  final String date;

  const NaverDayScreen({super.key, required this.date});

  @override
  _NaverDayScreenState createState() => _NaverDayScreenState();
}

class _NaverDayScreenState extends State<NaverDayScreen> {
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

    ApiService.getKakaoToonByDate(widget.date).then((initialWebtoons) {
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
      backgroundColor: Colors.white,
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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: webtoonList.length,
                itemBuilder: (context, index) {
                  var webtoon = webtoonList[index];
                  return Webtoon(
                    title: webtoon.title,
                    thumb: webtoon.thumb,
                    author: webtoon.author,
                    id: webtoon.id,
                    url: webtoon.url,
                    date: webtoon.date,
                  );
                },
              ),
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
