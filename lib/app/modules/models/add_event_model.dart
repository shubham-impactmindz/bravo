// To parse this JSON data, do
//
//     final addEventModel = addEventModelFromJson(jsonString);

import 'dart:convert';

AddEventModel addEventModelFromJson(String str) => AddEventModel.fromJson(json.decode(str));

String addEventModelToJson(AddEventModel data) => json.encode(data.toJson());

class AddEventModel {
  bool? isSuccess;
  String? message;
  Data? data;

  AddEventModel({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory AddEventModel.fromJson(Map<String, dynamic> json) => AddEventModel(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  dynamic eventId;

  Data({
    this.eventId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    eventId: json["event_id"],
  );

  Map<String, dynamic> toJson() => {
    "event_id": eventId,
  };
}
