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