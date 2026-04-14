import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controller/bottom_controller/bottom_navigation_controller.dart';
import 'package:pos/core/utils/app_colors.dart';
import 'package:pos/view/components/common/custom_appbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  var bottomNavigationController = Get.put(BottomNavigationController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: CustomAppBar(
            text: bottomNavigationController.appBarText.value,
            backgroundColor: AppColors.primaryMagentaGreenColor,
          ),
          body: PopScope(
              canPop: false,
              child: bottomNavigationController
                  .pages[bottomNavigationController.pageIndex.value]),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(8),
            height: 8.h,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: AppColors.primaryMagentaGreenColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(
                  index: 0,
                  selectedIndex:
                      bottomNavigationController.bottomNavigationIndex.value,
                  icon: Icons.home,
                  label: "Home",
                ),
                _buildBottomNavItem(
                  index: 1,
                  selectedIndex:
                      bottomNavigationController.bottomNavigationIndex.value,
                  icon: Icons.add,
                  label: "Add/Update",
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildBottomNavItem({
    required int index,
    required int selectedIndex,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = index == selectedIndex;
    return InkWell(
      onTap: () {
        // Update the selected index when tapped
        bottomNavigationController.bottomNavigationIndex.value = index;
        bottomNavigationController.selectBottomTab(index);
        bottomNavigationController.setIndex(index);
        bottomNavigationController.setTitle();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.7.h),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.shade300 : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
