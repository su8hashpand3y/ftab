import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/internet.dart';
import 'package:flutter_tab/widgets/Inbox/inboxList.dart';
import 'package:flutter_tab/widgets/Reply/replyList.dart';
import 'package:flutter_tab/widgets/Search/search.dart';
import 'package:flutter_tab/widgets/setting/setting.dart';

class MainTabs extends StatefulWidget {
 @override
 MainTabsState createState() => MainTabsState();
}


class MainTabsState extends State<MainTabs> {
bool unreadInbox =false;
bool unreadReply =false;
@override
 initState() {
    // TODO: implement initState
    super.initState();
    this.isUnreadMessageThere();
    Timer.periodic(Duration(seconds: 3) ,(t){  if(this.mounted){this.isUnreadMessageThere();}});
  }

 isUnreadMessageThere() async {
     final res =  await Internet.get('${Internet.RootApi}/Message/IsUnreadMessageThere');
      if(res.status == 'good'){
        setState(() {
                  this.unreadInbox = res.data['item1'];
                  this.unreadReply = res.data['item2'];
                });
      }
 }

 openInbox(){
   setState(() {
        this.unreadInbox = false;
      });
 }

  openReply(){
   setState(() {
        this.unreadReply = false;
      });
 }
  
  
 @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      home: DefaultTabController( 
        length: 4,
        child: Scaffold( 
          appBar: AppBar(
            title: Text('Rajdoot'),
            bottom: TabBar(
              tabs: [
                Column(children: <Widget>[
                  Tab(icon: Icon(Icons.search),text: 'Search')
                ]),
                Column(children: <Widget>[
                  Tab(icon: Icon(Icons.inbox) , text: 'Inbox'),
                  this.unreadInbox ? Icon(Icons.brightness_1,
                        size: 8.0, color: Colors.redAccent) :  new Container(width: 0.0, height: 0.0),
                ]),
                Column(children: <Widget>[
                  Tab(icon: Icon(Icons.reply),text: 'Reply'),
                   this.unreadReply ? Icon(Icons.new_releases,
                        size: 8.0, color: Colors.redAccent) :  new Container(width: 0.0, height: 0.0)
                ]),
                Column(children: <Widget>[
                  Tab(icon: Icon(Icons.settings),text: 'Setting'),
                ]),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SearchWidget(),
              InboxListWidget(),
              ReplyListWidget(),
              Setting(context),
            ],
          ),
        ),
      ),
    );
  }
}
