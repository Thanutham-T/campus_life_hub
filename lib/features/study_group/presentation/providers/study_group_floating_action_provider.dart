import 'package:flutter/material.dart';
import '../widgets/study_group_floating_action_button.dart';

class StudyGroupFloatingActionProvider {
  /// ตรวจสอบว่าควรแสดง FloatingActionButton หรือไม่
  static bool shouldShowFloatingAction(String currentRoute) {
    return currentRoute == '/study-groups';
  }

  /// สร้าง FloatingActionButton สำหรับหน้า Study Groups
  static Widget? getFloatingActionButton(String currentRoute) {
    if (shouldShowFloatingAction(currentRoute)) {
      return const StudyGroupFloatingActionButton();
    }
    return null;
  }

  /// กำหนดตำแหน่งของ FloatingActionButton
  static FloatingActionButtonLocation getFloatingActionButtonLocation(String currentRoute) {
    if (shouldShowFloatingAction(currentRoute)) {
      return FloatingActionButtonLocation.endFloat;
    }
    return FloatingActionButtonLocation.centerFloat;
  }
}
