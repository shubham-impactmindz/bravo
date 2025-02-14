import 'package:get/get.dart';

import '../../constants/app_colors/app_colors.dart';
import '../apiservice/api_service.dart';
import '../models/event_model.dart';

class CalendarController extends GetxController {
  var currentDate = DateTime.now().obs;
  var selectedDate = DateTime.now().obs;
  var eventsByDate = <int, List<Event>>{}.obs;
  var eventsForSelectedDate = <Event>[].obs;
  final ApiService apiService = ApiService();
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchEvents();
    super.onInit();
  }

  void fetchEvents() async {
    int month = currentDate.value.month;
    int year = currentDate.value.year;

    isLoading.value = true;
    update();
    try {
      var fetchedEvents = await apiService.fetchEvents(month, year);
      eventsByDate.value = fetchedEvents;
      filterEventsByDate(selectedDate.value);
    }
    catch (e){
      Get.snackbar('Error', 'Something went wrong',colorText: AppColors.white,backgroundColor: AppColors.calendarColor);
    } finally{
      isLoading.value = false;
    }
  }

  void changeMonth(int delta) {
    currentDate.value = DateTime(
      currentDate.value.year,
      currentDate.value.month + delta,
      1,
    );
    fetchEvents();
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    filterEventsByDate(date);
  }

  void filterEventsByDate(DateTime date) {
    eventsForSelectedDate.value = eventsByDate[date.day] ?? [];
  }
}