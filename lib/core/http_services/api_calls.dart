import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/helpers/error_mapper.dart';
import 'package:flutter_application_1/core/helpers/persistence_storage.dart';
import 'package:flutter_application_1/core/http_services/path.dart';
import 'package:flutter_application_1/dto/auth_dto.dart';
import 'package:http/http.dart' as http;

Future<SigninResp> login(SigninReq bodyReq) async {
    String endpoint = "$BASE_URL/$LOGIN";
    Map<String, String> reqHeaders = {
        'Content-Type': 'application/json',
    };
    
    httpLogging("Request - POST $endpoint", {"header": reqHeaders, "body": bodyReq.toJson()}.toString());
    final response = await http.post(
        Uri.parse(endpoint),
        headers: reqHeaders,
        body: jsonEncode(bodyReq.toJson()),
    );
    httpLogging("Response - Post $endpoint", {"status": response.statusCode, "body": response.body}.toString());

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
    String endpoint = "$BASE_URL/$SIGNUP";
    Map<String, String> reqHeaders = {
        'Content-Type': 'application/json',
    };

    httpLogging("Request - POST $endpoint ", {"header": reqHeaders, "body": bodyReq.toJson().toString()}.toString());
    final response = await http.post(
        Uri.parse(endpoint),
        headers: reqHeaders,
        body: jsonEncode(bodyReq.toJson()),
    );
    httpLogging("Response - POST $endpoint" , {"status": response.statusCode, "body": response.body}.toString());
    
    return {"status": response.statusCode, "body": response.body};
}

Future<UserDataResp> getUserData(String jwt, String username) async {
    String endpoint = "$BASE_URL/$userData/$username";
    UserDataResp userDataResp;
    Map<String, String> reqHeaders = {
        "Authorization": "Bearer $jwt"
    };

    httpLogging("Request - GET $endpoint", {"header": reqHeaders, "body": null}.toString());
    final response = await http.get(
        Uri.parse(endpoint),
        headers: reqHeaders
    );
    httpLogging("Response - GET $endpoint", {"status": response.statusCode, "body": response.body}.toString());
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
    
    return userDataResp;
}

Future<UserData> updateUserData(String? username, String? token, UserData? data) async{
    String endpoint = "$BASE_URL/$PROFILE/$username";
    Map<String, String> reqHeaders = {
        "Authorization": "Bearer $token",
        'Content-Type': 'application/json',
    };
    http.Response? response;

    try {
        httpLogging("Request - PUT $endpoint", {"header": reqHeaders,"body": data!.toJson()}.toString());
        response = await http.put(
            Uri.parse(endpoint),
            headers: reqHeaders,
            body: jsonEncode(data.toJson())
        );
        httpLogging("Response - PUT $endpoint", response.body.toString());

        Map<String, dynamic> respBody = jsonDecode(response.body);
        Map<String, dynamic> rsp = respBody['data'];
        if(response.statusCode == 200) {
            data = UserData.fromJson(rsp);
        }
        // debugPrint("test : ${respBody['data']['username']} ${respBody['data'].runtimeType}");
    } catch (e) {
        debugPrint("Error updateUserData : ${e.toString()}");
        debugPrintStack();
    }

    return data!;
}

void httpLogging(String name, String value) {
    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
    debugPrint("${tsdate.year.toString()}-${tsdate.month.toString().length == 1 ? "0" : ""}${tsdate.month.toString()}-${tsdate.day.toString().length == 1 ? "0" : ""}${tsdate.day.toString()} ${tsdate.hour.toString().length == 1 ? "0" : ""}${tsdate.hour.toString()}:${tsdate.minute.toString().length == 1 ? "0" : ""}${tsdate.minute.toString()}:${tsdate.second.toString().length == 1 ? "0" : ""}${tsdate.second.toString()}.${tsdate.millisecond.toString()} $name : $value");
    // debugPrint();
}

Future<UserData?> initUserAccount() async{
    String jwt = await getJwtToken();
    String username = await getUsername();
    bool isSession = jwt != "" && username != "";
    UserDataResp userDataResp ;
    UserData? userData;
    
    try {
        userDataResp = !isSession ? UserDataResp.emptyValue() : await getUserData(jwt, username);
        userData = userDataResp.error ? null : UserData.fromJson(userDataResp.data);
        if(userDataResp.error) {
            throw UnathorizedError(message: "Invalid login session");
        }
    } catch (e) {
        throw UnathorizedError(message: "Invalid login session");
    }

    return userData;
}