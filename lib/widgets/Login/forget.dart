import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_tab/Helper/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tab/Helper/internet.dart';

class ForgetWidget extends StatefulWidget {
  @override
  ForgetWidgetState createState() => ForgetWidgetState();
}

class ForgetWidgetState extends State<ForgetWidget> {
  final formKey = GlobalKey<FormState>();
  String _userUniqueId = "";
  String _password = "";
  String _confirmPassword = "";
  String _favNumber = "";
  String _favColor = "";
  String _favMonth = "";

  _backToLogin() {
    Navigator.pop(context);
  }

  Future _submit() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_password != _confirmPassword) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Alert'),
                  content: Text('Password Do Not Match'),
                ));

        return;
      }

      final res = await Internet.post("http://127.0.0.1:58296/Login/Forget", {
        'userUniqueId': _userUniqueId,
        'password': _password,
        'favNumber': _favNumber,
        'favColor': _favColor,
        'favMonth': _favMonth,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
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
                                hintText: 'Enter your new password',
                                labelText: 'New Password',
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
                              onSaved: (val) => _confirmPassword = val,
                              decoration: const InputDecoration(
                                hintText: 'Confirm your password',
                                labelText: 'Confirm Password',
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
                                child: Text(
                                    'Answer these question')),
                          ])),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.question_answer)),
                            Flexible(
                                child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter value';
                                }
                              },
                              onSaved: (val) => _favColor = val,
                              decoration: const InputDecoration(
                                hintText: 'Enter your answer',
                                labelText: 'Your favourite Color',
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
                                child: Icon(Icons.question_answer)),
                            Flexible(
                                child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter value';
                                }
                              },
                              onSaved: (val) => _favNumber = val,
                              decoration: const InputDecoration(
                                hintText: 'Enter your Answer',
                                labelText: 'Your favourite number',
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
                                child: Icon(Icons.question_answer)),
                            Flexible(
                                child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter value';
                                }
                              },
                              onSaved: (val) => _favMonth = val,
                              decoration: const InputDecoration(
                                hintText: 'Enter your Answer',
                                labelText: 'Your favourite month',
                              ),
                            ))
                          ])),
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: RaisedButton(
                        onPressed: _submit,
                        child: Text('Register And Login'),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: FlatButton(
                        onPressed: _backToLogin,
                        child: Text('Already Have Account Login Here'),
                      )),
                ],
              ),
            )
          ],
        ),
      )
    ]));
  }
}
