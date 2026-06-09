import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pos/core/utils/snackbar_service.dart';
import '../../../../core/routing/app_router.dart';
import 'package:pos/view/components/common/bottom_wave_painter.dart';
import 'package:pos/view/components/common/custom_appbar.dart';
import 'package:pos/view/components/common/custom_button/custom_button.dart';
import 'package:pos/view/components/common/custom_text_field/custom_text_field.dart';
import 'package:pos/view/components/common/heading_text.dart';
import '../../../payment/presentation/screens/payment_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../bill/presentation/providers/bill_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../view/components/common/fractionally_elevated_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController consumerNumberController = TextEditingController();

  Widget _buildIconDetail(String title, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: Colors.black54),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final billState = ref.watch(billProvider);
    log("bill state: ${billState.getBillResponse}");
    final billNotifier = ref.read(billProvider.notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(),
        // backgroundColor: AppColors.white,
        bottomNavigationBar: SizedBox(
          height: 100,
          width: double.infinity,
          child: CustomPaint(painter: BottomWavePainter()),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        // floatingActionButton:
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Main content
              if (billState.isEmpty ||
                  billState.getBillResponse == null ||
                  billState.getBillResponse!.isEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 15.h),
                    // Center(child: Image.asset(AssetsPath.appLogo, height: 100)),
                    // SizedBox(height: 9.h),
                    HeadingText(text: 'Consumer Number'),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomTextField(
                        cursorColor: Colors.green.shade600,
                        hintText: 'Consumer Number',
                        controller: consumerNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textColor: Colors.green.shade600,
                        borderColor: Colors.green.shade600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: loginButton(
                        context: context,
                        onTap: () async {
                          await billNotifier.getBill(
                            consumerNumberController.text,
                          );
                        },
                        title: 'Fetch',
                      ),
                    ),
                  ],
                ),

              SizedBox(height: 20),

              // Blur effect and CircularProgressIndicator
              if (billState.isLoading)
                BackdropFilter(
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
                ),

              // bill UI
              if (!billState.isEmpty &&
                  billState.getBillResponse != null &&
                  billState.getBillResponse!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Header Gradient
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.darkGreen,
                                    AppColors.lightGreen,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.receipt_long,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          billState
                                                  .getBillResponse?[0]
                                                  .Institution
                                                  ?.toString() ??
                                              "Institute",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Ref: ${billState.getBillResponse?[0].ReferenceInfo?.toString() ?? ''}",
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          (billState
                                                      .getBillResponse?[0]
                                                      .PaymentStatus
                                                      ?.toString()
                                                      .toLowerCase() ==
                                                  'paid')
                                              ? Colors.greenAccent.withOpacity(
                                                0.2,
                                              )
                                              : Colors.redAccent.withOpacity(
                                                0.2,
                                              ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            (billState
                                                        .getBillResponse?[0]
                                                        .PaymentStatus
                                                        ?.toString()
                                                        .toLowerCase() ==
                                                    'paid')
                                                ? Colors.greenAccent
                                                : Colors.redAccent,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      billState
                                              .getBillResponse?[0]
                                              .PaymentStatus
                                              ?.toString()
                                              .toUpperCase() ??
                                          "UNKNOWN",
                                      style: TextStyle(
                                        color:
                                            (billState
                                                        .getBillResponse?[0]
                                                        .PaymentStatus
                                                        ?.toString()
                                                        .toLowerCase() ==
                                                    'paid')
                                                ? Colors.greenAccent
                                                : Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Body Content
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Consumer Info
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              billState
                                                      .getBillResponse?[0]
                                                      .ConsumerDetail
                                                      ?.toString() ??
                                                  "",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "Consumer #: ${billState.getBillResponse?[0].ConsumerNumber?.toString() ?? ''}",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Divider(
                                      color: Colors.black12,
                                      thickness: 1,
                                    ),
                                  ),

                                  // Grid of details
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildIconDetail(
                                          "Month",
                                          billState
                                                  .getBillResponse?[0]
                                                  .BillingMonth
                                                  ?.toString() ??
                                              "",
                                          Icons.calendar_month,
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildIconDetail(
                                          "Due Date",
                                          (billState.getBillResponse?[0].DueDate1
                                                              ?.toString() ??
                                                          "")
                                                      .length >=
                                                  10
                                              ? billState
                                                  .getBillResponse![0]
                                                  .DueDate1
                                                  .toString()
                                                  .substring(0, 10)
                                              : billState
                                                      .getBillResponse?[0]
                                                      .DueDate1
                                                      ?.toString() ??
                                                  "",
                                          Icons.event,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Amount Highlight Box
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAF9),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "AMOUNT DUE",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black54,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              billState
                                                      .getBillResponse?[0]
                                                      .Currency
                                                      ?.toString() ??
                                                  "PKR",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              billState
                                                      .getBillResponse?[0]
                                                      .BillAmount
                                                      ?.toString() ??
                                                  "0.00",
                                              style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w900,
                                                color: AppColors.primaryColor,
                                                height: 1.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 24),
                                  // Proceed to Pay button
                                  Center(
                                    child: FractionallyElevatedButton(
                                      onTap: () async {
                                        if (billState
                                                .getBillResponse![0]
                                                .BillAmount
                                                .toString()
                                                .compareTo('0') <=
                                            0) {
                                          SnackbarService.showError(
                                            'Invalid Amount',
                                            'Amount must be greater then zero',
                                          );
                                        } else if (billState
                                                .getBillResponse
                                                ?.isNotEmpty ==
                                            true) {
                                          var temp =
                                              billState
                                                  .getBillResponse![0]
                                                  .BillAmount
                                                  ?.toString()
                                                  .split(".") ??
                                              ["0"];
                                          var amount = temp[0];
                                          var billId =
                                              billState
                                                  .getBillResponse![0]
                                                  .BillId
                                                  ?.toString() ??
                                              "";
                                          var consumerNumber =
                                              billState
                                                  .getBillResponse![0]
                                                  .ConsumerNumber
                                                  ?.toString() ??
                                              "";

                                          context.push(
                                            RouteNames.paymentScreen,
                                            extra: {
                                              "amount": amount,
                                              "billId": billId,
                                              "consumerNumber": consumerNumber,
                                            },
                                            

                                          );
                                        } else {
                                          null;
                                        }
                                      },
                                      title: 'PROCEED TO PAY',
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Cancel button
                                  Center(
                                    child: FloatingActionButton.extended(
                                      onPressed: () {
                                        consumerNumberController.clear();
                                        billNotifier.clearBill();
                                      },
                                      backgroundColor: AppColors.primaryColor,
                                      label: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
