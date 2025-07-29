import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';
import '../constants/dimens.dart';
import '../../features/dashboard/domain/entities/tool_item.dart';

class ToolCard extends StatelessWidget {
  final ToolItem toolItem;

  const ToolCard({
    super.key,
    required this.toolItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: AppDimens.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      ),
      child: InkWell(
        onTap: toolItem.onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        child: Container(
          width: 90,
          height: 90,
          padding: const EdgeInsets.all(AppDimens.paddingSmall),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: toolItem.backgroundColor,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                ),
                child: Icon(
                  toolItem.icon,
                  color: AppColors.iconWhite,
                  size: 28.0,
                ),
              ),
              const SizedBox(height: 6.0),
              Text(
                toolItem.title,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
