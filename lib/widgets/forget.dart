import 'package:flutter/material.dart';

class ForgetWidget extends StatefulWidget {
  @override
  ForgetWidgetState createState() => ForgetWidgetState();
}

class ForgetWidgetState extends State<ForgetWidget> {
  final formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  String _favNumber = "";
  String _favColor = "";
  String _favMonth = "";

  _backToLogin() {
    Navigator.pop(context);
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      Navigator.of(context).pushNamed('/main');
      form.save();
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Alert'),
            content: Text('Email: $_email, password: $_password'),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
    new 
        Scaffold(
        body: 
        ListView(children: <Widget>[
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
                            onSaved: (val) => _email = val,
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
                              hintText: 'Enter new password',
                              labelText: 'Password',
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
                                  'Fill These answer to reset your password.')),
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
                      child: Text('Reset Password And Login'),
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
    )]));
  }
}
