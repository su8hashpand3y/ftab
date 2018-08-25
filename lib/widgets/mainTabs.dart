import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/internet.dart';
import 'package:flutter_tab/widgets/Inbox/inboxList.dart';
import 'package:flutter_tab/widgets/Reply/replyList.dart';
import 'package:flutter_tab/widgets/Search/search.dart';
import 'package:flutter_tab/widgets/myAppBar.dart';
import 'package:flutter_tab/widgets/setting/setting.dart';

class MainTabs extends StatefulWidget {
  @override
  MainTabsState createState() => MainTabsState();
}

class MainTabsState extends State<MainTabs> with TickerProviderStateMixin{
  bool unreadInbox = false;
  bool unreadReply = false;
  TabController _tabController;
  bool isBusy = false;
  @override
  initState() {
    // TODO: implement initState
    _tabController = new TabController(vsync: this, length: 4, initialIndex: 0);
   _tabController.addListener(_handleTabSelection);
    super.initState();
    this.isUnreadMessageThere();
    Timer.periodic(Duration(seconds: 3), (t) {
      if (this.mounted) {
        this.isUnreadMessageThere();
      }
    });
  } 

  void _handleTabSelection() {
   FocusScope.of(context).requestFocus(new FocusNode());
}

  isUnreadMessageThere() async {
    if(!isBusy){
      isBusy = true;
    final res =
        await Internet.get('${Internet.RootApi}/Message/IsUnreadMessageThere');
    if (res.status == 'good' && this.mounted) {
      setState(() {
        this.unreadInbox = res.data['item1'];
        this.unreadReply = res.data['item2'];
      });
    }
    }

    isBusy= false;
  }

  openInbox() {
    setState(() {
      this.unreadInbox = false;
    });
  }

  openReply() {
    setState(() {
      this.unreadReply = false;
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Application will be closed'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: MaterialApp(
          home: DefaultTabController(

            length: 4,
            child: Scaffold(
              appBar: MyAppbar(
                
          
                preferredSizeWidget: TabBar( controller: _tabController,
                  tabs: [
                    Column(children: <Widget>[
                      Tab(icon: Icon(Icons.search), text: 'Search')
                    ]),
                    Column(children: <Widget>[
                       this.unreadInbox
                          ? Icon(Icons.brightness_1,
                              size: 8.0, color: Colors.redAccent)
                          : const SizedBox(),
                      Tab(icon: Icon(Icons.inbox), text: 'Inbox'),
                     
                    ]),
                    Column(children: <Widget>[
                      this.unreadReply
                          ? Icon(Icons.brightness_1,
                              size: 8.0, color: Colors.redAccent)
                          : const SizedBox(),
                      Tab(icon: Icon(Icons.reply), text: 'Reply'),
                      
                    ]),
                    Column(children: <Widget>[
                      Tab(icon: Icon(Icons.help), text: 'Help'),
                    ]),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  SearchWidget(),
                  InboxListWidget(),
                  ReplyListWidget(),
                  Setting(context),
                ],
              ),
            ),
          ),
        ));
  }
}
