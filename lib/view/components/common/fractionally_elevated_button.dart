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
          elevation: 0,
          side: const BorderSide(color: AppColors.black),
          visualDensity: const VisualDensity(
            vertical: 2,
            horizontal: 2,
          ),
        ),
        onPressed: onTap,
        child: child,
      ),
    );
  }
}
