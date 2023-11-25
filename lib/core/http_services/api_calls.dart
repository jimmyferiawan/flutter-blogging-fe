import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/http_services/path.dart';
import 'package:flutter_application_1/dto/auth_dto.dart';
import 'package:http/http.dart' as http;

Future<SigninResp> login(SigninReq bodyReq) async {
    final response = await http.post(
        Uri.parse("$BASE_URL/$LOGIN"),
        headers: <String, String>{
            'Content-Type': 'application/json',
            },
        body: jsonEncode(<String, dynamic>{
            'username': bodyReq.username,
            'password': bodyReq.password,
        }),
    );

    String respBody = response.body;

    if (response.statusCode == 200) {
        return SigninResp.fromJson( jsonDecode(response.body) as Map<String, dynamic>);
    } else {
        SigninResp signinResp;
        try {
            Map<String, dynamic> resp = jsonDecode(respBody);
            signinResp = SigninResp(
                error: resp['error'] as bool,
                message: resp['message'] as String,
                accessToken: ""
            );
        } catch (e) {
            signinResp = const SigninResp(
                error: true,
                message: "Terjadi kesalahan, silahkan coba beberapa saat lagi",
                accessToken: ""
            );
        }
        // throw Exception(respBody);
        return signinResp;
    }
}

Future<Map<String, dynamic>> signUp(SignupReq bodyReq) async {
    // String resp;
    final response = await http.post(
        Uri.parse("$BASE_URL/$SIGNUP"),
        headers: <String, String>{
            'Content-Type': 'application/json',
            },
        body: jsonEncode(bodyReq.toJson()),
    );
    String respBody = response.body;
    
    return {"status": response.statusCode, "body": respBody};


}

Future<UserDataResp> getUserData(String jwt, String username) async {
    UserDataResp userDataResp;
    Map<String, String> reqHeaders = {
        "Authorization": "Bearer $jwt"
    };

    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
    debugPrint("${tsdate.year.toString()}-${tsdate.month.toString().length == 1 ? "0" : ""}${tsdate.month.toString()}-${tsdate.day.toString().length == 1 ? "0" : ""}${tsdate.day.toString()} ${tsdate.hour.toString().length == 1 ? "0" : ""}${tsdate.hour.toString()}:${tsdate.minute.toString().length == 1 ? "0" : ""}${tsdate.minute.toString()}:${tsdate.second.toString().length == 1 ? "0" : ""}${tsdate.second.toString()}.${tsdate.millisecond.toString()} GET $BASE_URL/$userData/$username Request : ");
    debugPrint("Header : ${reqHeaders.toString()}");
    debugPrint("Body : null");

    final response = await http.get(
        Uri.parse("$BASE_URL/$userData/$username"),
        headers: reqHeaders
    );
    tsdate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
    String respBody = response.body;

    if(response.statusCode == 200) {
        userDataResp =  UserDataResp.fromJson(jsonDecode(respBody) as Map<String, dynamic>);
    } else {
        try {
            Map<String, dynamic> resp = jsonDecode(respBody);
            userDataResp = UserDataResp(
                error: resp['error'] as bool, 
                message: resp['message'] as String, 
                data: {
                    "username": "",
                    "email": "",
                    "mobile": "",
                    "firstName": "",
                    "intro": "",
                    "profile": "",
                    "birthdate": "",
                }
            );
        } catch (err) {
            userDataResp = const UserDataResp(
                error: true, 
                message: "Terjadi kesalahan, silahkan coba beberapa saat lagi", 
                data: {
                    "username": "",
                    "email": "",
                    "mobile": "",
                    "firstName": "",
                    "intro": "",
                    "profile": "",
                    "birthdate": "",
                }
            );
        }
      
    }
    debugPrint("${tsdate.year.toString()}-${tsdate.month.toString().length == 1 ? "0" : ""}${tsdate.month.toString()}-${tsdate.day.toString().length == 1 ? "0" : ""}${tsdate.day.toString()} ${tsdate.hour.toString().length == 1 ? "0" : ""}${tsdate.hour.toString()}:${tsdate.minute.toString().length == 1 ? "0" : ""}${tsdate.minute.toString()}:${tsdate.second.toString().length == 1 ? "0" : ""}${tsdate.second.toString()}.${tsdate.millisecond.toString()} GET $BASE_URL/$userData/$username Response : ${userDataResp.toJson().toString()}");
    return userDataResp;

}
//TODO: signup