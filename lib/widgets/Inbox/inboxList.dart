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
  List<MessageCard> filteredData;


  @override
  void initState() {
    super.initState();
    _data = new List<MessageCard>();
    filteredData = new List<MessageCard>();

    this._loadData();
    Timer.periodic(Duration(seconds: 3) ,(t){  if(this.mounted){this._loadData();}});
    Timer.periodic(Duration(seconds: 3) ,(t){  if(this.mounted){this.refeshMessageCount();}});

  }

  Future _loadData() async {
    final res = await Internet.get(
        '${Internet.RootApi}/Message/GetInboxMessagesCard?lastId=${this._data.length > 0 && this._data.last != null ? this._data.last.lastId : 0}');
        //    final res = await Internet.get(
        // '${Internet.RootApi}/Message/GetInboxMessagesCard');
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

          this.filteredData = this._data;

        });
      }
    }
  }

  refeshMessageCount() async {
    final res = await Internet
        .get('${Internet.RootApi}/Message/GetReplyMessageCount');
    if (res.status == 'good') {
      setState(() {
        if (this.mounted) {
          MessageCard m;
          for (var item in res.data) {
            if(this._data.contains((m) => m.messageGroupUniqueGuid == item["item1"]))
            {
            m = this._data.firstWhere((m) => m.messageGroupUniqueGuid == item["item1"]);
             m.unreadCount = item["item2"];
             m.lastMessage = item["item3"];
            }
          }
        }
      });
    }
  }

  _markInboxAsFav(MessageCard messageCard) async {
    setState(() {
      messageCard.isFav = !messageCard.isFav;
    });
    final res = await Internet.get(
        '${Internet.RootApi}/Message/MarkInboxAsFav?messageGroupUniqueId=${messageCard.messageGroupUniqueGuid}');
    if (res.status != 'good') {
      setState(() {
        messageCard.isFav = !messageCard.isFav;
        this.filteredData.sort((x,y)=> x.isFav ? -1:1 );
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

final formKey = GlobalKey<FormState>();

   String _searchTerm;
  Future _search() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
     this.filteredData = this._data.where((x)=> x.userName.contains(_searchTerm));
    }
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
              itemCount: filteredData.length,
              itemBuilder: (context, int index) {
                return GestureDetector(
                  
                    onTap: () {
                      this._openMessage(filteredData[index]);
                    },
                    child:
                    Padding( padding: EdgeInsets.only(top:  25.0),
                    child:   Row(children: <Widget>[
                      Expanded( 
                        child: 
                      MessageCardWidget(filteredData[index])
                      ),
                      Container(
                        width: 50.0,
                        child: 
                      Column( children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          this._markInboxAsFav(filteredData[index]);
                        },
                        child: filteredData[index].isFav
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                      ),
                        filteredData[index].unreadCount >0 ?
                      Text('${_data[index].unreadCount} New', style: TextStyle(color: Colors.red)) :
                      const SizedBox()
                     ]))
                    ,Divider(height: 2.0, color: Colors.black)
                    ])));
              },
            ),
          ),
          const SizedBox(height: 60.0)
        ]));
  }
}
