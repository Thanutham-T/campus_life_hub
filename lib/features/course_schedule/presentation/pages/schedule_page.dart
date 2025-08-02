import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimens.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingMedium),
        child: const Center(
          child: Text(
            'Schedule details go here.',
            style: TextStyle(
              fontSize: AppDimens.fontLarge,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

