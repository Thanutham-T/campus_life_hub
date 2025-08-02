import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimens.dart';
import '../../data/repositories/event_repository.dart';
import '../../domain/entities/event_model.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimens.paddingMedium),
        itemCount: EventRepository.getAllEvents().length,
        itemBuilder: (context, index) {
          final event = EventRepository.getAllEvents()[index];
          return Container(
            margin: const EdgeInsets.only(bottom: AppDimens.marginMedium),
            child: _buildSimpleEventCard(event),
          );
        },
      ),
    );
  }

  Widget _buildSimpleEventCard(Event event) {
    return Card(
      elevation: AppDimens.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Event Image
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimens.radiusMedium),
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ภาพกิจกรรม',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppDimens.fontMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Event Content
          Padding(
            padding: const EdgeInsets.all(AppDimens.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Event Title
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: AppDimens.fontLarge,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Event Description
                Text(
                  event.description,
                  style: const TextStyle(
                    fontSize: AppDimens.fontSmall,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Date and Status Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Event Date
                    Text(
                      _formatDate(event.date),
                      style: const TextStyle(
                        fontSize: AppDimens.fontMedium,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    
                    // Event Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(event.status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(event.status).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getStatusText(event.status),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(event.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return AppColors.orangeGradientStart;
      case EventStatus.ongoing:
        return AppColors.greenGradientStart;
      case EventStatus.completed:
        return AppColors.textSecondary;
      case EventStatus.cancelled:
        return AppColors.redGradientStart;
    }
  }

  String _getStatusText(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return 'เร็วๆ นี้';
      case EventStatus.ongoing:
        return 'กำลังดำเนินการ';
      case EventStatus.completed:
        return 'เสร็จสิ้น';
      case EventStatus.cancelled:
        return 'ยกเลิก';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'วันนี้';
    } else if (difference == 1) {
      return 'พรุ่งนี้';
    } else if (difference > 1 && difference <= 7) {
      return 'ใน $difference วัน';
    } else {
      // Format as Thai date
      final months = [
        'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
        'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year + 543}';
    }
  }
}

