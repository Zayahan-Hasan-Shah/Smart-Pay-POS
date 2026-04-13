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
      // resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  AssetsPath.background, // Replace with your image path
                  fit: BoxFit.cover, // Adjust the image to fill the background
                ),
              ),
              // Content on top of the background
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // Add the color of the container
                              borderRadius: BorderRadius.circular(10), // Optional: Add border radius for rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                                  spreadRadius: 3, // Spread radius of the shadow
                                  blurRadius: 10, // Blur effect for the shadow
                                  offset: Offset(0, 5), // Move shadow 5 pixels downwards
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          AssetsPath.appLogo,
                                          width: MediaQuery.of(context).size.height * 0.3,
                                        ),
                                      ),
                                      AppSize.vrtSpace(20),
                                      headingText("Login ID"),
                                      AppSize.vrtSpace(5),
                                      userTextField(userFilled),
                                      AppSize.vrtSpace(15),
                                      headingText("Password"),
                                      AppSize.vrtSpace(5),
                                      passTextField(passFilled),
                                      AppSize.vrtSpace(10),
                                      AppSize.vrtSpace(15),
                                      loginButton(),

                                    ],
                                  ),
                                ),
                                AppSize.vrtSpace(10),
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
          )),
    );
  }

  Container footer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
      ),
      child: Center(
        child: Column(
          children: [
            TitleText(
              title: "Copyright © 2025. All "
                  "rights reserved.",
              color: AppColors.white,
            ),
            AppSize.vrtSpace(10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
    return  Center(
      child: FractionallyElevatedButton(
          onTap: () async {
            if (_formKey.currentState!.validate()) {

              // billController.getBill();

              // Get.toNamed( RouteNames.homeScreen);
              Get.toNamed( RouteNames.bottomNavigationScreen);
            }
          },
          child:
              TitleText(
            title: "Login",
            color: AppColors.white,
            fontSize: 20,
            weight: FontWeight.w700,
          )),
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
