import 'package:flutter/material.dart';

import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:toonquirrel/screens/first_screen.dart';

void main() {
  KakaoSdk.init(
    nativeAppKey: '4c56c4fac42d1df7c38c5eb40e4e38c3',
    javaScriptAppKey: 'e6f48eafc3576f649fc1967d9d594666',
  );

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
