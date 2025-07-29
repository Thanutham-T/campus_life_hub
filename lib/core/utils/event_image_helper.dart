import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';
import '../constants/dimens.dart';

class EventImageHelper {
  // Build event image widget with placeholder
  static Widget buildEventImage({
    String? imageUrl,
    required String eventId,
    required String eventTitle,
    BorderRadius? borderRadius,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: _getGradientForEvent(eventId),
      ),
      child: Stack(
        children: [
          // Background pattern or icon
          Center(
            child: Icon(
              _getIconForEvent(eventId),
              size: 48,
              color: AppColors.textWhite.withValues(alpha: 0.3),
            ),
          ),
          // Image placeholder overlay
          if (imageUrl == null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 32,
                    color: AppColors.textWhite.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ภาพกิจกรรม',
                    style: TextStyle(
                      color: AppColors.textWhite.withValues(alpha: 0.8),
                      fontSize: AppDimens.fontSmall,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          // If imageUrl is provided, show network image
          if (imageUrl != null)
            ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: Image.network(
                imageUrl,
                width: width,
                height: height,
                fit: fit,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      gradient: _getGradientForEvent(eventId),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            size: 32,
                            color: AppColors.textWhite.withValues(alpha: 0.7),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ไม่สามารถโหลดรูปได้',
                            style: TextStyle(
                              color: AppColors.textWhite.withValues(alpha: 0.8),
                              fontSize: AppDimens.fontSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      color: AppColors.backgroundGrey,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.navigationActive,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // Get gradient based on event ID or category
  static LinearGradient _getGradientForEvent(String eventId) {
    final int hash = eventId.hashCode.abs();
    final int gradientIndex = hash % 3;

    switch (gradientIndex) {
      case 0:
        return LinearGradient(
          colors: [AppColors.orangeGradientStart, AppColors.orangeGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 1:
        return LinearGradient(
          colors: [AppColors.redGradientStart, AppColors.redGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2:
        return LinearGradient(
          colors: [AppColors.greenGradientStart, AppColors.greenGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [AppColors.navigationActive, AppColors.primaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  // Get icon based on event ID
  static IconData _getIconForEvent(String eventId) {
    final int hash = eventId.hashCode.abs();
    final int iconIndex = hash % 6;

    switch (iconIndex) {
      case 0:
        return Icons.emoji_events;
      case 1:
        return Icons.menu_book;
      case 2:
        return Icons.directions_run;
      case 3:
        return Icons.palette;
      case 4:
        return Icons.group;
      case 5:
        return Icons.celebration;
      default:
        return Icons.event;
    }
  }

  // Get category-specific gradient
  static LinearGradient getGradientForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'competition':
      case 'การแข่งขันกีฬา':
        return LinearGradient(
          colors: [AppColors.orangeGradientStart, AppColors.orangeGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'academic':
      case 'การอบรมให้ความรู้':
        return LinearGradient(
          colors: [AppColors.redGradientStart, AppColors.redGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'sports':
      case 'กิจกรรมกีฬา':
        return LinearGradient(
          colors: [AppColors.greenGradientStart, AppColors.greenGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [AppColors.navigationActive, AppColors.primaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}
