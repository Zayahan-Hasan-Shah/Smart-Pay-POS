import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/core/utils/app_assets.dart';
import 'package:pos/view/components/common/custom_button/custom_button.dart';
import 'package:pos/view/components/common/custom_text_field/custom_text_field.dart';
import 'package:pos/view/components/common/heading_text.dart';
import 'package:pos/view/screens/payment/payment_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../controller/bill_controller/bill_controller.dart';
import '../../../../core/app_names.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../components/common/clear_button.dart';
import '../../../components/common/custom_text_form.dart';
import '../../../components/common/fractionally_elevated_button.dart';
import '../../../components/common/title_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final billController = Get.put(BillController());
  TextEditingController consumerNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // backgroundColor: ,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Main content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 15.h),
                  Center(child: Image.asset(AssetsPath.appLogo, height: 100)),

                  SizedBox(height: 9.h),
                  HeadingText(text: 'Consumer Number'),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomTextField(
                      cursorColor: Colors.green.shade600,
                      hintText: 'Consumer Number',
                      controller: consumerNumberController,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: loginButton(
                      context: context,
                      onTap: () async {
                        await billController.getBill(
                          consumerNumberController.text,
                        );
                      },
                      title: 'Fetch',
                    ),
                    //  FractionallyElevatedButton(
                    //   onTap: () async {
                    //     await billController.getBill(
                    //       consumerNumberController.text,
                    //     );
                    //   },
                    //   child: TitleText(
                    //     title: "FETCH",
                    //     color: AppColors.white,
                    //     fontSize: 13,
                    //     weight: FontWeight.w700,
                    //   ),
                    // ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Blur effect and CircularProgressIndicator
              Obx(() {
                if (billController.isLoading.value) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                      tileMode: TileMode.mirror,
                      sigmaX: 1.0,
                      sigmaY: 1.0,
                    ),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.white,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              }),
              Obx(
                () =>
                    billController.isEmpty.value
                        ? SizedBox.shrink()
                        : Visibility(
                          visible: (billController.isEmpty.value == false),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(13),
                                    topRight: Radius.circular(13),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text(
                                        "Consumer No",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        billController
                                                .getBillResponse
                                                .value?[0]
                                                .infoNo
                                                .toString() ??
                                            "",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8.0,
                                              ),
                                              child: const Text(
                                                " Amount",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8.0,
                                              ),
                                              child: const Text(
                                                "Due Date",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                  ),
                                              child: const Text(
                                                "Late pay fee",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                  ),
                                              child: const Text(
                                                "Pay after due date",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                  ),
                                              child: Text(
                                                billController
                                                        .getBillResponse
                                                        .value?[0]
                                                        .trtAmt
                                                        .toString() ??
                                                    "",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                  ),
                                              child: Text(
                                                billController
                                                        .getBillResponse
                                                        .value?[0]
                                                        .trDate
                                                        .toString()
                                                        .substring(0, 10) ??
                                                    "",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                  ),
                                              child: Text(
                                                billController
                                                        .getBillResponse
                                                        .value?[0]
                                                        .troAmt
                                                        .toString() ??
                                                    "",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                  ),
                                              child: Text(
                                                billController
                                                        .getBillResponse
                                                        .value?[0]
                                                        .cardTAmt
                                                        .toString() ??
                                                    "",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Center(
                                      child: FractionallyElevatedButton(
                                        // widthFactor: 0.4,
                                        onTap: () async {
                                          if (billController
                                                  .getBillResponse
                                                  .value!
                                                  .isNotEmpty ||
                                              billController
                                                      .getBillResponse
                                                      .value !=
                                                  null) {
                                            var temp = billController
                                                .getBillResponse
                                                .value![0]
                                                .trtAmt!
                                                .split(".");
                                            var amount = temp[0];
                                            Get.to(
                                              PaymentScreen(amount: amount),
                                            );
                                          }
                                        },
                                        title: 'Pay'
                                        // TitleText(
                                        //   title: "Pay",
                                        //   color: AppColors.white,
                                        //   fontSize: 20,
                                        //   weight: FontWeight.w700,
                                        // ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
