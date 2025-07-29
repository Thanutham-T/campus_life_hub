import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

enum AppButtonType { primary, secondary, outline, text, danger }
enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final bool iconAtEnd;
  final double? customWidth;
  final double? customHeight;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconAtEnd = false,
    this.customWidth,
    this.customHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : customWidth,
      height: customHeight ?? _getHeight(),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getButtonStyle(context),
        child: isLoading ? _buildLoadingWidget() : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (icon == null) {
      return Text(text);
    }

    final iconWidget = Icon(icon, size: _getIconSize());
    final textWidget = Text(text);

    if (iconAtEnd) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          textWidget,
          const SizedBox(width: AppSizes.spaceS),
          iconWidget,
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(width: AppSizes.spaceS),
          textWidget,
        ],
      );
    }
  }

  Widget _buildLoadingWidget() {
    return SizedBox(
      height: _getIconSize(),
      width: _getIconSize(),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(_getLoadingColor()),
      ),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.grey300,
          disabledForegroundColor: AppColors.grey600,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          textStyle: _getTextStyle(theme),
        );

      case AppButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.onSecondary,
          disabledBackgroundColor: AppColors.grey300,
          disabledForegroundColor: AppColors.grey600,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          textStyle: _getTextStyle(theme),
        );

      case AppButtonType.outline:
        return OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.grey600,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          textStyle: _getTextStyle(theme),
        );

      case AppButtonType.text:
        return TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.grey600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          textStyle: _getTextStyle(theme),
        );

      case AppButtonType.danger:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.grey300,
          disabledForegroundColor: AppColors.grey600,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          textStyle: _getTextStyle(theme),
        );
    }
  }

  TextStyle _getTextStyle(ThemeData theme) {
    switch (size) {
      case AppButtonSize.small:
        return theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(fontWeight: FontWeight.w600);
      case AppButtonSize.medium:
        return theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(fontWeight: FontWeight.w600);
      case AppButtonSize.large:
        return theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(fontWeight: FontWeight.w600);
    }
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return AppSizes.buttonHeightS;
      case AppButtonSize.medium:
        return AppSizes.buttonHeightM;
      case AppButtonSize.large:
        return AppSizes.buttonHeightL;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return AppSizes.iconS;
      case AppButtonSize.medium:
        return AppSizes.iconM;
      case AppButtonSize.large:
        return AppSizes.iconL;
    }
  }

  Color _getLoadingColor() {
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
      case AppButtonType.danger:
        return Colors.white;
      case AppButtonType.outline:
      case AppButtonType.text:
        return AppColors.primary;
    }
  }
}
