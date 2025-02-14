import 'dart:convert';
import 'dart:io';
import 'package:bravo/app/modules/models/add_event_model.dart';
import 'package:bravo/app/modules/models/categories_list_model.dart';
import 'package:bravo/app/modules/models/group_list_model.dart';
import 'package:bravo/app/modules/models/user_details_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';
import '../models/unique_code_model.dart';

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
    final url = Uri.parse("$baseUrl/events//get_events?month=$month&year=$year");
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
        return UserDetailsModel(isSuccess: false, message: "Failed to fetch data", groupInfo: '');
      }
    } catch (e) {
      return UserDetailsModel(isSuccess: false, message: "Error: $e", groupInfo: '');
    }
  }

  Future<GroupsListModel> fetchGroupList() async {
    final url = Uri.parse('$baseUrl/GetAllGroups');
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

  Future<AddEventModel> addEvent(Map<String, dynamic> requestBody, File files) async {
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
      request.files.add(await http.MultipartFile.fromPath('event_doc[]', files.path, filename: files.path.split('/').last));

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

  Future<AddEventModel> updateEvent(Map<String, dynamic> requestBody, File files, bool isFilePicked, String eventId) async {
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

      if(isFilePicked) {
        request.files.add(await http.MultipartFile.fromPath(
            'event_doc[]', files.path, filename: files.path
            .split('/')
            .last));
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
}
