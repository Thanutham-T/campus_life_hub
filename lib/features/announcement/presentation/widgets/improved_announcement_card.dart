import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/announcement.dart';

/// Improved widget for displaying announcement card with bookmark functionality
class ImprovedAnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final bool isBookmarked;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onBookmarkTap;

  const ImprovedAnnouncementCard({
    super.key,
    required this.announcement,
    this.isBookmarked = false,
    this.onTap,
    this.onMarkAsRead,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getPriorityColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with category, priority, and bookmark
              Row(
                children: [
                  _buildCategoryChip(),
                  const SizedBox(width: 8),
                  _buildPriorityChip(),
                  const Spacer(),
                  if (onBookmarkTap != null)
                    IconButton(
                      onPressed: onBookmarkTap,
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked 
                            ? const Color(0xFF1976D2) 
                            : Colors.grey[600],
                      ),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Title
              Row(
                children: [
                  if (!announcement.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1976D2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      announcement.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: announcement.isRead 
                            ? FontWeight.w500 
                            : FontWeight.bold,
                        color: announcement.isRead 
                            ? Colors.grey[700] 
                            : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Content preview
              Text(
                announcement.content.length > 100
                    ? '${announcement.content.substring(0, 100)}...'
                    : announcement.content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              
              // Date
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
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

  Widget _buildCategoryChip() {
    final categoryInfo = _getCategoryInfo();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: categoryInfo['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: categoryInfo['color'].withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        categoryInfo['name'],
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: categoryInfo['color'],
        ),
      ),
    );
  }

  Widget _buildPriorityChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPriorityColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _getPriorityText(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _getPriorityColor(),
        ),
      ),
    );
  }

  Map<String, dynamic> _getCategoryInfo() {
    switch (announcement.category) {
      case 'academic':
        return {
          'name': 'วิชาการ',
          'color': const Color(0xFF2196F3),
        };
      case 'event':
        return {
          'name': 'กิจกรรม',
          'color': const Color(0xFF4CAF50),
        };
      case 'general':
        return {
          'name': 'ทั่วไป',
          'color': const Color(0xFF9C27B0),
        };
      default:
        return {
          'name': 'อื่นๆ',
          'color': const Color(0xFF607D8B),
        };
    }
  }

  Color _getPriorityColor() {
    switch (announcement.priority) {
      case 'high':
        return const Color(0xFFE53E3E);
      case 'medium':
        return const Color(0xFFED8936);
      case 'low':
        return const Color(0xFF38A169);
      default:
        return const Color(0xFF718096);
    }
  }

  String _getPriorityText() {
    switch (announcement.priority) {
      case 'high':
        return 'สำคัญมาก';
      case 'medium':
        return 'สำคัญ';
      case 'low':
        return 'ทั่วไป';
      default:
        return '';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} นาทีที่แล้ว';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ชั่วโมงที่แล้ว';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} วันที่แล้ว';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm', 'th').format(date);
    }
  }
}
