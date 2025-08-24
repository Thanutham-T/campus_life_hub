import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';


class WeekDateSelector extends StatelessWidget {
  const WeekDateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        final now = DateTime.now();
        final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final selectedDateNotifier = ValueNotifier<DateTime>(now);

        return ValueListenableBuilder<DateTime>(
          valueListenable: selectedDateNotifier,
          builder: (context, selected, _) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final dayDate = firstDayOfWeek.add(Duration(days: index));
                  final dayOfWeek = DateFormat.E('th').format(dayDate);
                  final date = DateFormat.d().format(dayDate);

                  bool isSelected = dayDate.day == selected.day && dayDate.month == selected.month && dayDate.year == selected.year;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: isSelected ? Colors.indigo : Colors.white,
                          foregroundColor: isSelected ? Colors.white : Colors.blueAccent,
                          elevation: isSelected ? 3 : 0,
                          shadowColor: isSelected ? Colors.blueGrey : Colors.transparent,
                        ),
                        onPressed: () {
                          selectedDateNotifier.value = dayDate;
                          BlocProvider.of<ScheduleBloc>(context).add(LoadDaySchedule(
                              userId: FirebaseAuth.instance.currentUser!.uid,
                              date: DateTime(
                                dayDate.year,
                                dayDate.month,
                                dayDate.day,
                              ),
                            ),
                          );
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
            );
          },
        );
      },
    );
  }
}
