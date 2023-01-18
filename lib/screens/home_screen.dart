import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scheduler/components/calendar.dart';
import 'package:scheduler/components/schedule_bottom_sheet.dart';
import 'package:scheduler/components/schedule_card.dart';
import 'package:scheduler/components/today_banner.dart';
import 'package:scheduler/constants/colors.dart';
import 'package:scheduler/database/drift_database.dart';
import 'package:scheduler/models/schedule_with_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
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
              TodayBanner(selectedDay: selectedDay),
              const SizedBox(height: 8.0),
              _ScheduleList(selectedDay: selectedDay),
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
                return ScheduleBottomSheet(
                  selectedDate: selectedDay,
                );
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
  final DateTime selectedDay;

  const _ScheduleList({Key? key, required this.selectedDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: StreamBuilder<List<ScheduleWithColor>>(
            stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDay),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.isEmpty) {
                return const Center(child: Text('스케쥴이 없습니다.'));
              }

              return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8.0);
                },
                itemBuilder: (context, index) {
                  final scheduleWithColor = snapshot.data![index];

                  return ScheduleCard(
                    startTime: scheduleWithColor.schedule.startTime,
                    endTime: scheduleWithColor.schedule.endTime,
                    content: scheduleWithColor.schedule.content,
                    color: Color(int.parse(
                        'FF${scheduleWithColor.categoryColor.hexCode}',
                        radix: 16)),
                  );
                },
              );
            }),
      ),
    );
  }
}
