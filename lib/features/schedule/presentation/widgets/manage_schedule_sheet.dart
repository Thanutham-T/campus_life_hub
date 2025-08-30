import 'package:campus_life_hub/features/schedule/domain/entities/schedule_template_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';
import '../widgets/schdule_edit_card_widget.dart';

class ManageScheduleSheet extends StatefulWidget {
  final String? selectedSubjectId;

  const ManageScheduleSheet({super.key, required this.selectedSubjectId});

  @override
  State<ManageScheduleSheet> createState() => _ManageScheduleSheetState();
}

class _ManageScheduleSheetState extends State<ManageScheduleSheet> {
  late List<EditableSlot> editableSlots;
  final List<String> _notifyTimes = ['5 นาที', '10 นาที', '15 นาที', '30 นาที'];
  String _selectedNotifyTime = '15 นาที';

  @override
  void initState() {
    super.initState();
    editableSlots = [];
  }

  void _initializeEditableSlots(ScheduleTemplateEntity scheduleTemplate) {
    editableSlots = scheduleTemplate.slots.map((slot) {
      return EditableSlot(
        id: slot.id,
        day: slot.dayOfWeek,
        startTime: slot.startTime,
        endTime: slot.endTime,
        room: slot.room,
      );
    }).toList();
  }

  void _updateSlot(int index, EditableSlot newSlot) {
    setState(() {
      editableSlots[index] = newSlot;
    });
    // AppLogger.debug('New slot data: day=${newSlot.day}, startTime=${newSlot.startTime}, endTime=${newSlot.endTime}, room=${newSlot.room}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoaded) {
          final scheduleTemplate = state.templates.firstWhere(
            (template) => template.id == widget.selectedSubjectId,
            orElse: () => state.templates.first,
          );
          if (editableSlots.isEmpty) {
            _initializeEditableSlots(scheduleTemplate);
          }

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                          context.read<ScheduleBloc>().add(
                            UpdateScheduleTemplate(
                              userId:
                                  FirebaseAuth.instance.currentUser?.uid ?? '',
                              templateId: scheduleTemplate.id,
                              newSlots: editableSlots
                                  .map((e) => e.toEntity())
                                  .toList(),
                            ),
                          );
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
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
                    child: ListView.builder(
                      itemCount: editableSlots.length,
                      itemBuilder: (context, index) {
                        final slot = editableSlots[index];
                        return Dismissible(
                          key: ValueKey(slot.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.red,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              editableSlots.removeAt(index);
                            });
                          },
                          child: ScheduleCard(
                            slot: slot,
                            onChanged: (newSlot) => _updateSlot(index, newSlot),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[200],
                      child: IconButton(
                        icon: const Icon(Icons.add, size: 28),
                        onPressed: () {
                          setState(() {
                            editableSlots.add(
                              EditableSlot(
                                id: '',
                                day: 'Monday',
                                startTime: '00:00',
                                endTime: '00:00',
                                room: '',
                              ),
                            );
                          });
                        },
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
