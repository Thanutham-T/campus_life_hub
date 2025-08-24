import 'package:flutter/material.dart';
import '../pages/schedule_page.dart';

class ScheduleCardWidget extends StatelessWidget {
  final bool halfWidth;
  final ScheduleItem data;

  const ScheduleCardWidget({super.key, required this.data, this.halfWidth = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        width: halfWidth ? 140 : 290,
        height: 150,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  data.code,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    data.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Section: ${data.section}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Room: ${data.room}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 35,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 28),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  onPressed: () {
                    // Add your check-in logic here
                  },
                  child: Text(
                    data.checkedIn ? "Checked In" : "Check In",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
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