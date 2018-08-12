import 'package:flutter/material.dart';
import 'package:flutter_tab/widgets/Inbox/Inbox.dart';
import 'package:flutter_tab/widgets/Reply/reply.dart';
import 'package:flutter_tab/widgets/Search/search.dart';
import 'package:flutter_tab/widgets/setting/setting.dart';

class MainTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Column(children: <Widget>[
                  Tab(icon: Icon(Icons.search)),
                  Text('Search')
                ]),
                Column(children: <Widget>[
                  Tab(icon: Icon(Icons.inbox)),
                  Text('Inbox')
                ]),
                Column(children: <Widget>[
                  Tab(icon: Icon(Icons.reply)),
                  Text('Reply')
                ]),
                Column(children: <Widget>[
                  Tab(icon: Icon(Icons.settings)),
                  Text('Setting')
                ]),
              ],
            ),
            title: Text('Rajdoot'),
          ),
          body: TabBarView(
            children: [
              SearchWidget(),
              InboxWidget(),
              ReplyWidget(),
              Setting(),
            ],
          ),
        ),
      ),
    );
  }
}
