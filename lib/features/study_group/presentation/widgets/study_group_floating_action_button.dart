import 'package:flutter/material.dart';
import 'create_group_dialog.dart';

class StudyGroupFloatingActionButton extends StatelessWidget {
  const StudyGroupFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        CreateGroupDialog.show(context);
      },
      child: const Icon(Icons.add),
    );
  }
}
