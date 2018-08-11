import 'package:flutter/material.dart';
import 'package:flutter_tab/viewModels/userInfo.dart';

class SearchResultCardWidget extends StatefulWidget {
  @override
  SearchResultCardWidgetState createState() => SearchResultCardWidgetState(this._userInfo);
  UserInfo _userInfo;
  SearchResultCardWidget(UserInfo userInfo)
  {
    this._userInfo = userInfo;
  }
}

class SearchResultCardWidgetState extends State<SearchResultCardWidget> {
 UserInfo _userInfo;
  SearchResultCardWidgetState(UserInfo userInfo)
  {
    this._userInfo = userInfo;
  }

@override
  Widget build(BuildContext context) {
    return new Row(
     children: <Widget>[
                        this._userInfo.userImage == null
                          ? new Icon(Icons.image)
                          : new Image.network(this._userInfo.userImage, height: 50.0, fit:BoxFit.fill),
                          Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[ 
                            Text(this._userInfo.userId ?? ""),
              Text(this._userInfo.userName ?? "")])
             
     ],
    );
  }

}
