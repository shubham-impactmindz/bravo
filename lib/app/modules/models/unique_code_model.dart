class UniqueCodeResponse {
  final bool isSuccess;
  final String message;
  final String token;
  final UserModel? userInfo;

  UniqueCodeResponse({
    required this.isSuccess,
    required this.message,
    required this.token,
    this.userInfo,
  });

  factory UniqueCodeResponse.fromJson(Map<String, dynamic> json) {
    return UniqueCodeResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      userInfo: json['user_info'] != null ? UserModel.fromJson(json['user_info']) : null,
    );
  }
}

class UserModel {
  final String userId;
  final String userName;
  final String userEmail;
  final String role;
  final String deviceToken;
  final int iat;
  final int exp;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.role,
    required this.deviceToken,
    required this.iat,
    required this.exp,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userEmail: json['user_email'] ?? '',
      role: json['role'] ?? '',
      deviceToken: json['device_token'] ?? '',
      iat: json['iat'] ?? 0,
      exp: json['exp'] ?? 0,
    );
  }
}
