import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/announcement.dart';

class AnnouncementDetailPage extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementDetailPage({
    super.key,
    required this.announcement,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รายละเอียดข่าวประกาศ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with gradient
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1976D2),
                    Color(0xFF1565C0),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category and priority chips
                    Row(
                      children: [
                        _buildCategoryChip(),
                        const SizedBox(width: 12),
                        _buildPriorityChip(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Title
                    Text(
                      announcement.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Date and read status
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 18,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('วันที่ dd MMMM yyyy เวลา HH:mm น.', 'th')
                              .format(announcement.date),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Content section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content header
                  const Text(
                    'รายละเอียด',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Content text
                  Text(
                    announcement.content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Additional info section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ข้อมูลเพิ่มเติม',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        _buildInfoRow(
                          'หมวดหมู่',
                          _getCategoryName(),
                          Icons.category_outlined,
                        ),
                        const SizedBox(height: 8),
                        
                        _buildInfoRow(
                          'ระดับความสำคัญ',
                          _getPriorityName(),
                          Icons.priority_high_outlined,
                        ),
                        const SizedBox(height: 8),
                        
                        _buildInfoRow(
                          'สถานะการอ่าน',
                          announcement.isRead ? 'อ่านแล้ว' : 'ยังไม่ได้อ่าน',
                          announcement.isRead 
                              ? Icons.mark_email_read_outlined
                              : Icons.mark_email_unread_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip() {
    final categoryInfo = _getCategoryInfo();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            categoryInfo['icon'],
            size: 16,
            color: categoryInfo['color'],
          ),
          const SizedBox(width: 6),
          Text(
            categoryInfo['name'],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: categoryInfo['color'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getPriorityColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getPriorityName(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF1976D2),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getCategoryInfo() {
    switch (announcement.category) {
      case 'academic':
        return {
          'name': 'วิชาการ',
          'color': const Color(0xFF2196F3),
          'icon': Icons.school_outlined,
        };
      case 'event':
        return {
          'name': 'กิจกรรม',
          'color': const Color(0xFF4CAF50),
          'icon': Icons.event_outlined,
        };
      case 'general':
        return {
          'name': 'ทั่วไป',
          'color': const Color(0xFF9C27B0),
          'icon': Icons.info_outlined,
        };
      default:
        return {
          'name': 'อื่นๆ',
          'color': const Color(0xFF607D8B),
          'icon': Icons.announcement_outlined,
        };
    }
  }

  String _getCategoryName() {
    switch (announcement.category) {
      case 'academic':
        return 'วิชาการ';
      case 'event':
        return 'กิจกรรม';
      case 'general':
        return 'ทั่วไป';
      default:
        return 'อื่นๆ';
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

  String _getPriorityName() {
    switch (announcement.priority) {
      case 'high':
        return 'สำคัญมาก';
      case 'medium':
        return 'สำคัญ';
      case 'low':
        return 'ทั่วไป';
      default:
        return 'ไม่ระบุ';
    }
  }
}
