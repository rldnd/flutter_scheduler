import 'package:flutter/material.dart';
import 'package:scheduler/components/calendar.dart';
import 'package:scheduler/components/schedule_bottom_sheet.dart';
import 'package:scheduler/components/schedule_card.dart';
import 'package:scheduler/components/today_banner.dart';
import 'package:scheduler/constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: renderFloatingActionButton(),
        body: SafeArea(
          child: Column(
            children: [
              Calendar(
                focusedDay: focusedDay,
                selectedDay: selectedDay,
                onDaySelected: onDaySelected,
              ),
              const SizedBox(height: 8.0),
              TodayBanner(selectedDay: selectedDay, scheduleCount: 3),
              const SizedBox(height: 8.0),
              const _ScheduleList(),
            ],
          ),
        ));
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (_) {
                return ScheduleBottomSheet();
              });
        },
        backgroundColor: PRIMARY_COLOR,
        child: Icon(Icons.add));
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.separated(
          itemCount: 100,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 8.0);
          },
          itemBuilder: (context, index) {
            return ScheduleCard(
                startTime: 8,
                endTime: 12,
                content: '프로그래밍 공부. $index',
                color: Colors.red);
          },
        ),
      ),
    );
  }
}
