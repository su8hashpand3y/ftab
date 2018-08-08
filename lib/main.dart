import 'package:flutter/material.dart';
import 'package:flutter_tab/widgets/forget.dart';
import 'package:flutter_tab/widgets/login.dart';
import 'package:flutter_tab/widgets/mainTabs.dart';
import 'package:flutter_tab/widgets/register.dart';

void main() {
  runApp(RajdootApp());
}

class RajdootApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: LoginWidget(),
      routes: <String, WidgetBuilder>{
        '/main': (BuildContext context) => MainTabs(),
        '/register': (BuildContext context) => RegisterWidget(),
        '/forget': (BuildContext context) => ForgetWidget(),
      }
  );
  }
}

