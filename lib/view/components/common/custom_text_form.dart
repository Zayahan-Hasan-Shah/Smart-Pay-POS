import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/utils/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {super.key,
      required this.controller,
      this.onTap,
      this.autovalidateMode,
      required this.obscureText,
      this.onSuffixTap,
      this.onChanged,
      this.filled,
      this.inputFormatters,
      this.hint,
      this.maxLines,
      this.keyboardType,
      this.prefixIcon,
      this.validator,
      this.suffix,
      this.value = false});

  final VoidCallback? onTap;
  final VoidCallback? onSuffixTap;
  final Function(String? value)? onChanged;
  final String? Function(String? value)? validator;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool? filled;
  final String? hint;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final bool value;
  final Widget? suffix;

  final AutovalidateMode? autovalidateMode;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: value,
      controller: controller,
      onTap: onTap ?? () {},
      onChanged: onChanged ?? (v) {},
      validator: validator,
      keyboardType: keyboardType,
      autovalidateMode: autovalidateMode,
      inputFormatters: inputFormatters,
      maxLines: obscureText == null ? maxLines : 1,
      obscureText: obscureText,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: onSuffixTap,
                icon: suffix ?? const Icon(Icons.check_circle_outline),
              )
            : null,
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textHint,
          fontSize: 15,
        ),
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.errorColor,
            width: 2,
          ),
        ),
        fillColor: AppColors.primaryColor.withOpacity(0.05),
        filled: true,
        errorStyle: const TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.errorColor,
        ),
      ),
      obscuringCharacter: "•",
    );
  }
}
