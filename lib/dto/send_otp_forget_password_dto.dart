class SendOtpDTOResponse {
    final bool? error;
    final String? message;

    const SendOtpDTOResponse({required this.error, required this.message});

    factory SendOtpDTOResponse.fromJson(Map<String, dynamic> json) {
        return SendOtpDTOResponse(error: json['error']! as bool, message: json['message']! as String);
    }

    Map<String, dynamic> toJson() {
        return {
            "error": error!,
            "message": message!,
        };
    }

    @override
    String toString() {
        return "SendOtpDTOResponse(error=$error, message=$message)";
    }
}