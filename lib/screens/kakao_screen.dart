import 'package:flutter/material.dart';
import 'package:toonquirrel/models/webtoon_model.dart';
import 'package:toonquirrel/services/api_service.dart';
import 'package:toonquirrel/widgets/webtoon_widget.dart';

class KakaoWebtoonPage extends StatelessWidget {
  const KakaoWebtoonPage({super.key});

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
      body: FutureBuilder<List<WebtoonModel>>(
        future: ApiService.getKakaoToons(),
        builder:
            (BuildContext context, AsyncSnapshot<List<WebtoonModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final webtoonList = snapshot.data;

          if (webtoonList == null || webtoonList.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          return Column(
            children: [
              const SizedBox(height: 50),
              Expanded(child: makeList(webtoonList)),
            ],
          );
        },
      ),
    );
  }

  ListView makeList(List<WebtoonModel> webtoonList) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: webtoonList.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
    );
  }
}
