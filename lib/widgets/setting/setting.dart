import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    Storage.logout();
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
   return Column(
   children: <Widget>[
   
   Expanded(flex: 1,child: 
   Column(children: <Widget>[
     const SizedBox(height: 20.0),
      Center(child: Text("Instructions")),
      Flexible(child: Row(children: <Widget>[Icon(Icons.search, size: 50.0,), Text('Search User to start new conversation')])),
      Flexible(child: Row(children: <Widget>[Icon(Icons.inbox, size: 50.0,), Text('Conversation started with you appear in Inbox')])),
      Flexible(child: Row(children: <Widget>[Icon(Icons.reply, size: 50.0,), Text('Conversation started by you appear in Reply')])),
      Flexible(child: Row(children: <Widget>[Icon(Icons.favorite, size:50.0,), Text('Press on any message to keep it on top')])),
      // Flexible(child: Wrap(children: <Widget>[Text('Step 2:',style: TextStyle(fontWeight: FontWeight.bold)), Text('Click on serch result to start a new converation,In case you already started a conversation and would like to continue that conversation go to Reply menu '),Icon(Icons.reply),Text(' to continue that chat.')])),
      // Flexible(child: Wrap(children: <Widget>[Text('Step 3:',style: TextStyle(fontWeight: FontWeight.bold)), Text('Conversation started by you apear on Reply menu '),Icon(Icons.reply)])),
      // Flexible(child: Wrap(children: <Widget>[Text('Step 4:',style: TextStyle(fontWeight: FontWeight.bold)), Text('Conversation started by someone with you apear on Inbox menu '),Icon(Icons.inbox)])),
      // Flexible(child: Wrap(children: <Widget>[Text('Step 5:',style: TextStyle(fontWeight: FontWeight.bold)), Text('Be cool and awesome and write something constructive.'),Icon(Icons.favorite)])),
      // Flexible(child: Wrap(children: <Widget>[Text('Step 6:',style: TextStyle(fontWeight: FontWeight.bold)), Text('Go to search menu '),Icon(Icons.search),Text(' to start')])),
   ])),
      
      
      RaisedButton(onPressed: _logout, child: Text('Click to Logout and Close')),
            const SizedBox(height: 60.0)

    ]);
  }
}
