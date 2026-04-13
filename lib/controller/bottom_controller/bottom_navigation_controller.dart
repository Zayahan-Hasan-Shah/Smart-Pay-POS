import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/view/screens/bottom_navigation_screens/bill_screens/add_and_update_bill_screen.dart';
import 'package:pos/view/screens/bottom_navigation_screens/home_screen/home_screen.dart';

class BottomNavigationController extends GetxController {
  @override
  void onInit() {
    setTitle();
    super.onInit();
  }

  var pageIndex = 0.obs;
  var bottomNavigationIndex = 0.obs;
  var appBarText = ''.obs;
  final pages = [const HomeScreen(), const AddAndUpdateBillScreen()];

  void setIndex(int index) {
    pageIndex.value = index; // Update the index
  }

  Widget get currentScreen {
    switch (pageIndex.value) {
      case 1:
        return const HomeScreen();
      case 2:
        return const AddAndUpdateBillScreen();
      default:
        return HomeScreen();
    }
  }

  void setTitle() {
    if (pageIndex.value == 0) {
      appBarText.value = "Home";
    } else if (pageIndex.value == 1) {
      appBarText.value = "Add/Update Bill";
    }
  }

  void selectBottomTab(int index) {
    bottomNavigationIndex.value = index;
  }

}
