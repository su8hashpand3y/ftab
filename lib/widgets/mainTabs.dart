import 'package:flutter/material.dart';
import 'package:flutter_tab/widgets/reply.dart';
import 'package:flutter_tab/widgets/search.dart';
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
                Column(
                 children: <Widget>[
                   Tab(icon: Icon(Icons.search)),
                   Text('Search')
                 ]),
                  Column(
                 children: <Widget>[
                   Tab(icon: Icon(Icons.inbox)),
                   Text('Inbox')
                 ]),
                  Column(
                 children: <Widget>[
                   Tab(icon: Icon(Icons.reply)),
                   Text('Reply')
                 ]),
                  Column(
                 children: <Widget>[
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
              Icon(Icons.insert_chart),
              ReplyWidget(),
              Icon(Icons.settings_input_antenna),
            ],
          ),
        ),
      ),
    );
  }
}