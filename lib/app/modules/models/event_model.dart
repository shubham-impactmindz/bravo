import 'package:bravo/app/modules/models/group_list_model.dart';

class Event {
  final String? eventId;
  final String? title;
  final String? description;
  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? location;
  final Category? category;
  final double? cost;
  final String? createdBy;
  final List<String>? eventDoc; // Changed to List<String>?
  final String? eventNotes;
  final List<Participant>? participants;
  List<GroupList>? groups;
  final List<User>? users;

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
    this.createdBy,
    this.eventDoc,
    this.eventNotes,
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
      startTime: DateTime.tryParse(json['start_time'] ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['end_time'] ?? '') ?? DateTime.now(),
      location: json['location'] ?? '',
      category: Category.fromJson(json["category"]),
      cost: double.tryParse(json['cost'] ?? ''),
      createdBy: json['created_by_name'],
      eventDoc: (json['event_doc'] as List?)?.cast<String>(), // Casting to List<String>
      eventNotes: json['event_notes'],
      participants: (json['userData'] as List?)?.map((p) => Participant.fromJson(p)).toList(),
      groups: (json['groups'] as List?)?.map((g) => GroupList.fromJson(g)).toList(),
      users: (json['users'] as List?)?.map((u) => User.fromJson(u)).toList(),
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