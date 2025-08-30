import 'package:flutter/material.dart';

class ScheduleCard extends StatefulWidget {
  final String day;
  final String time;
  final String room;

  const ScheduleCard({
    required this.day,
    required this.time,
    required this.room,
    super.key,
  });

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
    selectedDay = widget.day;
    roomController = TextEditingController(text: widget.room);

    // Split the time string into start and end
    final times = widget.time.split('-');
    startTimeController = TextEditingController(text: times[0].trim());
    endTimeController = TextEditingController(
      text: times.length > 1 ? times[1].trim() : '',
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
    final initialTime = TimeOfDay(
      hour: int.tryParse(timeParts[0]) ?? 8,
      minute: int.tryParse(timeParts.length > 1 ? timeParts[1] : '0') ?? 0,
    );
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 12.0,
        ),
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
                          'วันจันทร์',
                          'วันอังคาร',
                          'วันพุธ',
                          'วันพฤหัสบดี',
                          'วันศุกร์',
                          'วันเสาร์',
                          'วันอาทิตย์',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedDay = newValue;
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
