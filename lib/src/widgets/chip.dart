import 'package:flutter/material.dart';
import 'package:mood_ai/core/theme/theme_constants.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final void Function(bool) onSelected;

  const AppChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      padding: EdgeInsets.all(12),
      showCheckmark: false,
      label: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isSelected ? AppColors.primary_500 : AppColors.dark_900,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        onSelected(selected);
      },
      backgroundColor: Colors.transparent,
      selectedColor: AppColors.primary_200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
        side: BorderSide(
          width: 1,
          color: isSelected ? AppColors.primary_500 : AppColors.dark_300,
        ),
      ),
    );
  }
}
