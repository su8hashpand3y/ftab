import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_tab/Helper/storage.dart';
import 'package:flutter_tab/viewModels/serviceResponse.dart';
import 'package:http/http.dart' as http;

class Internet {
 static Future<ServerResponse> get(String url) async {
    final tokenValue = await Storage.getString('token');
    final token = 'Bearer $tokenValue';
    print('token is $token');
    final response = await http.get(url, headers: {HttpHeaders.PROXY_AUTHORIZATION: token}).catchError((err) => print(err));
    if(response.statusCode == 200){
    return ServerResponse.fromJson(json.decode(response.body));
    }
    
    return new ServerResponse.fromHttpCode(response.statusCode.toString());
  }

static Future<ServerResponse>  post(String url,body) async {
    final tokenValue = await Storage.getString('token');
    final token = 'Bearer $tokenValue';
    final response = await http.post(url, body: body,headers: {HttpHeaders.AUTHORIZATION: token}).catchError((err) => print(err));
    if(response.statusCode == 200){
    return ServerResponse.fromJson(json.decode(response.body));
    }
    
    return new ServerResponse.fromHttpCode(response.statusCode.toString());
  }
}
