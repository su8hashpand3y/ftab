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
        decoration: BoxDecoration(border: Border(bottom: new BorderSide(width: 2.0, color: Colors.lightBlue.shade900))),
        padding: EdgeInsets.all(4.0),
        child:
         Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[Text('From :'),Text('${this.__message.userName}',style: TextStyle(fontWeight: FontWeight.bold)) ]),
              SizedBox( height:5.0),
              Text(this.__message.lastMessage, overflow: TextOverflow.ellipsis),
              SizedBox( height:10.0)
            ]));
  }
}
