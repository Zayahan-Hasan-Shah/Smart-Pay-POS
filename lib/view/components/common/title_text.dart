import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/app_colors.dart';


class TitleText extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final double? fontSize;
  final FontWeight? weight;
  final Color? color;
  final TextAlign? textAlign;
  final bool? isUnderLine;

  const TitleText({
    super.key,
    required this.title,
    this.style,
    this.fontSize,
    this.weight,
    this.color,
    this.isUnderLine,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      style: style ??
          GoogleFonts.roboto(
              fontSize: fontSize ?? 14,
              fontWeight: weight ?? FontWeight.normal,
              color: color ?? AppColors.black,
              decoration: (isUnderLine ?? false) ? TextDecoration.underline : TextDecoration.none),
    );
  }
}
