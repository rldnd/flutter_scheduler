import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scheduler/constants/colors.dart';
import 'package:scheduler/database/drift_database.dart';
import 'package:scheduler/models/schedule_with_color.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDay;

  final textStyle = const TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  const TodayBanner({required this.selectedDay, super.key});

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
            StreamBuilder<List<ScheduleWithColor>>(
                stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDay),
                builder: (context, snapshot) {
                  int count = 0;
                  if (snapshot.hasData) count = snapshot.data!.length;

                  return Text(
                    '$count개',
                    style: textStyle,
                  );
                })
          ],
        ),
      ),
    );
  }
}
