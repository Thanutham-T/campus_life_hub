import 'package:flutter/material.dart';
import '../constants/constants.dart';

class AppDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final IconData? prefixIcon;
  final String? hint;
  final String? Function(String?)? validator;
  final bool enabled;

  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.prefixIcon,
    this.hint,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.grey700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSizes.spaceXS),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                border: Border.all(
                  color: AppColors.grey300,
                  width: 1,
                ),
                color: enabled ? AppColors.backgroundWhite : AppColors.grey100,
              ),
              child: DropdownButtonFormField<String>(
                value: value,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth - 80, // พื้นที่สำหรับ icon และ padding
                      ),
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: enabled ? AppColors.grey800 : AppColors.grey500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: enabled ? onChanged : null,
                validator: validator,
                decoration: InputDecoration(
                  prefixIcon: prefixIcon != null
                      ? Icon(
                          prefixIcon,
                          color: enabled ? AppColors.grey600 : AppColors.grey400,
                          size: 20,
                        )
                      : null,
                  hintText: hint,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey500,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: prefixIcon != null ? AppSizes.paddingS : AppSizes.paddingM,
                    vertical: AppSizes.paddingM,
                  ),
                  isDense: true,
                ),
                dropdownColor: AppColors.backgroundWhite,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: enabled ? AppColors.grey600 : AppColors.grey400,
                ),
                iconSize: 24,
                isExpanded: true,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: enabled ? AppColors.grey800 : AppColors.grey500,
                ),
                // ปรับขนาด dropdown menu ให้เหมาะกับหน้าจอ
                menuMaxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
            );
          },
        ),
      ],
    );
  }
}

// Widget สำหรับ dropdown ที่มี dependency (เช่น สาขาวิชาขึ้นอยู่กับคณะ)
class AppDependentDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final IconData? prefixIcon;
  final String? hint;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? dependentValue; // ค่าที่ต้องเลือกก่อน
  final String dependentLabel; // ชื่อของ field ที่ต้องเลือกก่อน

  const AppDependentDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.prefixIcon,
    this.hint,
    this.validator,
    this.enabled = true,
    this.dependentValue,
    required this.dependentLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabledWithDependency = enabled && dependentValue != null && dependentValue!.isNotEmpty;
    final effectiveItems = isEnabledWithDependency ? items : <String>[];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.grey700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSizes.spaceXS),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                border: Border.all(
                  color: isEnabledWithDependency ? AppColors.grey300 : AppColors.grey200,
                  width: 1,
                ),
                color: isEnabledWithDependency ? AppColors.backgroundWhite : AppColors.grey100,
              ),
              child: DropdownButtonFormField<String>(
                value: isEnabledWithDependency && effectiveItems.contains(value) ? value : null,
                items: effectiveItems.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth - 80,
                      ),
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isEnabledWithDependency ? AppColors.grey800 : AppColors.grey500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: isEnabledWithDependency ? onChanged : null,
                validator: validator,
                decoration: InputDecoration(
                  prefixIcon: prefixIcon != null
                      ? Icon(
                          prefixIcon,
                          color: isEnabledWithDependency ? AppColors.grey600 : AppColors.grey400,
                          size: 20,
                        )
                      : null,
                  hintText: isEnabledWithDependency 
                      ? hint 
                      : 'กรุณาเลือก$dependentLabelก่อน',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey500,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: prefixIcon != null ? AppSizes.paddingS : AppSizes.paddingM,
                    vertical: AppSizes.paddingM,
                  ),
                  isDense: true,
                ),
                dropdownColor: AppColors.backgroundWhite,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: isEnabledWithDependency ? AppColors.grey600 : AppColors.grey400,
                ),
                iconSize: 24,
                isExpanded: true,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isEnabledWithDependency ? AppColors.grey800 : AppColors.grey500,
                ),
                menuMaxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
            );
          },
        ),
      ],
    );
  }
}
