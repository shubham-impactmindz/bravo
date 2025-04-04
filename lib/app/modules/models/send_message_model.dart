// To parse this JSON data, do
//
//     final userChatsModel = userChatsModelFromJson(jsonString);

import 'dart:convert';

SendMessageModel sendMessageModelFromJson(String str) => SendMessageModel.fromJson(json.decode(str));

String sendMessageModelToJson(SendMessageModel data) => json.encode(data.toJson());

class SendMessageModel {
  bool? isSuccess;
  String? message;
  bool? isActive;
  int? messageId;

  SendMessageModel({
    this.isSuccess,
    this.message,
    this.isActive,
    this.messageId,
  });

  factory SendMessageModel.fromJson(Map<String, dynamic> json) => SendMessageModel(
    isSuccess: json["isSuccess"],
    message: json["message"],
    isActive: json["is_active"],
    messageId: json["message_id"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "is_active": isActive,
    "message_id": messageId,
  };
}
