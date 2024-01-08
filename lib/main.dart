import 'package:flutter/material.dart';
import 'package:toonflix/screens/first_screen.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_auth.dart';

void main() {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

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
