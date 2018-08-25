import 'package:flutter/material.dart';
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
  UserInfo _userInfo;
  SearchResultWidgetState(UserInfo userInfo) {
    this._userInfo = userInfo;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.black,
        title: new Text(this._userInfo.userName),
      ),
      body: ListView(children: <Widget>[
        new Padding(
            padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 40.0),
                
                Column(children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: <Widget>[
                        Text('User Id    :  ${this._userInfo.userId}',
                            overflow: TextOverflow.ellipsis),
                        Text('User Name  :  ${this._userInfo.userName}',
                            overflow: TextOverflow.ellipsis)
                      ])),
                ]),
                this._userInfo.userImage == null
                    ? Center(child: Text('No Image'))
                    : new Image.network(this._userInfo.userImage,
                        fit: BoxFit.fill),
              ],
            )),
        const SizedBox(height: 60.0)
      ]),
    );
  }
}
