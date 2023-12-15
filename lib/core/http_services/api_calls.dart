import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/helpers/error_mapper.dart';
import 'package:flutter_application_1/core/helpers/logging.dart';
import 'package:flutter_application_1/core/helpers/persistence_storage.dart';
import 'package:flutter_application_1/core/http_services/path.dart';
import 'package:flutter_application_1/dto/auth_dto.dart';
import 'package:flutter_application_1/dto/forget_password_dto.dart';
import 'package:flutter_application_1/dto/send_otp_forget_password_dto.dart';
import 'package:http/http.dart' as http;

Future<SigninResp> login(SigninReq bodyReq) async {
    String endpoint = "$baseURL/$loginPath";
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
    String endpoint = "$baseURL/$signUp";
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
    String endpoint = "$baseURL/$userDataPath/$username";
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
    String endpoint = "$baseURL/$profilePath/$username";
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

Future<UserData?> initUserAccount() async{
    String jwt = await getJwtToken();
    String username = await getUsername();
    bool isSession = jwt != "" && username != "";
    UserDataResp userDataResp ;
    UserData? userData;
    // await Future.delayed(const Duration(seconds: 5)); // TODO : remove this on build
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

Future<SendOtpDTOResponse> sendOtpMail(String? username) async{
    final String endpoint = "$baseURL/$forgetPasswordSendPath/$username";
    Map<String, String> reqHeaders = {
        'Content-Type': 'application/json',
    };
    // Map<String, dynamic> reqBody = bodyReq!.toJson();

    http.Response response;

    // await Future.delayed(const Duration(seconds: 3)); // TODO : remove this on build
    httpLogging("Request - GET $endpoint", {"header": reqHeaders, "body": null}.toString());
    response = await http.get(
        Uri.parse(endpoint),
        headers: reqHeaders,
        // body: jsonEncode(reqBody)
    );
    httpLogging("Response - GET ${response.statusCode}", {"status": response.statusCode, "body": response.body}.toString());
    Map<String, dynamic> jsonBody = jsonDecode(response.body);

    if(response.statusCode != 200) {
        String? exceptionMessage;

        if(response.statusCode == 404) {
            exceptionMessage = "Data tidak ditemukan";
        }
        if(response.statusCode == 500) {
            exceptionMessage = "Terjadi kesalahan, silahkan ulangi beberapa saat lagi";
        }

        throw UserNotFoundException(message: exceptionMessage!);
    }

    return SendOtpDTOResponse.fromJson(jsonBody);
}

Future<SubmitForgetPasswordDTOResponse> sendResetPassword(SubmitForgetPasswordDTORequest requestBody) async{
    String endpoint = "$baseURL/$forgetPasswordResetPath";
    Map<String, String> reqHeaders = {
        'Content-Type': 'application/json',
    };
    Map<String, dynamic> reqBody = requestBody.toJson();
    http.Response? response;

    httpLogging("Request - POST $endpoint", {"header": reqHeaders, "body": reqBody}.toString());
    // await Future.delayed(const Duration(seconds: 3)); // TODO : remove this on build
    response = await  http.post(
        Uri.parse(endpoint),
        headers: reqHeaders,
        body: jsonEncode(reqBody),
    );
    httpLogging("Response - POST $endpoint", {"status": response.statusCode, "header": response.headers, "body": response.body, }.toString());
    var resp = SubmitForgetPasswordDTOResponse.fromJson(jsonDecode(response.body));
    if(response.statusCode != 200) {
        if(response.statusCode == 404) {
            throw UserNotFoundException(message: "Pengguna tidak ditemukan");
        } else if(response.statusCode == 500) {
            throw UserNotFoundException(message: "Terjadi kesalahan, coba beberapa saat lagi");
        } else {
            throw UserNotFoundException(message: resp.message!);
        }
    }
    return resp;
}