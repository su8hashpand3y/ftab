import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/internet.dart';
import 'package:flutter_tab/viewModels/messageCard.dart';
import 'package:flutter_tab/widgets/Reply/sendReply.dart';
import 'package:flutter_tab/widgets/messageCardWidget.dart';

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
    Timer.periodic(Duration(seconds: 3) ,(t){  if(this.mounted){this._loadData();}});
    Timer.periodic(Duration(seconds: 3) ,(t){  if(this.mounted){this.refeshMessageCount();}});
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

  _markReplyAsFav(MessageCard messageCard) async {
    setState(() {
      messageCard.isFav = !messageCard.isFav;
    });
    final res = await Internet.get(
        '${Internet.RootApi}/Message/MarkReplyAsFav?messageGroupUniqueId=${messageCard.messageGroupUniqueGuid}');
    if (res.status != 'good') {
      setState(() {
        messageCard.isFav = !messageCard.isFav;
        this.filteredData.sort((x,y)=> x.isFav ? -1:1 );
      });
    }
  }

  Future _loadData() async {
    final res = await Internet.get(
        '${Internet.RootApi}/Message/GetReplyMessageCard?lastId=${this._data.length > 0 && this._data.last != null ? this._data.last.lastId : 0}');
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

         if(res.data.length >0){
          this.filteredData = this._data;
          this.filteredData.sort((x,y)  {
                 if(x.isFav)
                   return -1;
                 if(x.unreadCount > y.unreadCount)
                   return -1;
                return 1;
          });
         }
        });
      }
    }
  }

 
 static Future sendMessage(MessageCard message,context) async {
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

  final formKey = GlobalKey<FormState>();

// String _searchTerm;
//   Future _search() async {
//     final form = formKey.currentState;
//     if (form.validate()) {
//       form.save();
//      this.filteredData = this._data.where((x)=> x.userName.contains(_searchTerm));
//     }
//     }
 
  @override
  Widget build(BuildContext context) {
    localContext = context;
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
                    child:
                    Padding( padding: EdgeInsets.only(top:  25.0),
                    child:   Row(children: <Widget>[
                      Expanded( 
                        child: 
                      MessageCardWidget(_data[index])
                      ),
                      Container(
                        width: 50.0,
                        child: 
                      Column( children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          this._markReplyAsFav(_data[index]);
                        },
                        child: _data[index].isFav
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                      ),
                        _data[index].unreadCount >0 ?
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
