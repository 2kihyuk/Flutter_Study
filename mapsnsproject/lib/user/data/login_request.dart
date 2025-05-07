class LoginRequest {
  final String loginId;
  final String password;

  LoginRequest({required this.loginId, required this.password});

  Map<String, dynamic> toJson() => {'loginId': loginId, 'password': password};
}

class LoginResponse {
  final String tokenType;
  final String accessToken;
  final String refreshToken;

  LoginResponse({
    required this.tokenType,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      tokenType: json['tokenType'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
