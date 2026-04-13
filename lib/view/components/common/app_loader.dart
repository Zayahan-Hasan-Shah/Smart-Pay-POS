import 'package:flutter/material.dart';

import '../../../core/utils/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(
            AppColors.primaryColor,
          ),
          // color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
