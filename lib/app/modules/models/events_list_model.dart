// To parse this JSON data, do
//
//     final eventsListModel = eventsListModelFromJson(jsonString);

import 'dart:convert';

EventsListModel eventsListModelFromJson(String str) => EventsListModel.fromJson(json.decode(str));

String eventsListModelToJson(EventsListModel data) => json.encode(data.toJson());

class EventsListModel {
  bool? isSuccess;
  String? message;
  Map<String, List<EventList>>? data;

  EventsListModel({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory EventsListModel.fromJson(Map<String, dynamic> json) => EventsListModel(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: Map.from(json["data"]!).map((k, v) => MapEntry<String, List<EventList>>(k, List<EventList>.from(v.map((x) => EventList.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
  };
}

class EventList {
  String? eventId;
  String? title;
  String? description;
  DateTime? startTime;
  DateTime? endTime;
  String? location;
  String? category;
  String? cost;
  String? eventDoc;
  String? eventNotes;
  String? createdBy;
  String? groupId;
  String? userId;
  String? isCancelled;
  dynamic cancellationReason;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? createdByName;
  List<Participant>? participants;
  dynamic eventDocBase64;

  EventList({
    this.eventId,
    this.title,
    this.description,
    this.startTime,
    this.endTime,
    this.location,
    this.category,
    this.cost,
    this.eventDoc,
    this.eventNotes,
    this.createdBy,
    this.groupId,
    this.userId,
    this.isCancelled,
    this.cancellationReason,
    this.createdAt,
    this.updatedAt,
    this.createdByName,
    this.participants,
    this.eventDocBase64,
  });

  factory EventList.fromJson(Map<String, dynamic> json) => EventList(
    eventId: json["event_id"],
    title: json["title"],
    description: json["description"],
    startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
    endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
    location: json["location"],
    category: json["category"],
    cost: json["cost"],
    eventDoc: json["event_doc"],
    eventNotes: json["event_notes"],
    createdBy: json["created_by"],
    groupId: json["group_id"],
    userId: json["user_id"],
    isCancelled: json["is_cancelled"],
    cancellationReason: json["cancellation_reason"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdByName: json["created_by_name"],
    participants: json["userData"] == null ? [] : List<Participant>.from(json["userData"]!.map((x) => Participant.fromJson(x))),
    eventDocBase64: json["event_doc_base64"],
  );

  Map<String, dynamic> toJson() => {
    "event_id": eventId,
    "title": title,
    "description": description,
    "start_time": startTime?.toIso8601String(),
    "end_time": endTime?.toIso8601String(),
    "location": location,
    "category": category,
    "cost": cost,
    "event_doc": eventDoc,
    "event_notes": eventNotes,
    "created_by": createdBy,
    "group_id": groupId,
    "user_id": userId,
    "is_cancelled": isCancelled,
    "cancellation_reason": cancellationReason,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "created_by_name": createdByName,
    "userData": participants == null ? [] : List<dynamic>.from(participants!.map((x) => x.toJson())),
    "event_doc_base64": eventDocBase64,
  };
}


class Participant {
  String? eventId;
  String? userId;
  String? status;
  DateTime? rsvpDate;

  Participant({
    this.eventId,
    this.userId,
    this.status,
    this.rsvpDate,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
    eventId: json["event_id"],
    userId: json["user_id"],
    status: json["status"],
    rsvpDate: json["rsvp_date"] == null ? null : DateTime.parse(json["rsvp_date"]),
  );

  Map<String, dynamic> toJson() => {
    "event_id": eventId,
    "user_id": userId,
    "status": status,
    "rsvp_date": rsvpDate?.toIso8601String(),
  };
}
