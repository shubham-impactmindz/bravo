import 'package:bravo/app/modules/models/group_list_model.dart';

class Event {
  final String? eventId;
  final String? title;
  final String? description;
  final DateTime? date;
  DateTime? startTime;
  DateTime? endTime;
  String? location;
  Category? category;
  String? cost;
  List<String>? eventDoc; // Ensure it's a List<String>
  String? eventNotes;
  String? createdBy;
  String? isCancelled;
  dynamic cancellationReason;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? deviceTime;
  String? createdByName;
  List<Participant>? participants;
  List<GroupList>? groups;
  List<User>? users;

  Event({
    this.eventId,
    this.title,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.location,
    this.category,
    this.cost,
    this.eventDoc, // Ensure it's required
    this.eventNotes,
    this.createdBy,
    this.isCancelled,
    this.cancellationReason,
    this.createdAt,
    this.updatedAt,
    this.deviceTime,
    this.createdByName,
    this.participants,
    this.groups,
    this.users,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['event_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.tryParse(json['start_time'] ?? '') ?? DateTime.now(),
      startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
      endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
      location: json["location"],
      category: json["category"] == null ? null : Category.fromJson(json["category"]),
      cost: json["cost"],
      eventDoc: json["event_doc"] is List
          ? List<String>.from(json["event_doc"])
          : json["event_doc"] != null
          ? [json["event_doc"].toString()]
          : [],
      eventNotes: json["event_notes"],
      createdBy: json["created_by"],
      isCancelled: json["is_cancelled"],
      cancellationReason: json["cancellation_reason"],
      createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      deviceTime: json["device_time"],
      createdByName: json["created_by_name"],
      participants: json["participants"] == null ? [] : List<Participant>.from(json["participants"]!.map((x) => Participant.fromJson(x))),
      groups: json["groups"] == null ? [] : List<GroupList>.from(json["groups"]!.map((x) => GroupList.fromJson(x))),
      users: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
    );
  }
}

class Participant {
  final String eventId;
  final String userId;
  final String status;
  final String rsvpDate;

  Participant({
    required this.eventId,
    required this.userId,
    required this.status,
    required this.rsvpDate,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      eventId: json['event_id'] ?? '',
      userId: json['user_id'] ?? '',
      status: json['status'] ?? '',
      rsvpDate: json['rsvp_date'] ?? '',
    );
  }
}

class User {
  final String userId;
  final String name;

  User({
    required this.userId,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Category {
  final String catId;
  final String catName;

  Category({
    required this.catId,
    required this.catName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      catId: json['category_id'] ?? '',
      catName: json['category_name'] ?? '',
    );
  }
}

// class GroupList {
//   final String groupId;
//   final String? name;
//
//   GroupList({required this.groupId, this.name});
//
//   factory GroupList.fromJson(Map<String, dynamic> json) {
//     return GroupList(
//       groupId: json['group_id'] ?? '',
//       name: json['name'] ?? '',
//     );
//   }
// }