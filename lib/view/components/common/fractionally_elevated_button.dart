import 'package:flutter/material.dart';

import '../../../core/utils/app_colors.dart';

class FractionallyElevatedButton extends StatelessWidget {
  const FractionallyElevatedButton({
    super.key,
    required this.onTap,
    // this.widthFactor,
    required this.title,
    // this.buttonColor
    this.buttonBackgroundColor,
  });

  final String title;
  // final double? widthFactor;
  final VoidCallback? onTap;
  final Color? buttonBackgroundColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 45,
        decoration: BoxDecoration(
          
          color: buttonBackgroundColor,
          gradient:
              buttonBackgroundColor == null
                  ? LinearGradient(
                    colors: [
                      AppColors.darkGreen,
                      AppColors.lightGreen,
                      // Color(0xFFE8F5E9),
                    ],
                  )
                  : null,

          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
          border: buttonBackgroundColor != null ? Border.all(width: 0.5) : null,
        ),
        child: Align(
          alignment: AlignmentGeometry.center,
          child: Text(
            title,
            style: TextStyle(
              color:
                  buttonBackgroundColor == null ? Colors.white : Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
