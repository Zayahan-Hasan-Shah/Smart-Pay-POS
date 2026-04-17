import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos/controller/bill_controller/bill_controller.dart';
import 'package:pos/view/components/common/bottom_wave_painter.dart';
import 'package:pos/view/components/common/custom_button/custom_button.dart';
import 'package:pos/view/components/common/custom_text_field/custom_text_field.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/app_names.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../../service/common_service/app_service.dart';
import '../../components/common/clear_button.dart';
import '../../components/common/custom_text_form.dart';
import '../../components/common/fractionally_elevated_button.dart';
import '../../components/common/heading_text.dart';
import '../../components/common/title_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final billController = Get.put(BillController());
  // bool passFilled = false;
  // bool userFilled = false;
  bool visible = false;

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    userNameController.text = "Fayyaz@outlook.com";
    passwordController.text = "Fayyaz123";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: CustomPaint(painter: BottomWavePainter()),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.h),
                    Center(
                      child: Image.asset(
                        AssetsPath.appLogo,
                        width: MediaQuery.of(context).size.height * 0.3,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    AppSize.vrtSpace(20),
                    headingText("Login ID"),
                    AppSize.vrtSpace(5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        cursorColor: Colors.green.shade600,
                        controller: userNameController,
                        prefixIcon: Icon(Icons.email_outlined),
                      ), //userTextField(/*userFilled*/),
                    ),
                    AppSize.vrtSpace(15),
                    headingText("Password"),
                    AppSize.vrtSpace(5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        prefixIcon: Icon(Icons.lock_outlined),
                        controller: passwordController /*passFilled*/,
                      ),
                    ),
                    AppSize.vrtSpace(15),
                    Center(child: loginButton(onTap: ()  {
        if (_formKey.currentState!.validate()) {
          // billController.getBill();

          // Get.toNamed( RouteNames.homeScreen);
          Get.toNamed(RouteNames.homeScreen);
        }
      }, title: 'Login', context: context)),
                    SizedBox(height: 3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildIcons(AssetsPath.facebook),
                        SizedBox(width: 3.h),
                        buildIcons(AssetsPath.googlePlus),
                        SizedBox(width: 3.h),
                        buildIcons(AssetsPath.linkedIn),
                        SizedBox(width: 3.h),
                        buildIcons(AssetsPath.twitter),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Center(
                      child: Text(
                        "Copyright © 2025. All "
                        "rights reserved.",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),

                    // footer(),
                  ],
                ),
                //   ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Container footer() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     decoration: BoxDecoration(
  //       gradient: const LinearGradient(
  //         colors: [AppColors.darkGreen, AppColors.lightGreen],
  //       ),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Center(
  //       child: Column(
  //         children: [
  //           TitleText(
  //             title:
  //                 "Copyright © 2025. All "
  //                 "rights reserved.",
  //             color: AppColors.white,
  //           ),
  //           AppSize.vrtSpace(10),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 100),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 buildIcons(AssetsPath.facebook),
  //                 buildIcons(AssetsPath.googlePlus),
  //                 buildIcons(AssetsPath.linkedIn),
  //                 buildIcons(AssetsPath.twitter),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // CustomTextFormField passTextField(/*bool passFilled*/) {
  //   return CustomTextFormField(
  //     // filled: passFilled,
  //     obscureText: visible,
  //     controller: passwordController,
  //     validator: validator,
  //     onSuffixTap: () {
  //       setState(() {
  //         visible = !visible;
  //       });
  //       // authController.isObsecure.value = !authController.isObsecure.value;
  //       // print("----- ${authController.isObsecure.value}");
  //     },

  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     // suffix: authController.isObsecure.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
  //     suffix:
  //         visible == false
  //             ? Icon(Icons.visibility)
  //             : Icon(Icons.visibility_off),
  //   );
  // }

  // CustomTextFormField userTextField(/*bool userFilled*/) {
  //   return CustomTextFormField(
  //     controller: userNameController,
  //     obscureText: false,
  //     validator: validator,
  //     prefix: Icon(Icons.email_outlined),
  //     // filled: userFilled,
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     onChanged: (value) {
  //       if (value?.isNotEmpty ?? false) {
  //         // ref.read(getUserFieldFilledProvider.notifier).state = true;
  //       } else {
  //         // ref.read(getUserFieldFilledProvider.notifier).state = false;
  //       }
  //     },
  //   );
  // }

  Image buildIcons(String path) {
    return Image.asset(
      path,
      color: Colors.green.shade600,
      height: 20,
      width: 20,
    );
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  Widget headingText(String text) {
    return HeadingText(text: text);
  }

  Widget tagHeading(String text) {
    return HeadingText(text: text, fontSize: 20.sp, color: Colors.redAccent);
  }

  Widget biometricText(String text) {
    return HeadingText(text: text, fontSize: 17.sp);
  }

  // Widget loginButton() {
  //   return Center(
  //     child: FractionallyElevatedButton(
  //       onTap: () async {
  //         if (_formKey.currentState!.validate()) {
  //           // billController.getBill();

  //           // Get.toNamed( RouteNames.homeScreen);
  //           Get.toNamed(RouteNames.bottomNavigationScreen);
  //         }
  //       },
  //       child: TitleText(
  //         title: "LOGIN",
  //         color: AppColors.white,
  //         fontSize: 13,
  //         weight: FontWeight.w700,
  //       ),
  //     ),
  //   );
  // }

  Future loading() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> errorDialog(String msg) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: TitleText(title: msg, fontSize: 20, weight: FontWeight.w500),
          ),
          actions: [
            Center(
              child: FractionallyElevatedButton(
                onTap: () {},
                title: 'ok'
                // TitleText(
                //   title: "OK",
                //   color: AppColors.white,
                //   weight: FontWeight.w500,
                // ),
              ),
            ),
          ],
        );
      },
    );
  }

}
