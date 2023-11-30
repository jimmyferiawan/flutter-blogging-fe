import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> setJwtToken(String jwtToken) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("jwt", jwtToken);
}

Future<String> getJwtToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt") ?? "";
}

Future<void> removeJwtToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("jwt");   
}

Future<void> setUsername(String username) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", username);
}

Future<String> getUsername() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString("username") ?? "";
}

Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    prefs.remove("jwt");
}