import 'package:bravo/app/constants/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarDay extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool hasEvent;
  final VoidCallback onTap;

  const CalendarDay({
    required this.day,
    required this.isSelected,
    required this.hasEvent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(4), // Add some margin around each day
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColors.dateSelectedColor : Colors.transparent,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                day.day.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto'
                ),
              ),
              if (hasEvent)
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.white : Colors.red, // Event indicator
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}