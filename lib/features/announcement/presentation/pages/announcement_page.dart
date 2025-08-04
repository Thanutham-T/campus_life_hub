import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimens.dart';

class AnnouncementPage extends StatelessWidget {
  final bool showBackButton;
  final bool showBottomNav;
  
  const AnnouncementPage({
    super.key,
    this.showBackButton = false,
    this.showBottomNav = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingMedium),
        child: Center(
          child: Text(
            'Announcement details go here.',
            style: const TextStyle(
              fontSize: AppDimens.fontLarge,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
