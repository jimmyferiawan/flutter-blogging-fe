class SubmitForgetPasswordDTORequest {
    final String? email;
    final String? token;
    final String? newPassword;

    const SubmitForgetPasswordDTORequest({required this.email, required this.token, required this.newPassword});

    factory SubmitForgetPasswordDTORequest.fromJson(Map<String, dynamic> json) {
        return SubmitForgetPasswordDTORequest(email: json['email']! as String, token: json['token']! as String, newPassword: json['newPassword']! as String);
    }

    Map<String, dynamic> toJson() {
        return {
            "email": email!,
            "token": token!,
            "newPassword": newPassword!,
        };
    }

    @override
    String toString() {
        return "SubmitForgetPasswordDTORequest(email=$email, token=$token, newPassword=$newPassword)";
    }
}

class SubmitForgetPasswordDTOResponse {
    final bool? error;
    final String? message;

    const SubmitForgetPasswordDTOResponse({required this.error, required this.message});

    factory SubmitForgetPasswordDTOResponse.fromJson(Map<String, dynamic> json) {
        return SubmitForgetPasswordDTOResponse(error: json['error']! as bool, message: json['message']! as String);
    }

    Map<String, dynamic> tojson() {
        return {
            "error": error,
            "message": message,
        };
    }

    @override
    String toString() {
        return "SubmitForgetPasswordDTOResponse(error=$error, message=$message)";
    }

    factory SubmitForgetPasswordDTOResponse.emptyValue() {
        return const SubmitForgetPasswordDTOResponse(error: true, message: "");
    }
}