class SigninReq {
    final String username;
    final String password;

    const SigninReq({
        required this.username,
        required this.password,
    });

    factory SigninReq.fromJson(Map<String, dynamic> json) {
        return SigninReq(
            username: json['username'] as String,
            password: json['password'] as String,
        );
    }

    Map<String, dynamic> toJson() {
        return {
            "username": username,
            "password": password,
        };
    }
}

class SigninResp {
    final bool error;
    final String message;
    final String accessToken;

    const SigninResp({
        required this.error,
        required this.message,
        required this.accessToken,
    });

    factory SigninResp.fromJson(Map<String, dynamic> json) {
        return SigninResp(
            error: json['error'] as bool,
            message: json['message'] as String,
            accessToken: json['accessToken'] as String
        );
    }

    Map<String, dynamic> toJson() {
        return {
            "error": error,
            "message": message,
            "accessToken": accessToken
        };
    }
}

class SignupReq {
    final String username;
    final String firstName;
    final String mobile;
    final String email;
    final String password;

    const SignupReq({
        required this.username,
        required this.firstName,
        required this.mobile,
        required this.email,
        required this.password,
    });

    factory SignupReq.fromJson(Map<String, dynamic> json) {
        return SignupReq(
            username: json["username"] as String,
            firstName: json["firstName"] as String,
            mobile: json["mobile"] as String,
            email: json["email"] as String,
            password: json["password"] as String,
        );
    }

    Map<String, String> toJson() {
        return {
            "username": username,
            "firstName": firstName,
            "mobile": mobile,
            "email": email,
            "password": password,
        };
    }
}

class SignupResp {
    final bool error;
    final String message;
    // final Map<String, dynamic> data;
    final Map<String,dynamic> data;

    const SignupResp({
        required this.error,
        required this.message,
        required this.data,
    });

    factory SignupResp.fromJson(Map<String, dynamic> json) {
        return SignupResp(
            error: json['error'] as bool, 
            message: json['message'] as String, 
            data: {
                'username': json['data']['username'] as String,
                'firstName': json['data']['firstName'] as String,
                // 'middleName': json['data']['middleName'] as String,
                // 'lastName': json['data']['lastName'] as String,
                'email': json['data']['email'] as String,
                'mobile': json['data']['mobile'] as String,
            }
        );
    }

}

class SignupRespData {
    final String username;
    final String firstName;
    // final String middleName;
    // final String lastName;
    final String email;
    final String mobile;

    const SignupRespData({
        required this.username,
        required this.firstName,
        // required this.middleName,
        // required this.lastName,
        required this.email,
        required this.mobile,
    });

    factory SignupRespData.fromJson(Map<String, dynamic> json) {
        return SignupRespData(
            username: json['username'] as String,
            firstName: json[''] as String,
            // middleName: json['middleName'] as String,
            // lastName: json['lastName'] as String,
            email: json['email'] as String,
            mobile: json['mobile'] as String
        );
    }

    Map<String, dynamic> toJson() {
        return {
            "username": username,
            "firstName": firstName,
            // "middleName": middleName,
            // "lastName": lastName,
            "email": email,
            "mobile": mobile
        };
    }

}

class UserDataResp {
    final bool error;
    final String message;
    final Map<String, dynamic> data;

    const UserDataResp({
        required this.error,
        required this.message,
        required this.data,
    });

    factory UserDataResp.fromJson(Map<String, dynamic> json) {
        return UserDataResp(
            error: json['error'] as bool, 
            message: json['message'] as String, 
            data: {
                "username": json['data']['username'] as String,
                "email": json['data']['email'] as String,
                "mobile": json['data']['mobile'] as String,
                "firstName": json['data']['firstName'] as String,
                "intro": json['data']['intro'] ?? "",
                "profile": json['data']['profile'] ?? "",
                "birthdate": json['data']['birthdate'] ?? ""
            }
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'error': error,
            'message': message,
            'data': {
                "username": data['username'] as String,
                "email": data['email'] as String,
                "mobile": data['mobile'] as String,
                "firstName": data['firstName'] as String,
                "intro": data['intro'] ?? "",
                "profile": data['profile'] ?? "",
                "birthdate": data['birthdate'] ?? ""
            }
        };
    }

    factory UserDataResp.emptyValue() {
        return const UserDataResp(
            error: true, 
            message: "", 
            data: {
                "username": "",
                "email": "",
                "mobile": "",
                "firstName": "",
                "intro": "",
                "profile": "",
                "birthdate": ""
            }
        );
    }
}

class UserData {
    final String username;
    final String email;
    final String mobile;
    final String firstName;
    final String? intro;
    final String? profile;
    final String? birthdate;

    const UserData({
        required this.username,
        required this.email,
        required this.mobile,
        required this.firstName,
        required this.intro,
        required this.profile,
        required this.birthdate,
    });

    factory UserData.fromJson(Map<String, dynamic> json) {
        return UserData(
            username: json['username'] as String,
            email: json['email'] as String,
            mobile: json['mobile'] as String,
            firstName: json['firstName'] as String,
            intro: json['intro'] ?? "",
            profile: json['profile'] ?? "",
            birthdate: json['birthdate'] ?? "",
        );
    }

    Map<String, dynamic> toJson() {
        return {
            "username": username,
            "email": email,
            "mobile": mobile,
            "firstName": firstName,
            "intro": intro,
            "profile": profile,
            "birthdate": birthdate,
        };
    }

    factory UserData.emptyValue() {
        return const UserData(username: "", email: "", mobile: "", firstName: "", intro: "", profile: "", birthdate: "");
    }
    
    @override
    String toString() {
        return '{ "username": $username, "email": $email, "mobile": $mobile, "firstName": $firstName, "intro": $intro, "profile": $profile, "birthdate": $birthdate }';
    }
}