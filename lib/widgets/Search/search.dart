import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/internet.dart';
import 'package:flutter_tab/viewModels/userInfo.dart';
import 'package:flutter_tab/widgets/Search/searchResult.dart';
import 'package:flutter_tab/widgets/Search/searchResultCard.dart';

class SearchWidget extends StatefulWidget {
  @override
  SearchWidgetState createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  final formKey = GlobalKey<FormState>();
  String _searchTerm = "";
  int _skip = 0;
  List<UserInfo> _data;

  @override
  void initState() {
    super.initState();
    _data = new List<UserInfo>();
    //_data.add(new UserInfo("Welcome","Welcome to this app","No Image"));
  }

  Future _search() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      final res = await Internet.get(
          'http://127.0.0.1:58296/Login/Search?searchTerm=$_searchTerm&skip=$_skip');
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
            _data = new List<UserInfo>();
            for (var item in res.data) {
              _data.add(new UserInfo(
                  item["userId"], item["name"], item["userImage"]));
            }
          });
        }
      }
    }
  }

  //@override
  Future _OpenMessage(UserInfo user) async {
    await Navigator.of(context).push(new MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return new SearchResultWidget(user);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
             
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Container(
                 
                    padding: const EdgeInsets.all(8.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Flexible(
                              child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter value';
                              }
                            },
                            onSaved: (val) => _searchTerm = val,
                            decoration: const InputDecoration(
                              hintText: 'Search by UserId or user Name',
                            ),
                          )),
                          FlatButton(
                            onPressed: _search,
                            child: Icon(Icons.search),
                          ),
                        ])),
              ],
            ),
          )),
          // Container(decoration: BoxDecoration(border: Border(bottom:  new BorderSide(width: 2.0, color: Colors.lightBlue.shade900)))),
          Expanded(
            
            flex: 1,
            // child: Text(_data.length.toString()),
            child:
            Container( 
            child:   ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, int index) {
                return RaisedButton(
                  onPressed: () {
                    _OpenMessage(_data[index]);
                  },
                  child: SearchResultCardWidget(_data[index]),
                );
              },
            )),
          )
        ],
      ),
    );
  }
}
