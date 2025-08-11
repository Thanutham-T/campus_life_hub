import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../user/presentation/bloc/auth_bloc.dart';
import '../../../user/presentation/bloc/auth_state.dart';
import '../../domain/entities/study_group.dart';
import '../bloc/study_group_bloc.dart';
import '../bloc/study_group_event.dart';

class CreateGroupDialog extends StatelessWidget {
  const CreateGroupDialog({super.key});

  static Future<void> show(BuildContext context) {
    final bloc = context.read<StudyGroupBloc>();
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: bloc,
        child: const CreateGroupDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
  // Removed subject/location/schedule inputs per new requirements

    return AlertDialog(
      title: const Text('สร้างกลุ่มศึกษาใหม่'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'ชื่อกลุ่ม *',
                hintText: 'เช่น กลุ่มเรียนคณิตศาสตร์',
                border: OutlineInputBorder(),
              ),
            ),
            // Subject removed
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'คำอธิบาย',
                hintText: 'อธิบายเกี่ยวกับกลุ่มศึกษา',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            // Location and schedule removed
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ยกเลิก'),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.trim().isNotEmpty) {
              _createStudyGroup(
                context: context,
                name: nameController.text.trim(),
                description: descriptionController.text.trim(),
              );
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('กรุณาใส่ชื่อกลุ่ม')),
              );
            }
          },
          child: const Text('สร้างกลุ่ม'),
        ),
      ],
    );
  }

  void _createStudyGroup({
    required BuildContext context,
    required String name,
    required String description,
  }) {
    // Create StudyGroup entity
    // Determine creator id from AuthBloc if available
    String creatorId = 'anonymous';
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      creatorId = authState.profile.id;
    }

    final studyGroup = StudyGroup(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
  subject: '',
      description: description.isEmpty ? 'ไม่มีคำอธิบาย' : description,
      category: 'general',
      difficulty: 'beginner',
  location: '',
  schedule: '',
      maxMembers: null, // No member limit
      memberIds: null, // No member tracking
      createdBy: creatorId,
      createdAt: DateTime.now(),
      isActive: true,
    );
    
    // Create new study group and add to BLoC
    context.read<StudyGroupBloc>().add(CreateStudyGroupEvent(studyGroup));
  // Trigger refresh (in case current state isn't the streaming list for some reason)
  context.read<StudyGroupBloc>().add(GetStudyGroupsEvent());
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('สร้างกลุ่มศึกษาเรียบร้อยแล้ว')),
    );
  }
}
