import 'package:campus_life_hub/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/schedule_bloc.dart';
import '../widgets/select_schedule_sheet_widget.dart';

class TitleManageToolWidget extends StatelessWidget {
  final String semester;

  const TitleManageToolWidget({
    this.semester = 'ภาคการศึกษาที่ 1/2568',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var day = now.day;
    var month = DateFormat.MMMM('th').format(now);
    var year = now.year + 543;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'วันนี้',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'ภาคการศึกษาที่ $semester',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(221, 61, 61, 61),
                    ),
                  ),
                ],
              ),
              Text(
                '$day $month $year',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () async {
              final scheduleBloc = context.read<ScheduleBloc>();

              await showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return BlocProvider.value(
                    value: scheduleBloc..add(GetAllScheduleTemplates(userId: FirebaseAuth.instance.currentUser!.uid)),
                    child: SelectScheduleSheetWidget(),
                  );
                },
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              children: const [
                Icon(Icons.book, color: Colors.white),
                SizedBox(width: 8),
                Text('จัดการรายวิชา', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
