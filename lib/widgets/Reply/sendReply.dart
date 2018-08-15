import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/internet.dart';
import 'package:flutter_tab/viewModels/message.dart';
import 'package:flutter_tab/viewModels/messageCard.dart';

class SendReplyWidget extends StatefulWidget {
  MessageCard _messageCard;
  SendReplyWidget(MessageCard _messageCard) {
    this._messageCard = _messageCard;
  }
  @override
  SendReplyWidgetState createState() =>
      SendReplyWidgetState(this._messageCard);
}

class SendReplyWidgetState extends State<SendReplyWidget> {
  final formKey = GlobalKey<FormState>();
  List<Message> _data = new List<Message>();
  MessageCard _messageCard;
  String _message = "";
  SendReplyWidgetState(MessageCard _messageCard) {
    this._messageCard = _messageCard;
  }

  @override
  void initState() {
    super.initState();
    _data = new List<Message>();
    this._loadData();
    Timer.periodic(Duration(milliseconds: 150000) ,(t){ if(this.mounted){this._loadData();}});
  }

  Future _loadData() async {
    
    final res = await Internet.get(
        'http://127.0.0.1:58296/Message/GetReplyMessage?messageGroupUniqueId=${this._messageCard.messageGroupUniqueGuid}&lastId=${this._data.length > 0 && this._data.last != null ? this._data.last.lastId : 0}');
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
          //_data = new List<Message>();
          for (var item in res.data) {
            _data.add(new Message(
                item["dateTime"], item["isMyMessage"], item["message"], item["lastId"]));
          }
        });
      }
    }
  }

  Future _sendMessage() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      final res =
          await Internet.post('http://127.0.0.1:58296/Message/ReplyMessage', {
        'messageGroupUniqueId': this._messageCard.messageGroupUniqueGuid,
        'message': this._message
      });

      if (res.status == 'bad') {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Alert'),
                  content: Text('${res.message}'),
                ));
      }
      if (res.status == 'good') {
       this._loadData();
       setState(() {
                  this._message = "";
                });
        // Navigator.of(context).pop('/main');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(this._messageCard.userName),
      ),
      body: ListView(children: <Widget>[
        new Padding(
            padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
            child: Column(children: <Widget>[
              Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      // child: Text(_data.length.toString()),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _data.length,
                        itemBuilder: (context, int index) {
                          return Text(_data[index].message);
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: <Widget>[
                          Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        // mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Flexible(
                                              child: TextFormField(
                                            maxLines: 2,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter value';
                                              }
                                            },
                                            onSaved: (val) => _message = val,
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'Type and press send icon',
                                            ),
                                          )),
                                          FlatButton(
                                            onPressed: _sendMessage,
                                            child: Icon(Icons.send),
                                          ),
                                        ])),
                              ],
                            ),
                          )
                        ])),
                  ])
            ]))
      ]),
    );
  }
}
