import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_state.dart';
import '../widgets/schdule_edit_card_widget.dart';

class ManageScheduleSheet extends StatefulWidget {
  final String? selectedSubjectId;

  const ManageScheduleSheet({super.key, required this.selectedSubjectId});

  @override
  State<ManageScheduleSheet> createState() => _ManageScheduleSheetState();
}

class _ManageScheduleSheetState extends State<ManageScheduleSheet> {
  final List<String> _notifyTimes = ['5 นาที', '10 นาที', '15 นาที', '30 นาที'];
  String _selectedNotifyTime = '15 นาที';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoaded) {
          final scheduleTemplate = state.templates.firstWhere(
            (template) => template.id == widget.selectedSubjectId,
            orElse: () => state.templates.first,
          );
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Top bar with close and check
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_sharp),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        scheduleTemplate.courseCode,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }, // Save action
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${scheduleTemplate.courseNameEng}\n${scheduleTemplate.courseNameTh}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    'Sction: ${scheduleTemplate.sectionCode}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('แจ้งเตือนก่อนเวลา'),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _selectedNotifyTime,
                        items: _notifyTimes
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedNotifyTime = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView(
                      children: scheduleTemplate.slots.map((slot) {
                        final dayMap = {
                          'Monday': 'วันจันทร์',
                          'Tuesday': 'วันอังคาร',
                          'Wednesday': 'วันพุธ',
                          'Thursday': 'วันพฤหัสบดี',
                          'Friday': 'วันศุกร์',
                          'Saturday': 'วันเสาร์',
                          'Sunday': 'วันอาทิตย์',
                        };
                        final thaiDay = dayMap[slot.dayOfWeek] ?? slot.dayOfWeek;
                        return ScheduleCard(
                          day: thaiDay,
                          time: '${slot.startTime} - ${slot.endTime}',
                          room: slot.room,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[200],
                      child: IconButton(
                        icon: const Icon(Icons.add, size: 28),
                        onPressed: () {}, // Add schedule
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          );
        } else if (state is ScheduleLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: Text('No schedule data'));
        }
      },
    );
  }
}
