// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:toonquirrel/models/webtoon_model.dart';
import 'package:toonquirrel/screens/detail_screen.dart';
import 'package:toonquirrel/services/api_service.dart';

class KakaoDayScreen extends StatefulWidget {
  final String day;

  const KakaoDayScreen({super.key, required this.day});

  @override
  _KakaoDayScreenState createState() => _KakaoDayScreenState();
}

class _KakaoDayScreenState extends State<KakaoDayScreen> {
  List<WebtoonModel> webtoonList = [];
  int currentPage = 1;
  int itemsPerPage = 10;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadInitialData();
    _scrollController.addListener(_scrollListener);
  }

  void loadInitialData() {
    setState(() {
      isLoading = true;
    });

    ApiService.getKakaoToonByDate(widget.day).then((initialWebtoons) {
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

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/ToonAll.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                itemCount: webtoonList.length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  var webtoon = webtoonList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            title: webtoon.title,
                            thumb: webtoon.thumb,
                            author: webtoon.author,
                            id: webtoon.id,
                            url: webtoon.url,
                            date: webtoon.date,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.6),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              webtoon.thumb,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
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
