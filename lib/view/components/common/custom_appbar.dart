import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos/view/components/common/title_text.dart';

import '../../../core/utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final backgroundColor;
  const CustomAppBar({
    required this.text,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? AppColors.primaryDark,
      centerTitle: true,
      elevation: 2,
      title: TitleText(
        title: text,
        fontSize: 18,
        weight: FontWeight.w700,
        color: AppColors.white,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  content: const Text(
                    "Are you sure you want to logout?",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        exit(0);
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: AppColors.errorColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
