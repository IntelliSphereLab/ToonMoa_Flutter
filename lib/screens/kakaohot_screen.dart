// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:toonquirrel/models/webtoon_model.dart';
import 'package:toonquirrel/services/api_service.dart';
import 'package:toonquirrel/widgets/webtoon_widget.dart';

class KakaoHotScreen extends StatefulWidget {
  const KakaoHotScreen({Key? key});

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
      backgroundColor: Colors.white,
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
