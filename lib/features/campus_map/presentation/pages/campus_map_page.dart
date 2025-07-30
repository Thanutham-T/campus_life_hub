import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimens.dart';
import '../../../../core/widgets/custom_bottom_navigation_bar.dart';

class CampusMapPage extends StatelessWidget {
  const CampusMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => context.go('/'),
        ),
        title: const Text(
          'Campus Map',
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: AppDimens.fontLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingMedium),
          child: const Center(
            child: Text(
              'Campus map details go here.',
              style: TextStyle(
                fontSize: AppDimens.fontLarge,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: -1, // No tab highlighted
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/announcements');
              break;
            case 2:
              // Navigate to profile when implemented
              break;
          }
        },
      ),
    );
  }
}

