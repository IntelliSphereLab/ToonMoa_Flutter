// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:toonquirrel/models/webtoon_model.dart';
import 'package:toonquirrel/services/api_service.dart';
import 'package:toonquirrel/widgets/episode_widget.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id, author, url, date;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
    required this.author,
    required this.url,
    required this.date,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonModel> webtoonDetailFuture;

  @override
  void initState() {
    super.initState();
    webtoonDetailFuture = ApiService.getEpisode(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    const authorTextStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    const loadingIndicator = CircularProgressIndicator();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color(0xFFEC6982),
        foregroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/ToonDetail.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: widget.id,
                  child: Container(
                    width: 300,
                    height: 300,
                    margin: const EdgeInsets.all(80),
                    decoration: const BoxDecoration(),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(widget.thumb),
                  ),
                ),
                const SizedBox(height: 70),
                FutureBuilder<WebtoonModel>(
                  future: webtoonDetailFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return loadingIndicator;
                    }

                    final authorText = Text(
                      '작가: ${widget.author}',
                      style: authorTextStyle,
                    );

                    final dateText = Text(
                      '업데이트: ${widget.date}',
                      style: authorTextStyle,
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        authorText,
                        dateText,
                      ],
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 50,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Episode(
                          initialUrl: widget.url,
                          title: widget.title,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
