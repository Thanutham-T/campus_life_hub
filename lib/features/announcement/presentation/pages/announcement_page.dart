import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimens.dart';
import '../../../../core/widgets/custom_bottom_navigation_bar.dart';

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
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        leading: showBackButton ? IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => context.go('/'),
        ) : null,
        title: const Text(
          'Announcements',
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: AppDimens.fontLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: showBackButton,
      ),
      body: SafeArea(
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
      ),
      bottomNavigationBar: showBottomNav ? CustomBottomNavigationBar(
        currentIndex: -1, // No tab highlighted when standalone
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/'); // Go back to main screen
              break;
            case 2:
              // Navigate to profile when implemented
              break;
          }
        },
      ) : null,
    );
  }
}
