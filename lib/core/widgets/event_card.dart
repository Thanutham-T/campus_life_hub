import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/app_theme.dart';
import '../../core/constants/dimens.dart';
import '../../features/campus_event/domain/entities/event_model.dart';
import '../../core/utils/event_image_helper.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;
  final bool showFullInfo;
  final double? width;
  final double? height;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.showFullInfo = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            context.push('/events');
          },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppColors.textSecondary.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimens.radiusMedium),
                topRight: Radius.circular(AppDimens.radiusMedium),
              ),
              child: EventImageHelper.buildEventImage(
                imageUrl: event.imageUrl,
                eventId: event.id,
                eventTitle: event.title,
                width: width,
                height: showFullInfo ? (width != null && width! > 300 ? 140 : 120) : 80,
                fit: BoxFit.cover,
              ),
            ),
            
            // Event Content
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(showFullInfo && width != null && width! > 300 
                    ? AppDimens.paddingMedium 
                    : AppDimens.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Event Status Badge
                    if (showFullInfo) _buildStatusBadge(),
                    
                    // Event Title
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: showFullInfo && width != null && width! > 300 
                            ? AppDimens.fontLarge 
                            : (showFullInfo ? AppDimens.fontMedium : AppDimens.fontSmall),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: showFullInfo ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Event Date
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _formatDate(event.date),
                            style: TextStyle(
                              fontSize: AppDimens.fontSmall,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    // Event Location (if showing full info)
                    if (showFullInfo && event.location.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location,
                              style: TextStyle(
                                fontSize: AppDimens.fontSmall,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    // Event Description (if showing full info)
                    if (showFullInfo && event.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: TextStyle(
                          fontSize: AppDimens.fontSmall,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    // Category Badge (bottom)
                    if (showFullInfo) ...[
                      const Spacer(),
                      _buildCategoryBadge(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color statusColor;
    String statusText;

    switch (event.status) {
      case EventStatus.upcoming:
        statusColor = AppColors.orangeGradientStart;
        statusText = 'เร็วๆ นี้';
        break;
      case EventStatus.ongoing:
        statusColor = AppColors.greenGradientStart;
        statusText = 'กำลังดำเนินการ';
        break;
      case EventStatus.completed:
        statusColor = AppColors.textSecondary;
        statusText = 'เสร็จสิ้น';
        break;
      case EventStatus.cancelled:
        statusColor = AppColors.redGradientStart;
        statusText = 'ยกเลิก';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: statusColor,
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    String categoryText;
    Color categoryColor = AppColors.navigationActive;

    switch (event.category) {
      case EventCategory.competition:
        categoryText = 'การแข่งขัน';
        categoryColor = AppColors.orangeGradientStart;
        break;
      case EventCategory.academic:
        categoryText = 'วิชาการ';
        categoryColor = AppColors.redGradientStart;
        break;
      case EventCategory.sports:
        categoryText = 'กีฬา';
        categoryColor = AppColors.greenGradientStart;
        break;
      case EventCategory.cultural:
        categoryText = 'วัฒนธรรม';
        categoryColor = AppColors.primaryBlue;
        break;
      case EventCategory.general:
        categoryText = 'ทั่วไป';
        categoryColor = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: categoryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        categoryText,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: categoryColor,
        ),
      ),
    );
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
