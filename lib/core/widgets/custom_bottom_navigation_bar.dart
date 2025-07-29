import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';
import '../constants/strings.dart';
import '../constants/dimens.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: AppDimens.bottomNavHeight,
        decoration: const BoxDecoration(
          color: AppColors.navigationActive,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: Icons.home,
              label: AppStrings.home,
              index: 0,
              isActive: currentIndex == 0,
            ),
            _buildNavItem(
              icon: Icons.notifications,
              label: AppStrings.notifications,
              index: 1,
              isActive: currentIndex == 1,
            ),
            _buildNavItem(
              icon: Icons.person,
              label: AppStrings.profile,
              index: 2,
              isActive: currentIndex == 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.textWhite : AppColors.navigationInactive,
            size: AppDimens.iconMedium,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.textWhite : AppColors.navigationInactive,
              fontSize: AppDimens.fontSmall,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
