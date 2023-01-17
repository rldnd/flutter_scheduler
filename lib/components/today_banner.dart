import 'package:flutter/material.dart';
import 'package:scheduler/constants/colors.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDay;
  final int scheduleCount;

  final textStyle = const TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  const TodayBanner(
      {required this.selectedDay, required this.scheduleCount, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일',
              style: textStyle,
            ),
            Text(
              '$scheduleCount개',
              style: textStyle,
            )
          ],
        ),
      ),
    );
  }
}
