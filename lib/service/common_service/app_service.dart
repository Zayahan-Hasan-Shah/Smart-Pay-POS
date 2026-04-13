import 'package:flutter/cupertino.dart';

import '../../core/utils/app_colors.dart';

class AppSize {
  static SizedBox vrtSpace(double height) => SizedBox(height: height);

  static SizedBox hrzSpace(double width) => SizedBox(width: width);

  static SizedBox noSpace() => const SizedBox.shrink();

  static Spacer spacer() => const Spacer();
}

///To convert large numbers into a more concise format with suffixes
String formatNumber(int number) {
  List<String> suffixes = ['', 'K', 'M', 'B', 'T'];
  int suffixIndex = 0;
  double formattedNumber = number.toDouble();

  while (formattedNumber >= 1000 && suffixIndex < suffixes.length - 1) {
    formattedNumber /= 1000;
    suffixIndex++;
  }

  String formattedString = formattedNumber.toStringAsFixed(1);
  if (formattedString.endsWith('.0')) {
    formattedString = formattedString.substring(0, formattedString.length - 2);
  }

  return '$formattedString${suffixes[suffixIndex]}';
}

/// make custom card with elevation
BoxDecoration get customCardDecoration {
  return BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.grey.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 10,
        offset: const Offset(0, 10),
      ),
    ],
    color: AppColors.white,
  );
}

BoxDecoration get customMainCardDecoration {
  return BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.grey.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 10,
        offset: const Offset(0, 10),
      ),
    ],
    color: AppColors.white,
  );
}
