import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../domain/entities/tool_item.dart';

/// Dashboard DI - Dependency Injection for Dashboard Feature
/// ใช้เก็บ function ทั้งหมดของ Dashboard feature เพื่อความสะดวกตอนที่ต้องการจะเรียกใช้
class DashboardDI {
  
  /// Get all dashboard tools with navigation functionality
  static List<ToolItem> getDashboardTools(BuildContext context) {
    return [
      ToolItem(
        title: 'Campus Events',
        icon: Icons.event,
        backgroundColor: const Color(0xFF2196F3),
        onTap: () => context.go('/events'),
      ),
      ToolItem(
        title: 'Course Schedule',
        icon: Icons.schedule,
        backgroundColor: const Color(0xFF4CAF50),
        onTap: () => context.go('/schedule'),
      ),
      ToolItem(
        title: 'Campus Map',
        icon: Icons.map,
        backgroundColor: const Color(0xFFFF9800),
        onTap: () => context.go('/map'),
      ),
      ToolItem(
        title: 'Study Groups',
        icon: Icons.groups,
        backgroundColor: const Color(0xFF9C27B0),
        onTap: () => context.go('/study-groups'),
      ),
      ToolItem(
        title: 'Announcements',
        icon: Icons.campaign,
        backgroundColor: const Color(0xFFF44336),
        onTap: () => context.go('/announcements'),
      ),
      ToolItem(
        title: 'Profile',
        icon: Icons.person,
        backgroundColor: const Color(0xFF607D8B),
        onTap: () => context.go('/profile'),
      ),
    ];
  }

  /// Get featured tools (first 4 tools)
  static List<ToolItem> getFeaturedTools(BuildContext context) {
    return getDashboardTools(context).take(4).toList();
  }

  /// Get all tools except featured ones
  static List<ToolItem> getOtherTools(BuildContext context) {
    return getDashboardTools(context).skip(4).toList();
  }

  /// Get tool by title
  static ToolItem? getToolByTitle(BuildContext context, String title) {
    try {
      return getDashboardTools(context).firstWhere(
        (tool) => tool.title.toLowerCase() == title.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Navigate to specific tool
  static void navigateToTool(BuildContext context, String toolTitle) {
    final tool = getToolByTitle(context, toolTitle);
    if (tool != null && tool.onTap != null) {
      tool.onTap!();
    }
  }
}
