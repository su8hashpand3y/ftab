import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/storage.dart';

class Setting extends StatefulWidget {
  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  Future _logout() async {
    Storage.removeToken();
    await Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(onPressed: _logout, child: Text('Logout'));
  }
}
