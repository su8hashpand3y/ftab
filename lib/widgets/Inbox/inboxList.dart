import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/internet.dart';
import 'package:flutter_tab/viewModels/messageCard.dart';
import 'package:flutter_tab/widgets/Inbox/sendInbox.dart';
import 'package:flutter_tab/widgets/messageCardWidget.dart';

class InboxListWidget extends StatefulWidget {
  @override
  InboxListWidgetState createState() => InboxListWidgetState();
}

class InboxListWidgetState extends State<InboxListWidget> {
  List<MessageCard> _data;

  @override
  void initState() {
    super.initState();
    _data = new List<MessageCard>();
    this._loadData();
    Timer.periodic(Duration(milliseconds: 150000) ,(t){  if(this.mounted){this._loadData();}});
    Timer.periodic(Duration(milliseconds: 150000) ,(t){  if(this.mounted){this.refeshMessageCount();}});

  }

  Future _loadData() async {
    final res = await Internet.get(
        'http://127.0.0.1:58296/Message/GetInboxMessagesCard?lastId=${this._data.length > 0 && this._data.last != null ? this._data.last.lastId : 0}');
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
                item["isFav"],
                item["lastId"]));
          }
        });
      }
    }
  }

  refeshMessageCount() async {
    final res = await Internet
        .get('http://127.0.0.1:58296/Message/GetInboxMessageCount');
    if (res.status == 'good') {
      setState(() {
        if (this.mounted) {
          MessageCard m;
          for (var item in res.data) {
            m = this._data.firstWhere((m) =>
                m.messageGroupUniqueGuid == item["item1"]);
            m.unreadCount = item["item2"];
          }
        }
      });
    }
  }

  _markReplyAsFav(MessageCard messageCard) async {
    setState(() {
      messageCard.isFav = !messageCard.isFav;
    });
    final res = await Internet.get(
        'http://127.0.0.1:58296/Message/MarkInboxAsFav?messageGroupUniqueId=${messageCard.messageGroupUniqueGuid}');
    if (res.status != 'good') {
      setState(() {
        messageCard.isFav = !messageCard.isFav;
      });
    }
  }

  //@override
  Future _openMessage(MessageCard message) async {
    await Navigator.of(context).push(new MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return new SendInboxWidget(message);
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
                    child: Row(children: <Widget>[
                      MessageCardWidget(_data[index]),
                      GestureDetector(
                        onTap: () {
                          this._markReplyAsFav(_data[index]);
                        },
                        child: _data[index].isFav
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                      ),
                    ]));
              },
            ),
          )
        ]));
  }
}
