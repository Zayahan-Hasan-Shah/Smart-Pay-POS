import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos/core/utils/app_assets.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? text;
  final backgroundColor;
  const CustomAppBar({this.text, this.backgroundColor, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          Positioned(
            bottom: 0,
            child: Image.asset(AssetsPath.appLogo, height: 55),
          ),
        ],
      ),

      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.black26),
          onPressed: () {
            final TextEditingController passwordController = TextEditingController();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Enter Password"),
                  content: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        if (passwordController.text == "admin123") {
                          Navigator.of(context).pop();
                          context.push(RouteNames.adminSettingsScreen);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Incorrect Password")),
                          );
                        }
                      },
                      child: const Text("Confirm"),
                    ),
                  ],
                );
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.logout, color: Colors.green.shade600),
          onPressed: () {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  actionsAlignment: MainAxisAlignment.center,
                  icon: Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Are you sure you want to logout?",
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8),
                        ),
                      ),
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Add logout functionality here
                        Navigator.of(context).pop();
                        exit(0);
                      },
                      child: const Text(
                        "CONFIRM",
                        style: TextStyle(color: Colors.red, fontSize: 12),
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
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
