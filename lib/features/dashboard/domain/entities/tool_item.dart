import 'package:flutter/material.dart';

class ToolItem {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const ToolItem({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    this.onTap,
  });
}
