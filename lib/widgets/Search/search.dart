import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/internet.dart';
import 'package:flutter_tab/viewModels/messageCard.dart';
import 'package:flutter_tab/viewModels/userInfo.dart';
import 'package:flutter_tab/widgets/Reply/replyList.dart';
import 'package:flutter_tab/widgets/Search/searchResult.dart';

class SearchWidget extends StatefulWidget {
  @override
  SearchWidgetState createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  final formKey = GlobalKey<FormState>();
  String _searchTerm = "";
  int _skip = 0;
  List<UserInfo> _data;
  bool noResult = true;
  bool notSearhed = true;
  bool isBusy = false;
  @override
  void initState() {
    super.initState();
    _data = new List<UserInfo>();
  }

  sendMessage(userName, dynamic context) {
    MessageCard card = new MessageCard(userName, null, 0, null, false, 0);
    ReplyListWidgetState.sendMessage(card, context);
  }

  Future _search() async {
    if (!isBusy) {
      isBusy = true;
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        this.notSearhed = false;
        this.noResult = true;
        final res = await Internet.get(
            '${Internet.RootApi}/Login/Search?searchTerm=$_searchTerm&skip=$_skip');
        this.isBusy = false;
        if (res.status == 'good') {
          if (this.mounted) {
            setState(() {
              _data = new List<UserInfo>();
              if (res.data.length > 0) {
                this.noResult = false;
              }
              for (var item in res.data) {
                _data.add(new UserInfo(
                    item["userId"], item["name"], item["userImage"]));
              }
            });
          }
        }
      }
    }
  }

  buildSearchResult(UserInfo user) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.cyan[100],
            border: Border.all(color: Colors.lightBlue.shade900, width: 1.0)),
        child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                user.userImage == null
                    ? new Icon(Icons.image)
                    : new Image.network(user.userImage,
                        height: 50.0, fit: BoxFit.fill),
                Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('UserId: ${user.userId}',
                              overflow: TextOverflow.ellipsis),
                          Text('UserName: ${user.userName}',
                              overflow: TextOverflow.ellipsis),
                          Divider(height: 2.0, color: Colors.black)
                        ]))
              ],
            )));
  }

  //@override
  Future _OpenMessage(UserInfo user) async {
    await Navigator.of(context).push(new MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return new SearchResultWidget(user);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                            child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter value';
                            }
                          },
                          onSaved: (val) => _searchTerm = val,
                          decoration: const InputDecoration(
                            hintText: 'Search by UserId or user Name',
                          ),
                        )),
                        GestureDetector(
                          onTap: _search,
                          child: Icon(Icons.search),
                        ),
                      ])),
            ],
          ),
        )),
        notSearhed
            ? Expanded(
                flex: 1,
                child: Column(children: <Widget>[
                  const SizedBox(height: 20.0),
                  Flexible(
                      child: Row(children: <Widget>[
                    Icon(
                      Icons.search,
                      size: 50.0,
                    ),
                    Text('Search User to start new conversation')
                  ])),
                  Flexible(
                      child: Row(children: <Widget>[
                    Icon(
                      Icons.inbox,
                      size: 50.0,
                    ),
                    Text('Conversation started with you apear here')
                  ])),
                  Flexible(
                      child: Row(children: <Widget>[
                    Icon(
                      Icons.reply,
                      size: 50.0,
                    ),
                    Text('Conversation started by you apear here')
                  ])),
                  Flexible(
                      child: Row(children: <Widget>[
                    Icon(
                      Icons.favorite,
                      size: 50.0,
                    ),
                    Text('Press on any message to keep it on top')
                  ])),
                ]))
            : const SizedBox(),
        !notSearhed && noResult ? Text('No Result') : const SizedBox(),
        // Container(decoration: BoxDecoration(border: Border(bottom:  new BorderSide(width: 2.0, color: Colors.lightBlue.shade900)))),
        Expanded(
          flex: 1,
          // child: Text(_data.length.toString()),
          child: Container(
              child: ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, int index) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              sendMessage(_data[index].userId, context);
                            },
                            child: Column(children: <Widget>[
                              buildSearchResult(_data[index]),
                              const SizedBox(height: 1.0)
                            ]))),
                    GestureDetector(
                        onTap: () {
                          _OpenMessage(_data[index]);
                        },
                        child: Icon(Icons.more))
                  ]);
            },
          )),
        ),
        const SizedBox(height: 60.0)
      ],
    );
  }
}
