import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final int? maxLines;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final double? borderRadius;
  final double? borderWidth;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final Color? fillColor;
  final Color? cursorColor;
  final Color? textColor;
  final Color? hintTextColor;

  const CustomTextField({
    super.key,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
    this.maxLines = 1,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.borderColor,
    this.borderRadius,
    this.hintText,
    this.inputFormatters,
    this.onChanged,
    this.fillColor,
    this.hintTextColor,
    this.textColor,
    this.borderWidth,
    this.cursorColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: cursorColor,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      readOnly: readOnly,
      style: TextStyle(color: textColor ?? Colors.black),
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: inputFormatters ?? [],
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? Colors.transparent,
        hintText: hintText ?? '',
        hintStyle: TextStyle(
          fontSize: 12,
          color: hintTextColor ?? Colors.black54,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // rounded corners
          borderSide: BorderSide(
            color: borderColor ?? Colors.black38,
            width: borderWidth ?? 0,
          ), // remove border line
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: borderColor ?? Colors.black38,
            width: borderWidth ?? 0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: borderColor ?? Colors.black38,
            width: borderWidth ?? 0,
          ),
        ),
      ),
    );
  }
}
