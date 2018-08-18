import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/internet.dart';
import 'package:flutter_tab/viewModels/messageCard.dart';
import 'package:flutter_tab/widgets/Reply/sendReply.dart';

class ReplyListWidget extends StatefulWidget {
  @override
  ReplyListWidgetState createState() => ReplyListWidgetState();
}

class ReplyListWidgetState extends State<ReplyListWidget> {
  List<MessageCard> _data;
  List<MessageCard> filteredData;

  static dynamic localContext;

  @override
  void initState() {
    super.initState();
    _data = new List<MessageCard>();
    filteredData = new List<MessageCard>();
    this._loadData();
    Timer.periodic(Duration(seconds: 3), (t) {
      if (this.mounted) {
        this._loadData();
      }
    });
    Timer.periodic(Duration(seconds: 3), (t) {
      if (this.mounted) {
        this.refeshMessageCount();
      }
    });
  }

  refeshMessageCount() async {
    final res =
        await Internet.get('${Internet.RootApi}/Message/GetReplyMessageCount');
    if (res.status == 'good') {
      if (this.mounted) {
        MessageCard msg;
        for (var item in res.data) {
          if (this
              ._data
              .contains((m) => m.messageGroupUniqueGuid == item["item1"])) {
            msg = this
                ._data
                .firstWhere((m) => m.messageGroupUniqueGuid == item["item1"]);
            if (msg.unreadCount != item["item2"]) {
              bool newMessages = item["item2"] > msg.unreadCount;
              msg.unreadCount = item["item2"];
              msg.lastMessage = item["item3"];

              if (newMessages) {
                int removalIndex = _data.indexOf(msg);
                _data.removeAt(removalIndex);
                if (msg.isFav)
                  _data.insert(0, msg);
                else {
                  if (this._data.contains((y) => y.isFav == false)) {
                    int newIndex =
                        _data.lastIndexWhere((y) => y.isFav == false);
                    _data.insert(newIndex, msg);
                  } else
                    _data.insert(_data.length - 1, msg);
                }
              }
            }
          }
        }
      }
    }

    setState(() {});
  }


  _markReplyAsFav(MessageCard messageCard) async {
    if (!messageCard.isFav) {
      int removalIndex = _data.indexOf(messageCard);
      _data.removeAt(removalIndex);
      messageCard.isFav = !messageCard.isFav;
      _data.insert(0, messageCard);
    }
    else
      messageCard.isFav = !messageCard.isFav;

    Internet.get(
        '${Internet.RootApi}/Message/MarkReplyAsFav?messageGroupUniqueId=${messageCard.messageGroupUniqueGuid}');
  }

  Future _loadData() async {
    final res = await Internet.get(
        '${Internet.RootApi}/Message/GetReplyMessageCard?lastId=${this._data.length > 0 && this._data.last != null ? this._data.last.lastId : 0}');
    if (res.status == 'good') {
      if (res.data.length > 0) {
            for (var item in res.data) {
              _data.add(new MessageCard(
                  item["userName"],
                  item["messageGroupUniqueGuid"],
                  item["unreadCount"],
                  item["lastMessage"],
                  item["isFav"],
                  item["lastId"]));
            }
        }

        if (this.mounted) {
          setState(() {
                      
                    });
        }

    }
  }

  static Future sendMessage(MessageCard message, context) async {
    await Navigator.of(context).push(new MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return new SendReplyWidget(message);
      },
    ));
  }

  //@override
  Future _openMessage(MessageCard message) async {
    await Navigator.of(context).push(new MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return new SendReplyWidget(message);
      },
    ));
  }



  makeCard(MessageCard message) {
    return new Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: new BorderSide(
                    width: 2.0, color: Colors.lightBlue.shade900))),
        padding: EdgeInsets.all(4.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                Text('From :'),
                Text('${message.userName}',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ]),
              SizedBox(height: 5.0),
              Text(message.lastMessage,
                  overflow: TextOverflow.ellipsis, maxLines: 2),
              SizedBox(height: 10.0)
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, int index) {
                return GestureDetector(
                    onTap: () {
                      this._openMessage(_data[index]);
                    },
                    child: Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: Row(children: <Widget>[
                          Expanded(child: makeCard(_data[index])),
                          Container(
                              width: 50.0,
                              child: Column(children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    this._markReplyAsFav(_data[index]);
                                  },
                                  child: _data[index].isFav
                                      ? Icon(Icons.favorite)
                                      : Icon(Icons.favorite_border),
                                ),
                                _data[index].unreadCount > 0
                                    ? Text('${_data[index].unreadCount} New',
                                        style: TextStyle(color: Colors.red))
                                    : const SizedBox()
                              ])),
                          Divider(height: 2.0, color: Colors.black)
                        ])));
              },
            ),
          ),
          const SizedBox(height: 60.0)
        ]));
  }
}
