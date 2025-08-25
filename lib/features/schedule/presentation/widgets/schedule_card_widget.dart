import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:campus_life_hub/features/schedule/domain/entities/schedule_timeline_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';


class ScheduleCardWidget extends StatelessWidget {
  final bool halfWidth;
  final ScheduleTimelineEntity data;

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
                  data.courseCode,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    data.courseNameTh,
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
              'Section: ${data.sectionCode}',
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
                  onPressed: data.isCheckin
                    ? null
                    : () {
                      final firebaseAuth = FirebaseAuth.instance;
                      context.read<ScheduleBloc>().add(CheckInClass(userId: firebaseAuth.currentUser!.uid, templateId: data.templateId, slotId: data.slotId, logId: data.logId));
                    },
                  child: Text(
                  data.isCheckin ? "Checked In" : "Check In",
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
