import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/internet.dart';
import 'package:flutter_tab/viewModels/userInfo.dart';

class SearchResultWidget extends StatefulWidget {
  UserInfo _userInfo;
  SearchResultWidget(UserInfo userInfo) {
    this._userInfo = userInfo;
  }
  @override
  SearchResultWidgetState createState() =>
      SearchResultWidgetState(this._userInfo);
}

class SearchResultWidgetState extends State<SearchResultWidget> {
  final formKey = GlobalKey<FormState>();
  UserInfo _userInfo;
  bool _readyTosend = false;
  String _message = "";
  SearchResultWidgetState(UserInfo userInfo) {
    this._userInfo = userInfo;
  }

  _changeReadyToSend() {
    if (this.mounted) {
      setState(() {
        this._readyTosend = true;
      });
    }
  }

  Future _sendMessage() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      final res = await Internet.post(
          'http://127.0.0.1:58296/Message/SendMessage',
          {'userUniqueId': this._userInfo.userId, 'message': this._message});

      if (res.status == 'bad') {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Alert'),
                  content: Text('${res.message}'),
                ));
      }
      if (res.status == 'good') {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text(
                      'Message Sent \n Go to reply to continue same conversation.'),
                ));
        Navigator.of(context).pop('/main');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(this._userInfo.userName),
      ),
      body: ListView(children: <Widget>[
        new Padding(
            padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
            child: Column(
              children: <Widget>[
                this._userInfo.userImage == null
                    ? new Icon(Icons.image)
                    : new Image.network(this._userInfo.userImage,
                        height: 300.0, fit: BoxFit.fill),
                Column(children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: <Widget>[
                        Text('User Id    :  ${this._userInfo.userId ?? ""}'),
                        Text('User Name  :  ${this._userInfo.userName ?? ""}')
                      ])),
                  _readyTosend == false
                      ? RaisedButton(
                          onPressed: _changeReadyToSend,
                          child: Text(
                              'Start New conversation with ${this._userInfo.userId}'))
                      : Form(
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
                                          maxLines: 3,
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
                ])
              ],
            ))
      ]),
    );
  }
}
