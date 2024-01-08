bool _isInstalled = true;

_initKaKaoTalkInstalled() async {
  final installed = await isKakaoTalkInstalled();
  setState(() {
    _isInstalled = installed;
  });
}

@override
void initState() {
  super.initState();
  _initKaKaoTalkInstalled();
}
