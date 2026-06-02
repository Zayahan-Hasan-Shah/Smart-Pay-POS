import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/bill/presentation/screens/add_and_update_bill_screen.dart';
import '../../features/bottom_navigation/presentation/screens/home_screen.dart';

import '../../features/on_boarding/presentation/screens/splash_screen.dart';
import '../../features/payment/presentation/screens/payment_screen.dart';

class RouteNames {
  static const splashScreen = '/';
  static const loginScreen = '/login-screen';
  static const homeScreen = '/home-screen';
  static const paymentScreen = '/payment-screen';
  static const addUpdateScreen = '/addupdate-screen';

}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: RouteNames.splashScreen,
  routes: [
    GoRoute(
      path: RouteNames.splashScreen,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.loginScreen,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.homeScreen,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RouteNames.paymentScreen,
      builder: (context, state) {
        final amount = state.extra; // Access passed data via extra
        return PaymentScreen(amount: amount);
      },
    ),
    GoRoute(
      path: RouteNames.addUpdateScreen,
      builder: (context, state) => const AddAndUpdateBillScreen(),
    ),

  ],
);
