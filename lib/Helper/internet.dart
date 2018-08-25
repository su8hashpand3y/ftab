import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_tab/Helper/storage.dart';
import 'package:flutter_tab/viewModels/serviceResponse.dart';
import 'package:http/http.dart' as http;

class Internet {
  static const  RootApi= "http://localhost:58296";
  // static const  RootApi= "http://rajdoot.azurewebsites.net";

   static bool noInternet = false;
  
  static Future<ServerResponse> get(String url) async {
    if(noInternet){
      return ServerResponse.noInternet();
    }
    final tokenValue = await Storage.getString('token');
    final token = 'Bearer $tokenValue';
    final response = await http.get(url,
        headers: {HttpHeaders.AUTHORIZATION: token}).catchError((err) {
      Future<ServerResponse>.value(ServerResponse.fromError());
    });

   

    if (response == null) {
     Internet.noInternet =! Internet.noInternet;

     new Timer(Duration(seconds: 5), (){
     Internet.noInternet =! Internet.noInternet;
      });
      return ServerResponse.fromError();
    }

    if(response.statusCode == 401 || response.statusCode == 403){
      return ServerResponse.authError();
    }

    if (response.statusCode == 200) {
      return ServerResponse.fromJson(json.decode(response.body));
    }

    return ServerResponse.fromHttpCode(response.statusCode.toString());
  }

  static Future<ServerResponse> post(String url, body) async {
     if(noInternet){
      return ServerResponse.noInternet();
    }
    final tokenValue = await Storage.getString('token');
    final token = 'Bearer $tokenValue';
    final response = await http.post(url,
        body: body,
        headers: {HttpHeaders.AUTHORIZATION: token}).catchError((err) {
      Future<ServerResponse>.value(ServerResponse.fromError());
    });

    if (response == null) {
     Internet.noInternet =! Internet.noInternet;

       new Timer(Duration(seconds: 5), (){
     Internet.noInternet =! Internet.noInternet;
      });
      return ServerResponse.fromError();
    }

    if(response.statusCode == 401 || response.statusCode == 403){
      return ServerResponse.authError();
    }

    if (response.statusCode == 200) {
      return ServerResponse.fromJson(json.decode(response.body));
    }

    return ServerResponse.fromHttpCode(response.statusCode.toString());
  }
}
