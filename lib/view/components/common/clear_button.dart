

import 'package:flutter/material.dart';
import 'package:pos/view/components/common/title_text.dart';

import '../../../core/utils/app_colors.dart';

class ClearButton extends StatelessWidget {
  final title;
  const ClearButton({super.key, required this.onPressed, this.title});

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.4,
      child: ElevatedButton(
        // widthFactor: 0.5,
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
        onPressed: onPressed,
        child: TitleText(
          title: title ?? "Clear",
          weight: FontWeight.w500,
          color: AppColors.white,
        ),
      ),
    );
  }
}
