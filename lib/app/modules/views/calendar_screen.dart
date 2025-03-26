import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../widgets/event_list_item.dart';
import '../../constants/app_colors/app_colors.dart';
import '../controllers/bottom_nav_bar_controller.dart';
import '../controllers/calendar_controller.dart';


class CalendarScreen extends GetView<CalendarController> {
  final controller = Get.put(CalendarController());
  final controllerBottom = Get.put(BottomNavBarController());

  CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // ✅ Keeps the status bar transparent
        statusBarIconBrightness: Brightness.light, // ✅ White icons on dark backgrounds
        statusBarBrightness: Brightness.dark, // ✅ Ensures compatibility on iOS
      ),
    );
    return Scaffold(
      body: Container(
        color: AppColors.calendarColor,
        child: Obx(
              () => Stack(
                children: [
                  Column(
                              children: [
                  SizedBox(height: screenHeight * 0.05),
                  _buildCalendarHeader(),
                  _buildCalendarGrid(),
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: _buildEventList(
                      height: screenHeight,
                      width: screenWidth,
                    ),
                  ),
                              ],
                            ),

                  controller.isLoading.value ? Container(
                    color: Colors.black.withOpacity(0.2),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ) : Container()
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => controller.changeMonth(-1),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 15,
            ),
          ),
          Text(
            DateFormat('MMMM yyyy').format(controller.currentDate.value),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
          ),
          IconButton(
            onPressed: () => controller.changeMonth(1),
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(
      controller.currentDate.value.year,
      controller.currentDate.value.month,
      1,
    );
    final daysInMonth = DateTime(
      controller.currentDate.value.year,
      controller.currentDate.value.month + 1,
      0,
    ).day;
    final firstDayWeekday = firstDay.weekday;

    int totalGridCells =
    (firstDayWeekday - 1 + daysInMonth).ceilToDouble().toInt();
    if (totalGridCells % 7 != 0) {
      totalGridCells = totalGridCells + (7 - (totalGridCells % 7));
    }

    return Column(
      children: [
        Row(
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map((dayName) => Expanded(
            child: Center(
              child: Text(
                dayName,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ))
              .toList(),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemCount: totalGridCells,
          itemBuilder: (context, index) {
            int dayNumber = index - firstDayWeekday + 1;
            if (index < firstDayWeekday - 1 ||
                dayNumber < 1 ||
                dayNumber > daysInMonth) {
              return Container();
            }

            final day = DateTime(
              controller.currentDate.value.year,
              controller.currentDate.value.month,
              dayNumber,
            );

            return GestureDetector(
              onTap: () => controller.selectDate(day),
              child: Stack(
                children: [
                  Container( // Add some margin around each day
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: day == controller.selectedDate.value
                          ? AppColors.dateSelectedColor : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color:Colors.white,
                        ),
                      ),
                    ),
                  ),
                  if (controller.eventsByDate.containsKey(day.day) &&
                      controller.eventsByDate[day.day]!.isNotEmpty)
                    Positioned(
                      bottom: 4,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 6,
                        width: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:day == controller.selectedDate.value
                              ?  AppColors.white : AppColors.dateSelectedColor,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventList({required double height, required double width}) {
    final filteredEvents = controller.eventsForSelectedDate;

    if (filteredEvents.isEmpty) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: height * 0.02),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 12.0, right: 12),
                    child: const Text(
                      'Upcoming Events',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.textDarkColor,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                const Expanded(
                  child: Center(
                    child: Text('No events on this day'),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 15,
              right: 15,
              child: GestureDetector(
                onTap: () {
                  controllerBottom.selectedIndex.value = 2;
                },
                child: Image.asset(
                  'assets/images/select.png',
                  height: 35,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: height * 0.02),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 12.0, right: 12),
                  child: const Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.textDarkColor,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    return EventListItem(event: filteredEvents[index]);
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: GestureDetector(
              onTap: () {
                controllerBottom.selectedIndex.value = 2;
              },
              child: Image.asset(
                'assets/images/select.png',
                height: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}