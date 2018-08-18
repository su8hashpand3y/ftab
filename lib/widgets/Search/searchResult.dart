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
          '${Internet.RootApi}/Message/SendMessage',
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20.0),
                this._userInfo.userImage == null
                    ? new Icon(Icons.image)
                    : new Image.network(this._userInfo.userImage,
                        fit: BoxFit.fill),
                Column(children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: <Widget>[
                        Text('User Id    :  ${this._userInfo.userId}',overflow: TextOverflow.ellipsis),
                        Text('User Name  :  ${this._userInfo.userName}',overflow: TextOverflow.ellipsis)
                      ])),
                ])
              ],
            ))
      ,  const SizedBox(height: 60.0)
      ]),
    );
  }
}
