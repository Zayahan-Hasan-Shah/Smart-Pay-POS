
import 'package:flutter/material.dart';
import 'package:pos/view/components/common/title_text.dart';

import '../../../core/utils/app_colors.dart';

class ClearButton extends StatelessWidget {
  var title;
   ClearButton({super.key, required this.onPressed, this.title});

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.4,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: TitleText(
          title: title ?? "Clear",
          weight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
    );
  }
}
