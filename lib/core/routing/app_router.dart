import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/bill/presentation/screens/add_and_update_bill_screen.dart';
import '../../features/bottom_navigation/presentation/screens/home_screen.dart';

import '../../features/on_boarding/presentation/screens/splash_screen.dart';
import '../../features/payment/presentation/screens/payment_screen.dart';
import '../../features/admin/presentation/screens/admin_settings_screen.dart';

import '../utils/app_logger.dart';

class AppRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info('Pushed route: ${route.settings.name}', tag: 'NAVIGATION');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info('Popped route: ${route.settings.name}', tag: 'NAVIGATION');
  }
}

class RouteNames {
  static const splashScreen = '/';
  static const loginScreen = '/login-screen';
  static const homeScreen = '/home-screen';
  static const paymentScreen = '/payment-screen';
  static const addUpdateScreen = '/addupdate-screen';
  static const adminSettingsScreen = '/admin-settings';

}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: RouteNames.splashScreen,
  observers: [AppRouterObserver()],
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
        final paymentData = state.extra; // Access passed Map via extra
        return PaymentScreen(paymentData: paymentData);
      },
    ),
    // GoRoute(
    //   path: RouteNames.addUpdateScreen,
    //   builder: (context, state) => const AddAndUpdateBillScreen(),
    // ),
    GoRoute(
      path: RouteNames.adminSettingsScreen,
      builder: (context, state) => const AdminSettingsScreen(),
    ),
  ],
);
