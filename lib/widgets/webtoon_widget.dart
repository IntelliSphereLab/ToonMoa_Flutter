import 'package:flutter/material.dart';

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
      child: Column(
        children: [
          Hero(
            tag: id,
            child: Container(
              width: 300,
              height: 300,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(
                thumb,
                fit: BoxFit.cover,
              ),
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
