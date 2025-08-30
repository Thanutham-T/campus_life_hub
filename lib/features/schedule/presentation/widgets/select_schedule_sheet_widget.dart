import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:campus_life_hub/features/schedule/domain/entities/schedule_template_entity.dart';

import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_state.dart';

import '../widgets/manage_schedule_sheet.dart';

class SelectScheduleSheetWidget extends StatelessWidget {
  const SelectScheduleSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoaded) {
          List<ScheduleTemplateEntity> templates = state.templates;
          ScheduleTemplateEntity? selectedTemplate = templates.isNotEmpty
              ? templates[0]
              : null;
          return StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'กรุณาเลือกวิชา\nที่ต้องการจัดการตารางเรียนของคุณ!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<ScheduleTemplateEntity>(
                        value: selectedTemplate,
                        items: templates
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text(
                                  '${t.courseCode} ${t.courseNameTh}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTemplate = value;
                          });
                        },
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              onPressed: selectedTemplate != null
                                  ? () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return ManageScheduleSheet(
                                            selectedSubject: selectedTemplate);
                                        },
                                      );
                                    }
                                  : null,
                              child: const Text('ถัดไป'),
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('ยกเลิก'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
