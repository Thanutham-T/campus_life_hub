import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../widgets/time_line_widget.dart';
import '../widgets/schedule_card_widget.dart';
import '../widgets/weekdate_selector_widget.dart';

import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_state.dart';

class _CardPosition {
  final double top;
  final double left;
  final bool halfWidth;

  _CardPosition({
    required this.top,
    required this.left,
    required this.halfWidth,
  });
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  int _convertTimeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

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
                          Text('วันนี้', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          SizedBox(width: 6),
                          Text('ภาคการศึกษาที่ 1/2568', style: TextStyle(fontSize: 14, color: const Color.fromARGB(221, 61, 61, 61))),
                        ],
                      ),
                      Text('$day $month $year', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
            WeekDateSelector(),
            SizedBox(height: 20),
            Expanded(
                child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: BlocBuilder<ScheduleBloc, ScheduleState>(
                  builder: (context, state) {
                    if (state is ScheduleLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ScheduleLoaded) {
                      final data = state.schedules;

                      if (data.isEmpty) {
                        return const Center(child: Text("ไม่มีตารางเรียนในวันนี้"));
                      }

                      // Precompute positions and overlap info for cards
                      List<_CardPosition> cardPositions = [];
                      double top = 0;
                      for (int i = 0; i < data.length; i++) {
                        bool halfWidth = false, overlapPrev = false;

                        // Check is current item time overlap with previous item (calculate left position)
                        if (i > 0) {
                          final prevEnd = _convertTimeOfDayToMinutes(data[i - 1].endTime);
                          final currStart = _convertTimeOfDayToMinutes(data[i].startTime);
                          if (prevEnd > currStart) {
                            halfWidth = true;
                            overlapPrev = true;
                          }
                        }

                        // Check is current item time overlap with next item (calculate left position)
                        if (i < data.length - 1) {
                          final currEnd = _convertTimeOfDayToMinutes(data[i].endTime);
                          final nextStart = _convertTimeOfDayToMinutes(data[i + 1].startTime);
                          if (currEnd > nextStart) {
                            halfWidth = true;
                          }
                        }
                        cardPositions.add(_CardPosition(top: top, left: overlapPrev ? 150 : 0, halfWidth: halfWidth)); // Store card position info

                        // Check is current item time overlap with next item (calculate top position)
                        if (i < data.length - 1) {
                          top += 43;
                          final prevEnd = _convertTimeOfDayToMinutes(data[i].endTime);
                          final nextStart = _convertTimeOfDayToMinutes(data[i + 1].startTime);
                          top += prevEnd < nextStart
                            ? 120
                            : 10 * ((nextStart - _convertTimeOfDayToMinutes(data[i].startTime)) ~/ 10);
                        }
                      }

                      return SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, right: 8.0),
                          child: Column(
                          children: List.generate(data.length, (index) {
                            final item = data[index];
                            final isLast = index == data.length - 1;
                            final nextItem = !isLast ? data[index + 1] : null;
                            final widgets = <Widget>[TimeLineWidget(startTime: item.startTime, endTime: item.endTime, isEnd: isLast),];
                            if (!isLast && nextItem != null) {
                              final itemEndMinutes = _convertTimeOfDayToMinutes(item.endTime);
                              final nextStartMinutes = _convertTimeOfDayToMinutes(nextItem.startTime);
                              widgets.add(TimeLineWidget(
                                numberOfLine: itemEndMinutes < nextStartMinutes
                                  ? 12
                                  : ((nextStartMinutes - _convertTimeOfDayToMinutes(item.startTime)) ~/ 10),
                              ));
                            }
                            return Column(children: widgets);
                          }),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          height: (data.length * 150) + 20,
                          child: Stack(
                          children: List.generate(data.length, (index) {
                            final item = data[index];
                            final pos = cardPositions[index];
                            return Positioned(
                              left: pos.left,
                              top: pos.top,
                              child: ScheduleCardWidget(
                                data: item,
                                halfWidth: pos.halfWidth,
                              ),
                            );
                          }),
                          ),
                        ),
                        ],
                      ),
                      );
                    } else if (state is ScheduleError) {
                      return Center(
                      child: Text("เกิดข้อผิดพลาด: ${state.message}"),
                      );
                    }
                    return const Center(
                      child: Text("เลือกวันเพื่อดูตารางเรียน"),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
