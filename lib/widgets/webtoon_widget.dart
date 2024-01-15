import 'package:flutter/material.dart';
import 'package:toonquirrel/screens/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id, author, url, date;

  const Webtoon({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
    required this.author,
    required this.url,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              title: title,
              thumb: thumb,
              author: author,
              id: id,
              url: url,
              date: date,
            ),
            fullscreenDialog: true,
          ),
        );
      },
      child: Column(
        children: [
          Hero(
            tag: id,
            child: Container(
              width: 400,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(thumb),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
