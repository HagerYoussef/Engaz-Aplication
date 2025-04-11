class LoginResponse {
  final String message;
  final String userId;

  LoginResponse({required this.message, required this.userId});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      userId: json['userId'],
    );
  }
}
