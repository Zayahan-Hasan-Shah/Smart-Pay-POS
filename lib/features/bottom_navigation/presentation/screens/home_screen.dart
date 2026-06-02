import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final billState = ref.watch(billProvider);
    final billNotifier = ref.read(billProvider.notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(),
        // backgroundColor: AppColors.white,
        bottomNavigationBar: SizedBox(
          height: 100,
          child: CustomPaint(painter: BottomWavePainter()),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Main content
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
              if (!billState.isEmpty && billState.getBillResponse != null && billState.getBillResponse!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.darkGreen,
                                              AppColors.lightGreen,
                                              // Color(0xFFE8F5E9),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(13),
                                            topRight: Radius.circular(13),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Consumer No",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                billState.getBillResponse?[0].infoNo?.toString() ?? "",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(13),
                                            bottomRight: Radius.circular(13),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              _buildDetailRow(
                                                "Institute",
                                                billState.getBillResponse?[0].tid?.toString() ?? "",
                                              ),
                                              _buildDetailRow(
                                                "Consumer Name",
                                                billState.getBillResponse?[0].rfu4?.toString() ?? "",
                                              ),
                                              _buildDetailRow(
                                                "Invoice No",
                                                billState.getBillResponse?[0].invoiceNo?.toString() ?? "",
                                              ),
                                              _buildDetailRow(
                                                "Billing Month",
                                                billState.getBillResponse?[0].trTime?.toString() ?? "",
                                              ),
                                              _buildDetailRow(
                                                "Status",
                                                billState.getBillResponse?[0].rfu5?.toString() ?? "",
                                              ),
                                              _buildDetailRow(
                                                "Currency",
                                                billState.getBillResponse?[0].trCurrency?.toString() ?? "",
                                              ),
                                              _buildDetailRow(
                                                "Amount",
                                                billState.getBillResponse?[0].trtAmt?.toString() ?? "",
                                              ),
                                              _buildDetailRow(
                                                "Due Date",
                                                billState.getBillResponse?[0].trDate?.toString().substring(0, 10) ?? "",
                                              ),
                                              _buildDetailRow(
                                                "Late pay fee",
                                                billState.getBillResponse?[0].troAmt?.toString() ?? "",
                                              ),
                                              _buildDetailRow(
                                                "Pay after due date",
                                                billState.getBillResponse?[0].cardTAmt?.toString() ?? "",
                                              ),
                                              SizedBox(height: 20),
                                              Center(
                                                child: FractionallyElevatedButton(
                                                  onTap: () async {
                                                    if (billState.getBillResponse?.isNotEmpty == true) {
                                                      var temp = billState.getBillResponse![0].trtAmt?.split(".") ?? ["0"];
                                                      var amount = temp[0];
                                                      context.push(RouteNames.paymentScreen, extra: amount);
                                                    }
                                                  },
                                                  title: 'Pay',
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
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
