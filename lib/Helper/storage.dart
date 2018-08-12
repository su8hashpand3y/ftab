import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static getInt(String key) async {
    var store = await SharedPreferences.getInstance();
    return store.getInt(key);
  }

  static setInt(String key, int value) async {
    var store = await SharedPreferences.getInstance();
    return store.setInt(key, value);
  }

  static getBool(String key) async {
    var store = await SharedPreferences.getInstance();
    return store.getBool(key);
  }

  static setBool(String key, bool value) async {
    var store = await SharedPreferences.getInstance();
    return store.setBool(key, value);
  }

  static getString(String key) async {
    var store = await SharedPreferences.getInstance();
    return store.getString(key);
  }

  static setString(String key, String value) async {
    var store = await SharedPreferences.getInstance();
    return store.setString(key, value);
  }

  static removeToken() async {
    var store = await SharedPreferences.getInstance();
    return store.remove('token');
  }
}
