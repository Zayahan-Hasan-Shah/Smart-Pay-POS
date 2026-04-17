// ignore: non_constant_identifier_names
  import 'package:flutter/material.dart';
import 'package:pos/core/utils/app_colors.dart';

Widget loginButton({required BuildContext context ,required void Function()? onTap ,required String title,}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: 45,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.darkGreen,
              AppColors.lightGreen,
              // Color(0xFFE8F5E9),
            ],
          ),

          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: AlignmentGeometry.center,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }