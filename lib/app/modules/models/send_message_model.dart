// To parse this JSON data, do
//
//     final userChatsModel = userChatsModelFromJson(jsonString);

import 'dart:convert';

SendMessageModel sendMessageModelFromJson(String str) => SendMessageModel.fromJson(json.decode(str));

String sendMessageModelToJson(SendMessageModel data) => json.encode(data.toJson());

class SendMessageModel {
  bool? isSuccess;
  int? messageId;

  SendMessageModel({
    this.isSuccess,
    this.messageId,
  });

  factory SendMessageModel.fromJson(Map<String, dynamic> json) => SendMessageModel(
    isSuccess: json["isSuccess"],
    messageId: json["message_id"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message_id": messageId,
  };
}
