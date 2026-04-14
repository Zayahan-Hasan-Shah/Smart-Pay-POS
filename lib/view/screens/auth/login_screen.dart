import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos/controller/bill_controller/bill_controller.dart';

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
  bool passFilled = false;
  bool userFilled = false;

  @override
  void dispose() {
    // TODO: implement dispose
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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                AssetsPath.background,
                fit: BoxFit.cover,
              ),
            ),
            // Content on top of the background
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Login Card
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 32, bottom: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Logo
                                    Image.asset(
                                      AssetsPath.appLogo,
                                      width: MediaQuery.of(context).size.height * 0.25,
                                    ),
                                    const SizedBox(height: 24),
                                    // Welcome Text
                                    const Text(
                                      "Welcome to SmartPay",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Sign in to continue",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Form Fields
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Login ID",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    userTextField(userFilled),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "Password",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    passTextField(passFilled),
                                    const SizedBox(height: 32),
                                    // Login Button
                                    loginButton(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              footer(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container footer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              "Copyright © 2025. All rights reserved.",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildIcons(AssetsPath.facebook),
                  buildIcons(AssetsPath.googlePlus),
                  buildIcons(AssetsPath.linkedIn),
                  buildIcons(AssetsPath.twitter),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomTextFormField passTextField(bool passFilled) {
    return CustomTextFormField(
      filled: passFilled,
      obscureText: false,
      controller: passwordController,
      validator: validator,
      onSuffixTap: () {
        // authController.isObsecure.value = !authController.isObsecure.value;
        // print("----- ${authController.isObsecure.value}");
      },

      autovalidateMode: AutovalidateMode.onUserInteraction,
      // suffix: authController.isObsecure.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
      suffix: const Icon(Icons.visibility_off),
    );
  }

  CustomTextFormField userTextField(bool userFilled) {
    return CustomTextFormField(
      controller: userNameController,
      obscureText: false,
      validator: validator,
      filled: userFilled,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        if (value?.isNotEmpty ?? false) {
          // ref.read(getUserFieldFilledProvider.notifier).state = true;
        } else {
          // ref.read(getUserFieldFilledProvider.notifier).state = false;
        }
      },
    );
  }

  Image buildIcons(String path) {
    return Image.asset(
      path,
      color: AppColors.white,
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
    return HeadingText(
      text: text,
    );
  }

  Widget tagHeading(String text) {
    return HeadingText(
      text: text,
      fontSize: 20.sp,
      color: Colors.redAccent,
    );
  }

  Widget biometricText(String text) {
    return HeadingText(
      text: text,
      fontSize: 17.sp,
    );
  }

  Widget loginButton() {
    return Center(
      child: FractionallyElevatedButton(
        widthFactor: 0.8,
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            Get.toNamed(RouteNames.bottomNavigationScreen);
          }
        },
        child: TitleText(
          title: "Sign In",
          color: AppColors.white,
          fontSize: 18,
          weight: FontWeight.w700,
        ),
      ),
    );
  }

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
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
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
            child: TitleText(
              title: msg,
              fontSize: 20,
              weight: FontWeight.w500,
            ),
          ),
          actions: [
            Center(
              child: FractionallyElevatedButton(
                onTap: () {},
                child: TitleText(
                  title: "OK",
                  color: AppColors.white,
                  weight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


}
