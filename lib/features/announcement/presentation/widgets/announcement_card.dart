import 'package:flutter/material.dart';
import '../../domain/entities/announcement.dart';

/// Widget for displaying announcement card
class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    this.onTap,
    this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      announcement.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: announcement.isRead ? Colors.grey[600] : Colors.black,
                      ),
                    ),
                  ),
                  _buildPriorityBadge(),
                  if (!announcement.isRead) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                announcement.content,
                style: TextStyle(
                  fontSize: 14,
                  color: announcement.isRead ? Colors.grey[600] : Colors.grey[800],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildCategoryChip(),
                  const Spacer(),
                  Text(
                    _formatDate(announcement.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge() {
    Color color;
    IconData icon;
    
    switch (announcement.priority.toLowerCase()) {
      case 'high':
        color = Colors.red;
        icon = Icons.priority_high;
        break;
      case 'medium':
        color = Colors.orange;
        icon = Icons.remove;
        break;
      case 'low':
        color = Colors.green;
        icon = Icons.arrow_downward;
        break;
      default:
        color = Colors.grey;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            _getPriorityText(),
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _getCategoryText(),
        style: const TextStyle(
          fontSize: 10,
          color: Colors.blue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getPriorityText() {
    switch (announcement.priority.toLowerCase()) {
      case 'high':
        return 'สำคัญมาก';
      case 'medium':
        return 'ปานกลาง';
      case 'low':
        return 'น้อย';
      default:
        return 'ปกติ';
    }
  }

  String _getCategoryText() {
    switch (announcement.category.toLowerCase()) {
      case 'academic':
        return 'วิชาการ';
      case 'scholarship':
        return 'ทุนการศึกษา';
      case 'event':
        return 'กิจกรรม';
      case 'system':
        return 'ระบบ';
      default:
        return 'ทั่วไป';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'วันนี้';
    } else if (difference == 1) {
      return 'เมื่อวาน';
    } else if (difference < 7) {
      return '$difference วันที่แล้ว';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
