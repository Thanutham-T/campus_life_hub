import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:campus_life_hub/features/schedule/domain/entities/schedule_timeline_entity.dart';

import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';

class ScheduleCardWidget extends StatelessWidget {
  final bool halfWidth;
  final ScheduleTimelineEntity data;

  const ScheduleCardWidget({
    super.key,
    required this.data,
    this.halfWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    OverlayEntry? infoOverlay;

    void showInfoOverlay() {
      infoOverlay = OverlayEntry(
        builder: (context) => Stack(
          children: [
            // Semi-transparent background
            Positioned.fill(child: Container(color: Colors.black54)),
            // Centered dialog
            Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 16),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule Info',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('รหัสวิชา: ${data.courseCode}'),
                      Text('ชื่อวิชา: ${data.courseNameTh}'),
                      Text('กลุ่มเรียน: ${data.sectionCode}'),
                      Text('ห้องเรียน: ${data.room}'),
                      Text('หมายเหตุ: ${data.note}'),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      Overlay.of(context, rootOverlay: true).insert(infoOverlay!);
    }

    void removeInfoOverlay() {
      infoOverlay?.remove();
      infoOverlay = null;
    }

    return GestureDetector(
      onTap: () {
        final roomController = TextEditingController(text: data.room);
        final noteController = TextEditingController(text: data.note);

        showDialog(
          context: context,
          builder: (dialogContext) => Builder(
            builder: (innerContext) => AlertDialog(
              title: Text(
                'Edit Schedule',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('รหัส: ${data.courseCode}'),
                  Text('ชื่อวิชา: ${data.courseNameTh}'),
                  Text('กลุ่มเรียน: ${data.sectionCode}'),
                  TextFormField(
                    controller: roomController,
                    decoration: const InputDecoration(labelText: 'ห้องเรียน'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'กรุณากรอกห้องเรียน';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: noteController,
                    decoration: const InputDecoration(labelText: 'หมายเหตุ'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final firebaseAuth = FirebaseAuth.instance;
                    context.read<ScheduleBloc>().add(
                      UpdateClass(
                        userId: firebaseAuth.currentUser!.uid,
                        templateId: data.templateId,
                        slotId: data.slotId,
                        logId: data.logId,
                        newRoom: roomController.text,
                        newNote: noteController.text,
                      ),
                    );
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
      onLongPressStart: (_) {
        showInfoOverlay();
      },
      onLongPressEnd: (_) {
        removeInfoOverlay();
      },
      child: Card(
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Room: ${data.room}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    onPressed: data.isCheckin
                        ? null
                        : () {
                            final firebaseAuth = FirebaseAuth.instance;
                            context.read<ScheduleBloc>().add(
                              CheckInClass(
                                userId: firebaseAuth.currentUser!.uid,
                                templateId: data.templateId,
                                slotId: data.slotId,
                                logId: data.logId,
                              ),
                            );
                          },
                    child: Text(
                      data.isCheckin ? "Checked In" : "Check In",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
