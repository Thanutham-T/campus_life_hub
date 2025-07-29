import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

enum AppDialogType {
  success,
  warning,
  error,
  info,
  custom,
}

class AppDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final Widget? customContent;
  final AppDialogType type;
  final List<Widget>? actions;
  final bool barrierDismissible;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;

  const AppDialog({
    super.key,
    this.title,
    this.content,
    this.customContent,
    this.type = AppDialogType.custom,
    this.actions,
    this.barrierDismissible = true,
    this.contentPadding,
    this.actionsPadding,
  });

  // Factory constructors for common dialog types
  static Future<T?> showSuccess<T>({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AppDialog(
        type: AppDialogType.success,
        title: title,
        content: message,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(confirmText ?? 'ตกลง'),
          ),
        ],
      ),
    );
  }

  static Future<T?> showError<T>({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AppDialog(
        type: AppDialogType.error,
        title: title,
        content: message,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(confirmText ?? 'ตกลง'),
          ),
        ],
      ),
    );
  }

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    AppDialogType type = AppDialogType.warning,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
        type: type,
        title: title,
        content: message,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText ?? 'ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText ?? 'ยืนยัน'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: _buildIcon(),
      title: title != null ? Text(title!) : null,
      content: _buildContent(),
      actions: actions,
      contentPadding: contentPadding ??
          const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
      actionsPadding: actionsPadding ??
          const EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
    );
  }

  Widget? _buildIcon() {
    switch (type) {
      case AppDialogType.success:
        return Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: AppSizes.iconXL,
        );
      case AppDialogType.warning:
        return Icon(
          Icons.warning,
          color: AppColors.warning,
          size: AppSizes.iconXL,
        );
      case AppDialogType.error:
        return Icon(
          Icons.error,
          color: AppColors.error,
          size: AppSizes.iconXL,
        );
      case AppDialogType.info:
        return Icon(
          Icons.info,
          color: AppColors.info,
          size: AppSizes.iconXL,
        );
      case AppDialogType.custom:
        return null;
    }
  }

  Widget? _buildContent() {
    if (customContent != null) {
      return customContent;
    }

    if (content != null) {
      return Text(
        content!,
        style: TextStyle(
          color: AppColors.grey700,
          height: 1.5,
        ),
      );
    }

    return null;
  }
}

class AppBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showDragHandle;
  final bool isScrollControlled;
  final EdgeInsetsGeometry? padding;

  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.showDragHandle = true,
    this.isScrollControlled = false,
    this.padding,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool showDragHandle = true,
    bool isScrollControlled = false,
    EdgeInsetsGeometry? padding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXL),
        ),
      ),
      builder: (context) => AppBottomSheet(
        title: title,
        showDragHandle: showDragHandle,
        isScrollControlled: isScrollControlled,
        padding: padding,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          EdgeInsets.only(
            left: AppSizes.paddingM,
            right: AppSizes.paddingM,
            top: AppSizes.paddingM,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.paddingM,
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle) _buildDragHandle(),
          if (title != null) _buildTitle(context),
          child,
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceL),
      child: Text(
        title!,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
