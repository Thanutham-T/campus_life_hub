import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'app_button.dart';

class EmptyState extends StatelessWidget {
  final String? title;
  final String? description;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final Widget? icon;
  final String? imagePath;

  const EmptyState({
    super.key,
    this.title,
    this.description,
    this.buttonText,
    this.onButtonPressed,
    this.icon,
    this.imagePath,
  });

  const EmptyState.noData({
    super.key,
    this.title = 'ไม่มีข้อมูล',
    this.description = 'ยังไม่มีข้อมูลที่จะแสดง',
    this.buttonText,
    this.onButtonPressed,
    this.icon,
    this.imagePath,
  });

  const EmptyState.noResults({
    super.key,
    this.title = 'ไม่พบผลการค้นหา',
    this.description = 'ลองเปลี่ยนคำค้นหาหรือตัวกรองของคุณ',
    this.buttonText = 'ค้นหาใหม่',
    this.onButtonPressed,
    this.icon,
    this.imagePath,
  });

  const EmptyState.error({
    super.key,
    this.title = 'เกิดข้อผิดพลาด',
    this.description = 'ไม่สามารถโหลดข้อมูลได้ กรุณาลองใหม่อีกครั้ง',
    this.buttonText = 'ลองใหม่',
    this.onButtonPressed,
    this.icon,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImage(),
            const SizedBox(height: AppSizes.spaceL),
            if (title != null) _buildTitle(context),
            if (description != null) _buildDescription(context),
            if (buttonText != null && onButtonPressed != null) _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: 120,
        height: 120,
        fit: BoxFit.contain,
      );
    }

    if (icon != null) {
      return icon!;
    }

    return Icon(
      Icons.inbox_outlined,
      size: 80,
      color: AppColors.grey400,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      children: [
        Text(
          title!,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.grey700,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.spaceM),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      children: [
        Text(
          description!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.grey600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.spaceXL),
      ],
    );
  }

  Widget _buildButton() {
    return AppButton(
      text: buttonText!,
      onPressed: onButtonPressed,
      type: AppButtonType.outline,
    );
  }
}
