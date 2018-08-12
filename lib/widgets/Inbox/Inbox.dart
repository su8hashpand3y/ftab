import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/internet.dart';
import 'package:flutter_tab/viewModels/messageCard.dart';
import 'package:flutter_tab/widgets/Inbox/inboxMessageWidget.dart';
import 'package:flutter_tab/widgets/messageCardWidget.dart';

class InboxWidget extends StatefulWidget {
  @override
  InboxWidgetState createState() => InboxWidgetState();
}

class InboxWidgetState extends State<InboxWidget> {
  List<MessageCard> _data;

  @override
  void initState() {
    print("inti");
    super.initState();
    _data = new List<MessageCard>();
    this._loadData();
  }

  Future _loadData() async {
    final res = await Internet
        .get('http://127.0.0.1:58296/Message/GetInboxMessagesCard');
    if (res.status == 'bad') {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Alert'),
                content: Text('${res.message}'),
              ));
    }

    if (res.status == 'good') {
      if (this.mounted) {
        setState(() {
          _data = new List<MessageCard>();
          for (var item in res.data) {
            _data.add(new MessageCard(
                item["userName"],
                item["messageGroupUniqueGuid"],
                item["unreadCount"],
                item["lastMessage"],
                item["isFav"]));
          }
        });
      }
    }
  }

  //@override
  Future _openMessage(MessageCard message) async {
    await Navigator.of(context).push(new MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return new InboxMessageWidget(message);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          Flexible(
            // child: Text(_data.length.toString()),
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, int index) {
                return RaisedButton(
                  onPressed: () {
                    this._openMessage(_data[index]);
                  },
                  child: MessageCardWidget(_data[index]),
                );
              },
            ),
          )
        ]));
  }
}
