import 'package:flutter/material.dart';
import 'package:scheduler/constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;

  const Calendar(
      {super.key,
      required this.selectedDay,
      required this.focusedDay,
      required this.onDaySelected});

  @override
  Widget build(BuildContext context) {
    print('focusedDay:: $focusedDay, selectedDay:: $selectedDay');
    final defaultBoxDecoration = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(6.0),
    );

    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: focusedDay,
      firstDay: DateTime(1800, 1, 1),
      lastDay: DateTime(3000),
      headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
          )),
      calendarStyle: CalendarStyle(
          isTodayHighlighted: false,
          defaultDecoration: defaultBoxDecoration,
          weekendDecoration: defaultBoxDecoration,
          selectedDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: PRIMARY_COLOR,
              width: 1,
            ),
          ),
          defaultTextStyle: defaultTextStyle,
          weekendTextStyle: defaultTextStyle,
          selectedTextStyle: defaultTextStyle.copyWith(color: PRIMARY_COLOR),
          outsideDecoration: const BoxDecoration(
            shape: BoxShape.rectangle,
          )),
      onDaySelected: onDaySelected,
      selectedDayPredicate: ((date) {
        return date.year == selectedDay.year &&
            date.month == selectedDay.month &&
            date.day == selectedDay.day;
      }),
    );
  }
}
