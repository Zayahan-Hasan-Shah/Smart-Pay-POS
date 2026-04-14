import 'package:flutter/material.dart';

import '../../../core/utils/app_colors.dart';

class FractionallyElevatedButton extends StatelessWidget {
  const FractionallyElevatedButton({
    super.key,
    required this.onTap,
    this.widthFactor,
    this.child,
    this.buttonBackgroundColor,
  });

  final Widget? child;
  final double? widthFactor;
  final VoidCallback? onTap;
  final Color? buttonBackgroundColor;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor ?? 0.7,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackgroundColor ?? AppColors.primaryColor,
          foregroundColor: AppColors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onTap,
        child: child,
      ),
    );
  }
}
