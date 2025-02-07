import 'package:flutter/material.dart';
import 'package:mood_ai/core/theme/theme_constants.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final TextEditingController? controller;
  final bool isDense;
  final bool isExpanded;
  final bool isFilled;
  final ValueChanged<String>? onChanged;
  const AppTextField({
    super.key,
    this.hintText = '',
    this.maxLines = 4,
    this.controller,
    this.isDense = false,
    this.isExpanded = false,
    this.isFilled = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      controller: controller ?? TextEditingController(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.dark_500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.dark_300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.dark_300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary_500),
        ),
      ),
    );
  }
}
