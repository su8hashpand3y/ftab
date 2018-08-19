import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/internet.dart';
import 'package:flutter_tab/Helper/storage.dart';
import 'package:flutter_tab/viewModels/message.dart';
import 'package:flutter_tab/viewModels/messageCard.dart';
import 'package:flutter_tab/viewModels/serviceResponse.dart';
import 'package:intl/intl.dart';

class SendReplyWidget extends StatefulWidget {
  MessageCard _messageCard;
  SendReplyWidget(MessageCard _messageCard) {
    this._messageCard = _messageCard;
  }
  @override
  SendReplyWidgetState createState() => SendReplyWidgetState(this._messageCard);
}

class SendReplyWidgetState extends State<SendReplyWidget> {
  final formKey = GlobalKey<FormState>();
  List<Message> _data = new List<Message>();
  MessageCard _messageCard;
  String _message = "";
    final formatDay = new DateFormat.MMMd();
   final formatTime = new DateFormat.jm();
  SendReplyWidgetState(MessageCard _messageCard) {
    print('Constructor ${_messageCard.userName}');

    this._messageCard = _messageCard;
  }

  @override
  void initState() {
    super.initState();
    _data = new List<Message>();
    this.checkLocalStorae();

    this._loadData();
    Timer.periodic(Duration(seconds: 3), (t) {
      if (this.mounted) {
        this._loadData();
      }
    });
  }

  checkLocalStorae()async {
 // check local storage for messages if any
              final localData = await Storage.getString('RE:${_messageCard.messageGroupUniqueGuid}');
              if(localData !=  null){
                final jsonLocal = json.decode(localData);
                for(int i=0;i< jsonLocal.length;i++ ){
                     _data.add( Message(jsonLocal[i]["id"], jsonLocal[i]["dateTime"], jsonLocal[i]["isMyMessage"],
                      jsonLocal[i]["message"], jsonLocal[i]["lastId"]));
                }
                setState(() {
                      });
              }
                
  }

  Future _loadData() async {
    final res = await Internet.get(
        '${Internet.RootApi}/Message/GetReplyMessage?messageGroupUniqueId=${this._messageCard.messageGroupUniqueGuid}&lastId=${this._data.length > 0 && this._data.first != null ? this._data.first.id : 0}');
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
          for (var item in res.data) {
            if(!_data.any((x)=>x.id == item["id"])){
            _data.insert(0,new Message(item["id"],item["dateTime"], item["isMyMessage"],
                item["message"], item["lastId"]));
          }
          }
        });
      }

         if( res.data.length >0)
       await Storage.setString('RE:${_messageCard.messageGroupUniqueGuid}',json.encode(this._data)); 

      
    }
  }

  Future _sendMessage() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      ServerResponse res = new ServerResponse();
      if(this._messageCard.messageGroupUniqueGuid != null)
      {
        res =  await Internet.post('${Internet.RootApi}/Message/ReplyMessage', {
        'messageGroupUniqueId': this._messageCard.messageGroupUniqueGuid,
        'message': this._message
      });
      }
      else{
        print('in else with ${this._messageCard.userName}');
       res =await Internet.post(
          '${Internet.RootApi}/Message/SendMessage',
          {'userUniqueId': this._messageCard.userName, 'message': this._message});
      }

      form.reset();
      if (res.status == 'good') {
      if(this._messageCard.messageGroupUniqueGuid == null){
        this._messageCard.messageGroupUniqueGuid = res.data;
      }

        this._loadData();
        setState(() {
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.green[700],
        title: new Text(this._messageCard.userName),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: _data.length,
            itemBuilder: (context, int index) {
              return _data[index].isMyMessage
                  ? Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(width: 50.0),
                            Flexible(
                                child: Container(
                                    color: Colors.cyan[100],
                                    child: Padding(
                                        padding: EdgeInsets.all(7.0),
                                        child:  Column( crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                          Text(_data[index].message) ,const SizedBox(height: 5.0), 
                                          Row(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[ Text(formatDay.format(_data[index].dateTime), textScaleFactor: 0.7 )]),
                                           Row(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[ Text(formatTime.format(_data[index].dateTime), textScaleFactor: 0.7 )])
                                          ]))))
                          ]))
                  : Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                                child: Container(
                                    color: Colors.cyan[100],
                                    child: Padding(
                                        padding: EdgeInsets.all(7.0),
                                        child: Column( crossAxisAlignment: CrossAxisAlignment.end,
                                           children: <Widget>[
                                          Text(_data[index].message) ,const SizedBox(height: 5.0), 
                                          Row( mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[  Text(formatDay.format(_data[index].dateTime), textScaleFactor: 0.7 )]),
                                            Row(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[ Text(formatTime.format(_data[index].dateTime), textScaleFactor: 0.7 )])
                                           ])))),
                            SizedBox(width: 50.0)
                          ]));
            },
          ),
        ),
        Container(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Row(mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                  Expanded(
                                      child: TextFormField(
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter value';
                                      }
                                    },
                                    onSaved: (val) => _message = val,
                                    decoration: const InputDecoration(
                                      hintText: 'Type and press send icon',
                                    ),
                                  )),
                                  GestureDetector(
                                    onTap: _sendMessage,
                                    child: Icon(Icons.send),
                                  ),
                                ])),
                      ],
                    ),
                  )
                ]))),
                  const SizedBox(height: 60.0)
      ]),
    );
  }
}
