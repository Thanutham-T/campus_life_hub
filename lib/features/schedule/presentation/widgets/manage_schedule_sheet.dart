import 'package:flutter/material.dart';

import 'package:campus_life_hub/features/schedule/domain/entities/schedule_template_entity.dart';

import '../widgets/schdule_edit_card_widget.dart';


class ManageScheduleSheet extends StatelessWidget {
  final ScheduleTemplateEntity? selectedSubject;

  const ManageScheduleSheet({super.key, required this.selectedSubject});

  @override
  Widget build(BuildContext context) {
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
                  selectedSubject!.courseCode,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
              selectedSubject!.courseNameEng,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 35),
            const Text(
              'Section 3',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('แจ้งเตือนก่อนเวลา'),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: '15 นาที',
                  items: ['5 นาที', '10 นาที', '15 นาที', '30 นาที']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {},
                ),
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: ListView(
                children: [
                  ScheduleCard(
                    day: 'วันจันทร์',
                    time: '09:00 - 11:50',
                    room: 'R301 (COE_PSU_LAB)',
                  ),
                  ScheduleCard(
                    day: 'วันจันทร์',
                    time: '13:00 - 15:50',
                    room: 'R301 (COE_PSU_LAB)',
                  ),
                  ScheduleCard(
                    day: 'วันพุธ',
                    time: '09:00 - 11:50',
                    room: 'R301 (COE_PSU_LAB)',
                  ),
                  ScheduleCard(
                    day: 'วันพฤหัสบดี',
                    time: '09:00 - 11:50',
                    room: 'R301 (COE_PSU_LAB)',
                  ),
                ],
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
  }
}
