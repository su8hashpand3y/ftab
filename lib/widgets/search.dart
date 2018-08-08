import 'package:flutter/material.dart';
import 'package:flutter_tab/viewModels/userInfo.dart';

class SearchWidget extends StatefulWidget {
  @override
  SearchWidgetState createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  final formKey = GlobalKey<FormState>();
  String _searchTerm = "";
  List<UserInfo> data = new List();

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Alert'),
            content: Text('Search term: $_searchTerm'),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding :true,
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Form(
            key: formKey,
            child: Row(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.search)),
                        ])),
                Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: RaisedButton(
                      onPressed: _submit,
                      child: Text('Search'),
                    )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, int index) {
                return Text(
                  data[index].toString(),
                );
              },
            ),
          )
        ],
      ),
    ));
  }
}
