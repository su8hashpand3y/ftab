import 'package:flutter/material.dart';
import 'package:flutter_tab/viewModels/messageCard.dart';

class MessageCardWidget extends StatefulWidget {
  @override
  MessageCardWidgetState createState() =>
      MessageCardWidgetState(this.__message);
  MessageCard __message;
  MessageCardWidget(MessageCard _message) {
    this.__message = _message;
  }
}

class MessageCardWidgetState extends State<MessageCardWidget> {
  MessageCard __message;
  MessageCardWidgetState(MessageCard _message) {
    this.__message = _message;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        padding: EdgeInsets.all(5.0),
        child:
         Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(this.__message.userName ?? ""),
              Text(this.__message.lastMessage ?? "")
            ]));
  }
}
