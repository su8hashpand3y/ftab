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
  //  createBannerAd();
  //   FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-8645673227744557~9580376080');
  //   _bannerAd = createBannerAd()..load()..show( anchorOffset: 0.0,
  //   anchorType: AnchorType.bottom);
 }

   BannerAd _bannerAd;
   static final MobileAdTargetingInfo targetingInfo = new MobileAdTargetingInfo(
    
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    birthday: new DateTime.now(),
    childDirected: true,
    gender: MobileAdGender.male,
  );

   BannerAd createBannerAd() {
    return new BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }
}
