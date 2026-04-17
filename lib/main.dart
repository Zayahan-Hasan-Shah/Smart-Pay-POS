import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/view/screens/auth/login_screen.dart';
import 'package:pos/view/screens/bottom_navigation_screens/bill_screens/add_and_update_bill_screen.dart';
import 'package:pos/view/screens/bottom_navigation_screens/home_screen/home_screen.dart';
import 'package:pos/view/screens/bottom_navigation_screens/landing_screen.dart';
import 'package:pos/view/screens/payment/payment_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'core/app_names.dart';
import 'core/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false, // Hide debug banner
          initialRoute: RouteNames.splashScreen, // Set initial route to login
          getPages: AppRoutes.routes,
          home: LoginScreen(),
        );
      },
    );
  }
}
