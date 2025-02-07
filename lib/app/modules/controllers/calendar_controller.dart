import 'package:get/get.dart';
import '../models/event_model.dart';
import '../routes/app_pages.dart';

class CalendarController extends GetxController {
  var currentDate = DateTime.now().obs;
  var selectedDate = DateTime.now().obs;
  var events = <Event>[].obs; // Replace with actual data fetch

  @override
  void onInit() {
    // Sample event data (replace with API call or local DB)
    events.value = [
      Event(
        date: DateTime(2025, 02, 1),
        title: 'Meeting with John',
        time: '10:00 AM',
        description: 'Discuss project updates',
      ),
      Event(
        date: DateTime(2025, 2, 7),
        title: 'Team Lunch',
        time: '1:00 PM',
        description: 'Outing with the team',
      ),
      Event(
        date: DateTime(2025, 2, 12),
        title: 'Workout with Ella',
        time: '19:00-20:00',
        cost: 50,
        createdBy: 'Jaini Shah',
      ),
      Event(
        date: DateTime(2025, 2, 12),
        title: 'Workout with Ella',
        time: '19:00-20:00',
        cost: 50,
        createdBy: 'Jaini Shah',
      ),
      Event(
        date: DateTime(2025, 2, 12),
        title: 'Workout with Ella',
        time: '19:00-20:00',
        cost: 50,
        createdBy: 'Jaini Shah',
      ),
      Event(
        date: DateTime(2025, 2, 12),
        title: 'Workout with Ella',
        time: '19:00-20:00',
        cost: 50,
        createdBy: 'Jaini Shah',
      ),
      Event(
        date: DateTime(2025, 2, 12),
        title: 'Workout with Ella',
        time: '19:00-20:00',
        cost: 50,
        createdBy: 'Jaini Shah',
      ),
      Event(
        date: DateTime(2025, 2, 12),
        title: 'Workout with Ella',
        time: '19:00-20:00',
        cost: 50,
        createdBy: 'Jaini Shah',
      ),
    ];

    filterEventsByDate(selectedDate.value);
    super.onInit();
  }

  void changeMonth(int delta) {
    currentDate.value = DateTime(
      currentDate.value.year,
      currentDate.value.month + delta,
      1,
    );
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    filterEventsByDate(date);
  }

  void filterEventsByDate(DateTime date) {
    // Implement filtering logic here (using events list)
    // ...
  }

  // Edit/Delete event methods
  void editEvent(Event event) {
    Get.toNamed(Routes.editEvent);
  }

  void deleteEvent(Event event) {
    // ...
  }
}