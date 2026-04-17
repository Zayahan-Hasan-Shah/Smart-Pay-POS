// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import '../../../core/utils/app_colors.dart';

// class CustomTextFormField extends StatelessWidget {
//   CustomTextFormField({
//     super.key,
//     required this.controller,
//     this.onTap,
//     this.autovalidateMode,
//     required this.obscureText,
//     this.onSuffixTap,
//     this.onChanged,
//     this.filled,
//     this.inputFormatters,
//     this.hint,
//     this.maxLines,
//     this.keyboardType,
//     this.prefixIcon,
//     this.validator,
//     this.suffix,
//     this.prefix,
//     this.value = false,
//   });

//   final VoidCallback? onTap;
//   final VoidCallback? onSuffixTap;
//   final Function(String? value)? onChanged;
//   final String? Function(String? value)? validator;
//   final TextEditingController controller;
//   final bool obscureText;
//   final TextInputType? keyboardType;
//   final bool? filled;
//   final String? hint;
//   final int? maxLines;
//   final List<TextInputFormatter>? inputFormatters;
//   final Widget? prefixIcon;
//   final bool value;
//   final Widget? suffix;
//   final Widget? prefix;

//   final AutovalidateMode? autovalidateMode;
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       cursorColor: AppColors.primaryColor,
//       readOnly: value,
//       controller: controller,
//       onTap: onTap ?? () {},
//       onChanged: onChanged ?? (v) {},
//       validator: validator,
//       keyboardType: keyboardType,
//       autovalidateMode: autovalidateMode,
//       inputFormatters: inputFormatters,
//       maxLines: obscureText == null ? maxLines : 1,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         prefixIconConstraints: BoxConstraints(minWidth: 40),
//         // filled: true,
//         // contentPadding: EdgeInsets.symmetric(horizontal: 5),
//         // hin
//         prefix: prefix,
//         hintStyle: TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.bold,
//           color: Colors.black26,
//         ),
//         suffixIcon:
//             suffix != null
//                 ? IconButton(
//                   onPressed: onSuffixTap,
//                   icon: suffix ?? Icon(Icons.check_circle_outline_outlined),
//                 )
//                 : null,
//         hintText: hint,
//         prefixIcon: prefixIcon,
//         // contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//         border: const OutlineInputBorder(),
//         fillColor: AppColors.white,
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: AppColors.primaryColor),
//         ),
//         errorStyle: const TextStyle(
//           // fontStyle: FontStyle.italic,
//           fontSize: 13,
//           // fontWeight: FontWeight.w400,
//         ),
//       ),
//       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//       obscuringCharacter: "•",
//     );
//   }
// }
