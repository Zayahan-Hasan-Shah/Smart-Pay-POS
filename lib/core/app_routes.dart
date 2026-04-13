import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:pos/view/screens/bottom_navigation_screens/bill_screens/add_and_update_bill_screen.dart';
import 'package:pos/view/screens/bottom_navigation_screens/landing_screen.dart';
import 'package:pos/view/screens/payment/payment_screen.dart';
import 'package:pos/view/screens/on_boarding/splash_screen.dart';

import '../view/screens/bottom_navigation_screens/home_screen/home_screen.dart';
import '../view/screens/auth/login_screen.dart';
import 'app_names.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: RouteNames.loginScreen,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: RouteNames.splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: RouteNames.homeScreen,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: RouteNames.paymentScreen,
      page: () => PaymentScreen(),
    ),
    GetPage(
      name: RouteNames.addUpdateScreen,
      page: () => AddAndUpdateBillScreen(),
    ),
    GetPage(
      name: RouteNames.bottomNavigationScreen,
      page: () => LandingScreen(),
    ),
  ];
}
