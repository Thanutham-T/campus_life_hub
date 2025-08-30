import 'package:flutter/material.dart';

import 'package:campus_life_hub/features/schedule/domain/entities/schedule_slot_entity.dart';


class EditableSlot {
  String id;
  String day;
  String startTime;
  String endTime;
  String room;

  EditableSlot({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  ScheduleSlotEntity toEntity() {
    return ScheduleSlotEntity(
      id: id,
      dayOfWeek: day,
      startTime: startTime,
      endTime: endTime,
      room: room,
    );
  }
}

class ScheduleCard extends StatefulWidget {
  final EditableSlot slot;
  final ValueChanged<EditableSlot> onChanged;

  const ScheduleCard({required this.slot, required this.onChanged, super.key});

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  late String selectedDay;
  late TextEditingController roomController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.slot.day;
    roomController = TextEditingController(text: widget.slot.room);
    startTimeController = TextEditingController(text: widget.slot.startTime);
    endTimeController = TextEditingController(text: widget.slot.endTime);

    // listen เพื่อส่งค่ากลับทุกครั้งที่มีการเปลี่ยน
    roomController.addListener(_notifyParent);
    startTimeController.addListener(_notifyParent);
    endTimeController.addListener(_notifyParent);
  }

  void _notifyParent() {
    widget.onChanged(
      EditableSlot(
        id: widget.slot.id,
        day: selectedDay,
        startTime: startTimeController.text,
        endTime: endTimeController.text,
        room: roomController.text,
      ),
    );
  }

  @override
  void dispose() {
    roomController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final timeParts = controller.text.split(':');
    final initialHour = int.tryParse(timeParts[0]) ?? 0;
    final initialMinute =
        int.tryParse(timeParts.length > 1 ? timeParts[1] : '0') ?? 0;
    final initialTime = TimeOfDay(
      hour: initialHour.clamp(0, 23),
      minute: initialMinute.clamp(0, 59),
    );
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      helpText: 'เลือกเวลาในช่วง (00:00 - 23:59)',
    );
    if (picked != null) {
      setState(() {
        controller.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: DropdownButton<String>(
                    value: selectedDay,
                    items:
                        <String>[
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                          'Friday',
                          'Saturday',
                          'Sunday',
                        ].map((String value) {
                          final Map<String, String> enToThaiDay = {
                            'Monday': 'วันจันทร์',
                            'Tuesday': 'วันอังคาร',
                            'Wednesday': 'วันพุธ',
                            'Thursday': 'วันพฤหัสบดี',
                            'Friday': 'วันศุกร์',
                            'Saturday': 'วันเสาร์',
                            'Sunday': 'วันอาทิตย์',
                          };
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              enToThaiDay[value] ?? value,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedDay = value;
                          _notifyParent();
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 4), // Reduced spacing
                Row(
                  children: [
                    Icon(Icons.access_time, size: 24, color: Colors.black54),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 75,
                      child: GestureDetector(
                        onTap: () => _selectTime(context, startTimeController),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: startTimeController,
                            decoration: const InputDecoration(
                              labelText: 'Start',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 10,
                              ), // Reduced padding
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.0,
                      ), // Reduced padding
                      child: Text('-'),
                    ),
                    SizedBox(
                      width: 75,
                      child: GestureDetector(
                        onTap: () => _selectTime(context, endTimeController),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: endTimeController,
                            decoration: const InputDecoration(
                              labelText: 'End',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 10,
                              ), // Reduced padding
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12), // Slightly reduced vertical spacing
            TextFormField(
              controller: roomController,
              decoration: const InputDecoration(
                labelText: 'Room',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ), // Reduced padding
              ),
            ),
          ],
        ),
      ),
    );
  }
}
