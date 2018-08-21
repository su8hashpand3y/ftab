import 'package:flutter/material.dart';
import 'package:flutter_tab/widgets/Login/forget.dart';
import 'package:flutter_tab/widgets/Login/login.dart';
import 'package:flutter_tab/widgets/Login/register.dart';
import 'package:flutter_tab/widgets/mainTabs.dart';


import 'package:firebase_admob/firebase_admob.dart';

void main() {
  runApp(RajdootApp());
  
}

class RajdootApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginWidget(), routes: <String, WidgetBuilder>{
      '/login': (BuildContext context) => LoginWidget(),
      '/main': (BuildContext context) => MainTabs(),
      '/register': (BuildContext context) => RegisterWidget(),
      '/forget': (BuildContext context) => ForgetWidget(),
    });
  }

 RajdootApp(){
    // FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-5723471843217494~4832791339');
    // createBannerAd();
    // createBannerAd()..load()..show( anchorOffset: 0.0,
    // anchorType: AnchorType.bottom);
 }


   BannerAd createBannerAd() {
    return new BannerAd(
      adUnitId: 'ca-app-pub-5723471843217494/1629394564',
      size: AdSize.banner,
    );
  }
}
