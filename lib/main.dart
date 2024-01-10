import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:toonquirrel/screens/first_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..userAgent =
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36';
  }
}

void main() {
  KakaoSdk.init(
    nativeAppKey: '4c56c4fac42d1df7c38c5eb40e4e38c3',
    javaScriptAppKey: 'e6f48eafc3576f649fc1967d9d594666',
  );
  HttpOverrides.global = MyHttpOverrides();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FirstScreen(),
    );
  }
}
