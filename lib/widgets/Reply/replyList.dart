import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/internet.dart';
import 'package:flutter_tab/Helper/storage.dart';
import 'package:flutter_tab/viewModels/messageCard.dart';
import 'package:flutter_tab/widgets/Reply/sendReply.dart';

class ReplyListWidget extends StatefulWidget {
  @override
  ReplyListWidgetState createState() => ReplyListWidgetState();
}

class ReplyListWidgetState extends State<ReplyListWidget> {
  List<MessageCard> _data;
  bool noResult = true;
  static dynamic localContext;
  bool isBusy = false;
  @override
  void initState() {
    super.initState();
    _data = new List<MessageCard>();
    checkLocal();

    Timer.periodic(Duration(seconds: 3), (t) {
      if (this.mounted) {
        this._loadData();
      }
    });
    Timer.periodic(Duration(seconds: 4), (t) {
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
              .any((m) => m.messageGroupUniqueGuid == item["item1"])) {
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
                  if (this._data.any((y) => y.isFav == false)) {
                    int newIndex = _data.indexWhere((y) => y.isFav == false);
                    _data.insert(newIndex, msg);
                  } else
                    _data.insert(_data.length - 1, msg);
                }
              }

              await Storage.setString('ReplyCard', json.encode(this._data));
            }
          }
        }
      }
    }

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  dispose() {
    super.dispose();
  }

  Future moreOption(MessageCard card) async {
    showDialog(
        context: context,
        builder: (context) => new AlertDialog(
           title: new Text('More Options...'),
                content:
                   Container( height: 60.0,
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      GestureDetector( child: new Container(  color: Colors.lime, child: Text('Clear Message' , style: TextStyle(fontSize: 20.0),)), onTap: (){ deleteReply(card);Navigator.of(context).pop();}),
                      const SizedBox(height: 10.0),
                      GestureDetector( child: new Container(  color: Colors.lime, child: Text('Close', style: TextStyle(fontSize: 20.0),)), onTap: (){Navigator.of(context).pop();}),
                 ])
                ))
    );
  }

  deleteReply(MessageCard messageCard) async {
    int index =  this._data.indexOf(messageCard);
    this._data[index].lastMessage = "";
    await Storage.remove('RE:${messageCard.messageGroupUniqueGuid}');
    await Storage.setString('ReplyCard', json.encode(this._data));
     setState(() {
          
        });
    Internet.post('${Internet.RootApi}/Message/ClearReply?messageGroupUniqueId=${messageCard.messageGroupUniqueGuid}',null);
  }

  _markReplyAsFav(MessageCard messageCard) async {
    isBusy = true;
    if (!messageCard.isFav) {
      int removalIndex = _data.indexOf(messageCard);
      _data.removeAt(removalIndex);
      messageCard.isFav = !messageCard.isFav;
      _data.insert(0, messageCard);
    } else
      messageCard.isFav = !messageCard.isFav;

    await Storage.setString('ReplyCard', json.encode(this._data));
    isBusy = false;
    Internet.get(
        '${Internet.RootApi}/Message/MarkReplyAsFav?messageGroupUniqueId=${messageCard.messageGroupUniqueGuid}');
  }

  checkLocal() async {
    // check local storage for messages if any
    isBusy = true;
    final localData = await Storage.getString('ReplyCard');
    if (localData != null) {
      final jsonLocal = json.decode(localData);
      for (int i = 0; i < jsonLocal.length; i++) {
        _data.add(new MessageCard(
            jsonLocal[i]["userName"],
            jsonLocal[i]["messageGroupUniqueGuid"],
            jsonLocal[i]["unreadCount"],
            jsonLocal[i]["lastMessage"],
            jsonLocal[i]["isFav"],
            jsonLocal[i]["lastId"]));
      }
      if (this.mounted) {
        setState(() {
          noResult = false;
        });
      }
    }

    isBusy = false;
    this._loadData();
  }

  Future _loadData() async {
    if (!isBusy) {
      isBusy = true;
      final res = await Internet.get(
          '${Internet.RootApi}/Message/GetReplyMessageCard?lastId=${this._data.length > 0 && this._data.last != null ? this._data.last.lastId : 0}');
      if (res.status == 'good') {
        if (res.data.length > 0) {
          noResult = false;
          MessageCard msg;
          int insertIndex;
          for (var item in res.data) {
            if (!_data.any((x) =>
                x.messageGroupUniqueGuid == item["messageGroupUniqueGuid"])) {
             insertIndex = 0;
              if (item["isFav"] == false && this._data.any((m) => m.isFav == true)) {
                msg = this._data.lastWhere((m) =>
                     m.isFav == true);

                insertIndex = _data.indexOf(msg) +1;
              } 
              _data.insert(
                  insertIndex,
                  new MessageCard(
                      item["userName"],
                      item["messageGroupUniqueGuid"],
                      item["unreadCount"],
                      item["lastMessage"],
                      item["isFav"],
                      item["lastId"]));
            }
          }
        }

        await Storage.setString('ReplyCard', json.encode(this._data));

        if (this.mounted) {
          setState(() {});
        }
      }
    }
    isBusy = false;
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
    message.unreadCount = 0;

    await Navigator.of(context).push(new MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return new SendReplyWidget(message);
      },
    ));
  }

  makeCard(MessageCard message) {
    return GestureDetector(
        onLongPress: () {
          deleteReply(message);
        },
        onTap: () {
          this._openMessage(message);
        },
        child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(4.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    Text('${message.userName}',
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ]),
                  SizedBox(height: 5.0),
                  Text(message.lastMessage ?? "",
                      overflow: TextOverflow.ellipsis, maxLines: 2),
                ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          noResult ? Text('No Messages') : const SizedBox(),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, int index) {
                return Column(children: <Widget>[
                  new SizedBox(height: 5.0),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2.0)),
                      child: Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Row(children: <Widget>[
                            Expanded(flex: 1, child: makeCard(_data[index])),
                            Container(
                                width: 50.0,
                                child: Column(children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      this._markReplyAsFav(_data[index]);
                                    },
                                    child: _data[index].isFav
                                        ? Icon(Icons.favorite,
                                            color: Colors.orange)
                                        : Icon(Icons.favorite_border),
                                  ),
                                  _data[index].unreadCount > 0
                                      ? Text('${_data[index].unreadCount} New',
                                          style: TextStyle(color: Colors.red))
                                      : const SizedBox()
                                ])),
                            Divider(height: 2.0, color: Colors.black)
                          ])))
                ]);
              },
            ),
          ),
          const SizedBox(height: 60.0)
        ]));
  }
}
