import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/internet.dart';
import 'package:flutter_tab/Helper/storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

class LoginWidget extends StatefulWidget {
  @override
  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  final formKey = GlobalKey<FormState>();
  String _userUniqueId = "";
  String _password = "";

  void _regsiter() {
    Navigator.of(context).pushNamed('/register');
  }

  void _forget() {
    Navigator.of(context).pushNamed('/forget');
  }

  Future _submit() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      final res = await Internet.post('${Internet.RootApi}/Login/Login', {
        'userUniqueId': _userUniqueId,
        'password': _password,
      }).catchError((err) {
        print(err);
      });

      if (res.status == 'bad') {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Alert'),
                  content: Text('${res.message}'),
                ));
      }
      if (res.status == 'good') {
        Storage.setString('token', res.message);
        Navigator.of(context).pushReplacementNamed('/main');
      }
    }
  }

  checkIfTokenPresent() async {

  try
  {
     _firebaseMessaging.requestNotificationPermissions();
     _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      } );
     final deviceId = await _firebaseMessaging.getToken();
     await Storage.setString("deviceId", deviceId);
  }
  catch(e){
  }
    // await Storage.logout();
    String token = await Storage.getString('token');
    if (token != null) {
      await Internet
          .get('${Internet.RootApi}/Login/CheckAuthorization')
          .then((r) async {
        if (r.status == "good") {
          Navigator.of(context).pushReplacementNamed('/main');
        }
        if (r.status == "bad") {
          await Internet
              .get("${Internet.RootApi}/Login/IsUpdateMandatory")
              .then((r) {
            if (r.status == "good") {
              AlertDialog(
                title: Text('Alert'),
                content: Text('You Need to Update App'),
              );
            }
          });
        }
      }).catchError((e) {
        print("Authorization Error $e");
      });
    }
  }

  @override
  initState() {
    super.initState();
   

    checkIfTokenPresent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.blueGrey.withAlpha(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.person_pin)),
                                Flexible(
                                    child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter value';
                                    }
                                  },
                                  onSaved: (val) => _userUniqueId = val,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your User Id',
                                    labelText: 'User Id',
                                  ),
                                ))
                              ])),
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.vpn_key)),
                                Flexible(
                                    child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter value';
                                    }
                                  },
                                  obscureText: true,
                                  onSaved: (val) => _password = val,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your password',
                                    labelText: 'Password',
                                  ),
                                ))
                              ])),
                      Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: RaisedButton(
                            color: Colors.green.withOpacity(0.3),
                            onPressed: _submit,
                            child: Text('Login'),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: FlatButton(
                            onPressed: _regsiter,
                            child: Text('Create New Account'),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FlatButton(
                            onPressed: _forget,
                            child: Text('Reset Password'),
                          )),
                    ],
                  ),
                )
              ],
            )));
  }
}
