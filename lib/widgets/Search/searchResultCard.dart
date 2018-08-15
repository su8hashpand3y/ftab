import 'package:flutter/material.dart';
import 'package:flutter_tab/viewModels/userInfo.dart';

class SearchResultCardWidget extends StatefulWidget {
  @override
  SearchResultCardWidgetState createState() =>
      SearchResultCardWidgetState(this._userInfo);
  UserInfo _userInfo;
  SearchResultCardWidget(UserInfo userInfo) {
    this._userInfo = userInfo;
  }
}

class SearchResultCardWidgetState extends State<SearchResultCardWidget> {
  UserInfo _userInfo;
  SearchResultCardWidgetState(UserInfo userInfo) {
    this._userInfo = userInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       //decoration: BoxDecoration( border: Border.all(color: Colors.lightBlue.shade900, width: 2.0)),
       decoration: BoxDecoration(color: Colors.cyan[100], border: Border.all(color: Colors.lightBlue.shade900, width: 1.0)),
      child: 
    Padding(padding: EdgeInsets.all(3.0),
    child:  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        this._userInfo.userImage == null
            ? new Icon(Icons.image)
            : new Image.network(this._userInfo.userImage,
                height: 50.0, fit: BoxFit.fill),
       Padding(padding:EdgeInsets.only(left: 10.0) ,
       child:  Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text('UserId: ${this._userInfo.userId}', overflow: TextOverflow.ellipsis),
          Text('UserName: ${this._userInfo.userName}' , overflow: TextOverflow.ellipsis),
          Divider(height: 2.0, color: Colors.black)
        ]))
      ],
    )));
  }
}
