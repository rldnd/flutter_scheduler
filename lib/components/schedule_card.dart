import 'package:flutter/material.dart';
import 'package:scheduler/constants/colors.dart';

class ScheduleCard extends StatelessWidget {
  final int startTime;
  final int endTime;
  final String content;
  final Color color;

  const ScheduleCard(
      {super.key,
      required this.startTime,
      required this.endTime,
      required this.content,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: PRIMARY_COLOR,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Time(startTime: startTime, endTime: endTime),
                const SizedBox(width: 16.0),
                Expanded(child: _Content(content: content)),
                const SizedBox(width: 16.0),
                _Category(color: color)
              ],
            ),
          ),
        ));
  }
}

class _Time extends StatelessWidget {
  final int startTime;
  final int endTime;

  const _Time({Key? key, required this.startTime, required this.endTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: PRIMARY_COLOR,
      fontSize: 16.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${startTime.toString().padLeft(2, '0')}:00', style: textStyle),
        Text('${endTime.toString().padLeft(2, "0")}:00',
            style: textStyle.copyWith(fontSize: 10.0)),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content;

  const _Content({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(content);
  }
}

class _Category extends StatelessWidget {
  final Color color;

  const _Category({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: 16.0,
      height: 16.0,
    );
  }
}
