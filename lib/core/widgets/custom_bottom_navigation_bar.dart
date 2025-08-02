import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
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
              label: 'Home',
              index: 0,
              isActive: currentIndex == 0,
            ),
            _buildNavItem(
              icon: Icons.calendar_today,
              label: 'Schedule',
              index: 1,
              isActive: currentIndex == 1,
            ),
            _buildNavItem(
              icon: Icons.calendar_month,
              label: 'Events',
              index: 2,
              isActive: currentIndex == 2,
            ),
            _buildNavItem(
              icon: Icons.groups,
              label: 'Groups',
              index: 3,
              isActive: currentIndex == 3,
            ),
            _buildNavItem(
              icon: Icons.campaign,
              label: 'News',
              index: 4,
              isActive: currentIndex == 4,
            ),
            _buildNavItem(
              icon: Icons.map,
              label: 'Map',
              index: 5,
              isActive: currentIndex == 5,
            ),
            _buildNavItem(
              icon: Icons.person,
              label: 'Profile',
              index: 6,
              isActive: currentIndex == 6,
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
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            border: isActive
                ? const Border(
                    top: BorderSide(
                      color: AppColors.textWhite,
                      width: 3.0,
                    ),
                  )
                : null,
          ),
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
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
