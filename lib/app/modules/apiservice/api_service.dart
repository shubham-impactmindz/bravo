import 'dart:convert';
import 'dart:io';
import 'package:bravo/app/modules/models/add_event_model.dart';
import 'package:bravo/app/modules/models/categories_list_model.dart';
import 'package:bravo/app/modules/models/group_list_model.dart';
import 'package:bravo/app/modules/models/notification_list_model.dart';
import 'package:bravo/app/modules/models/send_message_model.dart';
import 'package:bravo/app/modules/models/student_detail_model.dart';
import 'package:bravo/app/modules/models/update_profile_picture_model.dart';
import 'package:bravo/app/modules/models/user_chats_list_model.dart';
import 'package:bravo/app/modules/models/user_details_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/all_users_model.dart';
import '../models/event_model.dart';
import '../models/unique_code_model.dart';
import '../models/user_chat_model.dart';

class ApiService {
  final String baseUrl = "https://impactmindz.in/client/artie/bravo/ci_back_end/api";

  Future<UniqueCodeResponse> fetchUserData(Map<String, dynamic> requestBody) async {
    final url = Uri.parse('$baseUrl/auth');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return UniqueCodeResponse.fromJson(jsonDecode(response.body));
      } else {
        return UniqueCodeResponse(isSuccess: false, message: "Failed to fetch data", token: '');
      }
    } catch (e) {
      return UniqueCodeResponse(isSuccess: false, message: "Error: $e", token: '');
    }
  }

  Future<Map<int, List<Event>>> fetchEvents(int month, int year) async {
    final url = Uri.parse("$baseUrl/events/get_events?month=$month&year=$year");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

      try {
        final response = await http.get(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check isSuccess and data is not empty
        if (data["isSuccess"] == true && data["data"] != null && data["data"] is Map<String, dynamic>) {
          return _parseEvents(data["data"]);
        }
      }
    } catch (e) {
      print("Error fetching events: $e");
    }

    return {};
  }

  Future<Event> fetchEventById(String eventId) async {
    final url = Uri.parse("$baseUrl/Events/get_events_details?event_id=$eventId");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

      try {
        final response = await http.get(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check isSuccess and data is not empty
        if (data["isSuccess"] == true && data["data"] != null && data["data"] is Map<String, dynamic>) {
          return Event.fromJson(jsonDecode(response.body));
        }
      }
    } catch (e) {
      print("Error fetching events: $e");
    }

    return Event();
  }

  Map<int, List<Event>> _parseEvents(Map<String, dynamic> rawData) {
    Map<int, List<Event>> eventsMap = {};

    rawData.forEach((date, eventList) {
      int day = int.parse(date);
      if (eventList is List) {
        List<Event> events = eventList.map<Event>((event) {
          return Event.fromJson(event); // Use fromJson constructor
        }).toList();

        eventsMap[day] = events;
      }
    });

    return eventsMap;
  }

  Future<UserDetailsModel> fetchUserDetails() async {
    final url = Uri.parse('$baseUrl/users_details');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return UserDetailsModel.fromJson(jsonDecode(response.body));
      } else {
        return UserDetailsModel(isSuccess: false, message: "Failed to fetch data");
      }
    } catch (e) {
      return UserDetailsModel(isSuccess: false, message: "Error: $e");
    }
  }

  Future<NotificationListModel> fetchNotificationList(int page, int limit) async {
    final url = Uri.parse('$baseUrl/notification/get_notifications?offset=$page&limit=$limit');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return NotificationListModel.fromJson(jsonDecode(response.body));
      } else {
        return NotificationListModel(status: false);
      }
    } catch (e) {
      return NotificationListModel(status: false);
    }
  }

  Future<GroupsListModel> fetchGroupList() async {
    final url = Uri.parse('$baseUrl/GetGroupsOfUsers');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return GroupsListModel.fromJson(jsonDecode(response.body));
      } else {
        return GroupsListModel(isSuccess: false, message: "Failed to fetch data");
      }
    } catch (e) {
      return GroupsListModel(isSuccess: false, message: "Error: $e");
    }
  }

  Future<CategoriesListModel> fetchCategoryList() async {
    final url = Uri.parse('$baseUrl/GetAllEventCategory');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return CategoriesListModel.fromJson(jsonDecode(response.body));
      } else {
        return CategoriesListModel(isSuccess: false, message: "Failed to fetch data");
      }
    } catch (e) {
      return CategoriesListModel(isSuccess: false, message: "Error: $e");
    }
  }

  Future<AddEventModel> addEvent(Map<String, dynamic> requestBody, List<File> value) async {
    final url = Uri.parse('$baseUrl/Events/create_event');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {

      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add text fields
      request.fields['title'] = requestBody['title'] ?? '';
      request.fields['description'] = requestBody['description'] ?? '';
      request.fields['start_time'] = requestBody['start_time'] ?? '';
      request.fields['end_time'] = requestBody['end_time'] ?? '';
      request.fields['location'] = requestBody['location'] ?? '';
      request.fields['category'] = requestBody['category'] ?? '';
      request.fields['cost'] = requestBody['cost'] ?? '';
      request.fields['group_id'] = requestBody['group_id'] ?? '';
      request.fields['user_id'] = requestBody['user_id'] ?? '';
      request.fields['event_notes'] = requestBody['event_notes'] ?? '';
      request.fields['device_time'] = requestBody['device_time'] ?? '';
      // Add multiple files
      for (var file in value) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'event_doc[]',
            file.path,
            filename: file.path.split('/').last,
          ),
        );
      }
      // Send request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        return AddEventModel.fromJson(decodedResponse);
      } else {
        return AddEventModel(isSuccess: false, message: "Failed to create event");
      }
    } catch (e) {
      return AddEventModel(isSuccess: false, message: "Error: $e");
    }
  }

  Future<AddEventModel> updateEvent(Map<String, dynamic> requestBody, List<File> value, bool isFilePicked, String eventId) async {
    final url = Uri.parse('$baseUrl/Events/update_event/$eventId');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {

      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add text fields
      request.fields['title'] = requestBody['title'] ?? '';
      request.fields['description'] = requestBody['description'] ?? '';
      request.fields['start_time'] = requestBody['start_time'] ?? '';
      request.fields['end_time'] = requestBody['end_time'] ?? '';
      request.fields['location'] = requestBody['location'] ?? '';
      request.fields['category'] = requestBody['category'] ?? '';
      request.fields['cost'] = requestBody['cost'] ?? '';
      request.fields['group_id'] = requestBody['group_id'] ?? '';
      request.fields['user_id'] = requestBody['user_id'] ?? '';
      request.fields['event_notes'] = requestBody['event_notes'] ?? '';
      request.fields['device_time'] = requestBody['device_time'] ?? '';

      if(isFilePicked) {
        for (var file in value) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'event_doc[]',
              file.path,
              filename: file.path.split('/').last,
            ),
          );
        }
      }
      // Send request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        return AddEventModel.fromJson(decodedResponse);
      } else {
        return AddEventModel(isSuccess: false, message: "Failed to create event");
      }
    } catch (e) {
      return AddEventModel(isSuccess: false, message: "Error: $e");
    }
  }

  Future<UpdateProfilePictureModel> deleteEvent(String eventId) async {
    final url = Uri.parse('$baseUrl/Events/delete_event?event_id=$eventId');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return UpdateProfilePictureModel.fromJson(jsonDecode(response.body));
      } else {
        return UpdateProfilePictureModel(isSuccess: false, message: "Failed to create event");
      }
    } catch (e) {
      return UpdateProfilePictureModel(isSuccess: false, message: "Error: $e");
    }
  }

  Future<UpdateProfilePictureModel> updateProfilePicture(File file) async {
    final url = Uri.parse('$baseUrl/Update_UserProfile/update_profile_picture');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {

      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add text fields
      request.files.add(await http.MultipartFile.fromPath(
          'profile_picture', file.path, filename: file.path
          .split('/')
          .last));

      // Send request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        return UpdateProfilePictureModel.fromJson(decodedResponse);
      } else {
        return UpdateProfilePictureModel(isSuccess: false, message: "Failed to update profile picture");
      }
    } catch (e) {
      return UpdateProfilePictureModel(isSuccess: false, message: "Error: $e");
    }
  }

  Future<UserChatsListModel> fetchMessages(int page, int limit) async {
    final url = Uri.parse('$baseUrl/users_details?page=$page&limit=$limit');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return UserChatsListModel.fromJson(jsonDecode(response.body));
      } else {
        return UserChatsListModel(isSuccess: false, message: "Failed to create event");
      }
    } catch (e) {
      return UserChatsListModel(isSuccess: false, message: "Error: $e");
    }
  }

  Future<UserChatModel> fetchUserMessage(String chatType,int chatId,int page, int limit) async {
    final url = Uri.parse('$baseUrl/Messages/get_all_messages?chatType=$chatType&id=$chatId&page=$page&limit=$limit');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return UserChatModel.fromJson(jsonDecode(response.body));
      } else {
        return UserChatModel();
      }
    } catch (e) {
      return UserChatModel();
    }
  }

  Future<SendMessageModel> sendUserMessage(Map<String, dynamic> requestBody, File files) async {
    final url = Uri.parse('$baseUrl/Messages/send_message');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {

      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      // ✅ Convert all values to String to prevent type errors
      request.fields['message_type_id'] = requestBody['message_type_id']?.toString() ?? '';
      request.fields['parent_message_id'] = requestBody['parent_message_id']?.toString() ?? '';
      request.fields['chat_type'] = requestBody['chat_type']?.toString() ?? '';
      request.fields['is_read'] = requestBody['is_read']?.toString() ?? '0';
      request.fields['group_id'] = requestBody['group_id']?.toString() ?? '';
      request.fields['receiver_id'] = requestBody['receiver_id']?.toString() ?? '';
      request.fields['device_time'] = requestBody['device_time']?.toString() ?? '';

      // ✅ Only add file if it's not null
      if (files.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('content', files.path, filename: files.path.split('/').last));
      }else{
        request.fields['content'] = requestBody['content']?.toString() ?? '';
      }

      // Send request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);


      if (response.statusCode == 200) {
        return SendMessageModel.fromJson(decodedResponse);
      } else {
        return SendMessageModel();
      }
    } catch (e) {
      return SendMessageModel();
    }
  }

  Future<StudentDetailModel> fetchUserDetail(String userId,int chatId) async {
    final url = Uri.parse('$baseUrl/GroupParticipant/$chatId?userId=$userId');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return StudentDetailModel.fromJson(jsonDecode(response.body));
      } else {
        return StudentDetailModel();
      }
    } catch (e) {
      return StudentDetailModel();
    }
  }

  Future<StudentDetailModel> fetchUserDetailById(String userId) async {
    final url = Uri.parse('$baseUrl/GetUserByID/$userId');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return StudentDetailModel.fromJson(jsonDecode(response.body));
      } else {
        return StudentDetailModel();
      }
    } catch (e) {
      return StudentDetailModel();
    }
  }

  Future<AllUsersModel> fetchAllUser() async {
    final url = Uri.parse('$baseUrl/AllActiveUsers');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return AllUsersModel.fromJson(jsonDecode(response.body));
      } else {
        return AllUsersModel();
      }
    } catch (e) {
      return AllUsersModel();
    }
  }

  Future<SendMessageModel> updateEventStatus(Map<String, dynamic> requestBody,) async {
    final url = Uri.parse('$baseUrl/Events/update_participant_status');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded', // Correct for form data
        },
        body: requestBody.map((key, value) => MapEntry(key, value.toString())), // Convert all values to String
      );

      if (response.statusCode == 200) {
        return SendMessageModel.fromJson(jsonDecode(response.body));
      } else {
        return SendMessageModel();
      }
    } catch (e) {
      return SendMessageModel();
    }
  }
}
