import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final bool isClickable;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.boxShadow,
    this.onTap,
    this.isClickable = false,
  });

  // Factory constructors for common card types
  factory AppCard.elevated({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
  }) {
    return AppCard(
      key: key,
      padding: padding ?? const EdgeInsets.all(AppSizes.paddingM),
      margin: margin,
      backgroundColor: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusL),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      onTap: onTap,
      isClickable: onTap != null,
      child: child,
    );
  }

  factory AppCard.outlined({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? borderColor,
    VoidCallback? onTap,
  }) {
    return AppCard(
      key: key,
      padding: padding ?? const EdgeInsets.all(AppSizes.paddingM),
      margin: margin,
      backgroundColor: AppColors.surface,
      borderColor: borderColor ?? AppColors.border,
      borderWidth: 1,
      borderRadius: BorderRadius.circular(AppSizes.radiusL),
      onTap: onTap,
      isClickable: onTap != null,
      child: child,
    );
  }

  factory AppCard.filled({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    VoidCallback? onTap,
  }) {
    return AppCard(
      key: key,
      padding: padding ?? const EdgeInsets.all(AppSizes.paddingM),
      margin: margin,
      backgroundColor: backgroundColor ?? AppColors.grey50,
      borderRadius: BorderRadius.circular(AppSizes.radiusL),
      onTap: onTap,
      isClickable: onTap != null,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget cardWidget = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth ?? 1,
              )
            : null,
        borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusM),
        boxShadow: boxShadow,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSizes.paddingM),
        child: child,
      ),
    );

    if (isClickable && onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusM),
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }
}

class AppListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final bool isThreeLine;
  final bool? dense;
  final Color? tileColor;

  const AppListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
    this.isThreeLine = false,
    this.dense,
    this.tileColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingM,
            vertical: AppSizes.paddingS,
          ),
      isThreeLine: isThreeLine,
      dense: dense,
      tileColor: tileColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
    );
  }
}
