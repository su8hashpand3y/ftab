import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/storage.dart';

class Setting extends StatefulWidget {
  BuildContext homeContext;
  Setting(BuildContext context){
      this.homeContext = context;
  }
  @override
  SettingState createState() => SettingState(this.homeContext);
}

class SettingState extends State<Setting> {
   BuildContext homeContext;
  SettingState(BuildContext context){
      this.homeContext = context;
  }
  Future _logout() async {
    Storage.removeToken();
    exit(0);
    // Navigator.of(homeContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(onPressed: _logout, child: Text('Logout and Close'));
  }
}
