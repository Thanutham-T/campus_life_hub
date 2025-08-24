import 'package:campus_life_hub/core/logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:campus_life_hub/features/schedule/presentation/widgets/time_line_widget.dart';
import 'package:campus_life_hub/features/schedule/presentation/widgets/schedule_card_widget.dart';

class ScheduleItem {
  final String code;
  final String name;
  final String section;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String room;
  final bool checkedIn;

  ScheduleItem({
    required this.code,
    required this.name,
    required this.section,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.checkedIn,
  });
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  static final mockData = [
    ScheduleItem(
      code: "240-331",
      name: "Mobile application developer module",
      startTime: TimeOfDay(hour: 9, minute: 0),
      endTime: TimeOfDay(hour: 11, minute: 50),
      section: "01",
      room: "101",
      checkedIn: false,
    ),
    ScheduleItem(
      code: "240-332",
      name: "Web development module",
      startTime: TimeOfDay(hour: 13, minute: 00),
      endTime: TimeOfDay(hour: 14, minute: 50),
      section: "01",
      room: "102",
      checkedIn: false,
    ),
    ScheduleItem(
      code: "240-333",
      name: "Software engineering module",
      startTime: TimeOfDay(hour: 14, minute: 0),
      endTime: TimeOfDay(hour: 15, minute: 50),
      section: "02",
      room: "103",
      checkedIn: false,
    ),
    ScheduleItem(
      code: "240-334",
      name: "High Performance Computing",
      startTime: TimeOfDay(hour: 17, minute: 0),
      endTime: TimeOfDay(hour: 18, minute: 30),
      section: "02",
      room: "104",
      checkedIn: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var day = now.day;
    var month = DateFormat.MMMM('th').format(now);
    var year = now.year + 543;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'วันนี้',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'ภาคการศึกษาที่ 1/2567',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color.fromARGB(221, 61, 61, 61),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$day $month $year',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: (() => {}),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.book, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'จัดการรายวิชา',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final now = DateTime.now();
                  final firstDayOfWeek = now.subtract(
                    Duration(days: now.weekday - 1),
                  );
                  final dayDate = firstDayOfWeek.add(Duration(days: index));
                  final dayOfWeek = DateFormat.E('th').format(dayDate);
                  final date = DateFormat.d().format(dayDate);

                  bool isSelected =
                      dayDate.day == now.day &&
                      dayDate.month == now.month &&
                      dayDate.year == now.year;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: isSelected
                              ? Colors.blueGrey
                              : Colors.white,
                          foregroundColor: isSelected
                              ? Colors.white
                              : Colors.blueAccent,
                          elevation: isSelected ? 3 : 0,
                          shadowColor: isSelected
                              ? Colors.blueGrey
                              : Colors.transparent,
                        ),
                        onPressed: () {
                          // Handle day selection
                          // You need to move this widget to a StatefulWidget to update selected day
                        },
                        child: Column(
                          children: [
                            Text(
                              dayOfWeek,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              date,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 3.0),
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.only(
                          top: 20.0,
                          bottom: 20.0,
                          right: 8.0,
                        ),
                        child: Column(
                          children: [
                            ...mockData.asMap().entries.map((entry) {
                              final item = entry.value;
                              final index = entry.key;
                              List<Widget> widgets = [
                                if (index == mockData.length - 1)
                                  TimeLineWidget(
                                    startTime: item.startTime,
                                    endTime: item.endTime,
                                    isEnd: true,
                                  )
                                else
                                  TimeLineWidget(
                                    startTime: item.startTime,
                                    endTime: item.endTime,
                                  ),
                              ];
                              if (index < mockData.length - 1) {
                                final nextItem = mockData[index + 1];
                                final itemEndMinutes =
                                    item.endTime.hour * 60 +
                                    item.endTime.minute;
                                final nextStartMinutes =
                                    nextItem.startTime.hour * 60 +
                                    nextItem.startTime.minute;
                                if (itemEndMinutes < nextStartMinutes) {
                                  widgets.add(TimeLineWidget(numberOfLine: 12));
                                } else {
                                  // Parse times as minutes
                                  final itemStart =
                                      item.startTime.hour * 60 +
                                      item.startTime.minute;
                                  final diff = nextStartMinutes - itemStart;
                                  widgets.add(
                                    TimeLineWidget(
                                      numberOfLine: ((diff ~/ 10)),
                                    ),
                                  );
                                }
                              }
                              return Column(children: widgets);
                            }),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        height: mockData.length * 150,
                        child: Stack(
                          children: <Widget>[
                            ...mockData.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;

                              // Calculate top position efficiently
                              int top = 0;
                              for (int i = 0; i < index; i++) {
                                final prev = mockData[i];
                                final next = mockData[i + 1];
                                top += 43; // 18 + 25, card height
                                final prevEnd =
                                    prev.endTime.hour * 60 +
                                    prev.endTime.minute;
                                final nextStart =
                                    next.startTime.hour * 60 +
                                    next.startTime.minute;
                                top += prevEnd < nextStart
                                    ? 120 // 10 * 12, gap
                                    : 10 *
                                          ((nextStart -
                                                  (prev.startTime.hour * 60 +
                                                      prev.startTime.minute)) ~/
                                              10); // 10 minutes per line
                              }

                              // Overlap checks
                              bool halfWidth = false;
                              bool overlapPrev = false;
                              if (index > 0) {
                                final prevEnd =
                                    mockData[index - 1].endTime.hour * 60 +
                                    mockData[index - 1].endTime.minute;
                                final currStart =
                                    item.startTime.hour * 60 +
                                    item.startTime.minute;
                                if (prevEnd > currStart) {
                                  halfWidth = true;
                                  overlapPrev = true;
                                }
                              }
                              if (index < mockData.length - 1) {
                                final currEnd =
                                    item.endTime.hour * 60 +
                                    item.endTime.minute;
                                final nextStart =
                                    mockData[index + 1].startTime.hour * 60 +
                                    mockData[index + 1].startTime.minute;
                                if (currEnd > nextStart) {
                                  halfWidth = true;
                                }
                              }

                              // Positioning
                              double left = overlapPrev ? 150 : 0;

                              return Positioned(
                                left: left,
                                top: top.toDouble(),
                                child: ScheduleCardWidget(
                                  data: item,
                                  halfWidth: halfWidth,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
