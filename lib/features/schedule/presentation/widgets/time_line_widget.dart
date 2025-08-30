import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:intl/intl.dart';


class TimeLineWidget extends StatelessWidget {
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final int? numberOfLine;
  final bool? isEnd;

  const TimeLineWidget({super.key, this.startTime, this.endTime, this.numberOfLine, this.isEnd = false});

  @override
  Widget build(BuildContext context) {
    if (startTime == null || endTime == null) {
      if (numberOfLine == null || numberOfLine! <= 0) {
        return SizedBox.shrink();
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 62), // same width as the time column
          Column(children: [
            for (var i = 0; i < numberOfLine!; i++)
              SizedBox(height: 10, child: SolidLineConnector())
          ]),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('HH:mm').format(
              DateTime(0, 1, 1, startTime!.hour, startTime!.minute)
              ), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(DateFormat('HH:mm').format(
              DateTime(0, 1, 1, endTime!.hour, endTime!.minute)
              ), style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
            ],
          ),
        ),
        // Timeline part
        Column(
          children: [
            // Dot
            SizedBox(height: 2.5, child: SolidLineConnector()),
            DotIndicator(),
            // Connector
            if (isEnd == false)
              SizedBox(height: 25, child: SolidLineConnector()),
          ],
        ),
      ],
    );
  }
}
