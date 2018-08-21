import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget preferredSizeWidget;
  const MyAppbar({this.title, this.preferredSizeWidget});

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.black,
        height: preferredSize.height,
        child: new Column(
          children: <Widget>[const SizedBox(height: 30.0), this.preferredSizeWidget]
        ),
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(115.0);
}