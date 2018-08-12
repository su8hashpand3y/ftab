import 'package:flutter/material.dart';
import 'package:flutter_tab/widgets/Login/forget.dart';
import 'package:flutter_tab/widgets/Login/login.dart';
import 'package:flutter_tab/widgets/Login/register.dart';
import 'package:flutter_tab/widgets/mainTabs.dart';

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
}
