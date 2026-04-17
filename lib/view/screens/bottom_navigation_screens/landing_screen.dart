import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controller/bottom_controller/bottom_navigation_controller.dart';
import 'package:pos/core/utils/app_assets.dart';
import 'package:pos/core/utils/app_colors.dart';
import 'package:pos/view/components/common/bottom_wave_painter.dart';
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
    return Obx(
      () => Scaffold(
        extendBody: false,
        appBar: CustomAppBar(),
        body: PopScope(
          canPop: false,
          child:
              bottomNavigationController.pages[bottomNavigationController
                  .pageIndex
                  .value],
        ),
        bottomNavigationBar: SizedBox(
          height: 100,
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: BottomWavePainter())),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: SizedBox(
              //     height: 100,
              //     width: double.infinity,
              //     child: CustomPaint(painter: BottomWavePainter()),
              //   ),
              // ),
              // Positioned(
              //   bottom: 0,
              //   left: 0,
              //   right: 0,
              //   child:
              Align(
                alignment: AlignmentGeometry.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: 11.2.h,
                  decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(12),
                    //   topRight: Radius.circular(12),
                    // ),
                    color: Colors.white38,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBottomNavItem(
                        index: 0,
                        selectedIndex:
                            bottomNavigationController
                                .bottomNavigationIndex
                                .value,
                        icon: Icons.home,
                        label: "Home",
                      ),
                      _buildBottomNavItem(
                        index: 1,
                        selectedIndex:
                            bottomNavigationController
                                .bottomNavigationIndex
                                .value,
                        icon: Icons.add,

                        label: "Add/Update",
                      ),
                    ],
                  ),
                ),
              ),
              // ),
            ],
          ),
        ),
      ),
    );
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
              color: isSelected ? Colors.green.shade200 : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Icon(icon, color: Colors.white, size: 35),
          ),
        ],
      ),
    );
  }
}
