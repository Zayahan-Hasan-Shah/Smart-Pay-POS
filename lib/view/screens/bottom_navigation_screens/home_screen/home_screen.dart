import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/view/screens/payment/payment_screen.dart';
import '../../../../controller/bill_controller/bill_controller.dart';
import '../../../../core/utils/app_colors.dart';
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(
                    left: 20,
                    right:20,
                    bottom: 20
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryMagentaGreenColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(
                      title: "Find Bill",
                      fontSize: 30,
                      weight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    const SizedBox(height: 4),
                    TitleText(
                      title: "Enter consumer number to view bill details",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.white,
                        fontWeight: FontWeight.w400,
                      ),
                      
                    ),
                  ],
                ),
              ),

              // Search and Fetch Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Search Field
                    TextFormField(
                      controller: consumerNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter Consumer Number",
                        hintStyle: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.numbers,
                          color: AppColors.primaryMagentaGreenColor,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () => consumerNumberController.clear(),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.borderColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.borderColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryDark,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    // Fetch Button
                    FractionallyElevatedButton(
                      widthFactor: 1,
                      buttonBackgroundColor: AppColors.primaryMagentaGreenColor,
                      onTap: () async {
                        await billController.getBill(
                          consumerNumberController.text,
                        );
                      },
                      child: TitleText(
                        title: "Fetch Bill Details",
                        color: AppColors.white,
                        fontSize: 16,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Loading Indicator
              Obx(() {
                if (billController.isLoading.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: AppColors.primaryDark,
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Loading bill details...",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              // Bill Details Card
              Obx(
                () =>
                    billController.isEmpty.value
                        ? const SizedBox.shrink()
                        : Visibility(
                          visible: !billController.isEmpty.value,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  // Card Header
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryDark,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Bill Information",
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        RichText(
                                          text: TextSpan(
                                            text: "Consumer No: ",
                                            style: const TextStyle(
                                              color: AppColors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    billController
                                                        .getBillResponse
                                                        .value?[0]
                                                        .infoNo
                                                        .toString() ??
                                                    "N/A",
                                                style: const TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Card Body
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        _buildInfoRow(
                                          "Amount",
                                          billController
                                                  .getBillResponse
                                                  .value?[0]
                                                  .trtAmt
                                                  .toString() ??
                                              "N/A",
                                        ),
                                        const Divider(height: 16),
                                        _buildInfoRow(
                                          "Due Date",
                                          billController
                                                  .getBillResponse
                                                  .value?[0]
                                                  .trDate
                                                  ?.toString()
                                                  .substring(0, 10) ??
                                              "N/A",
                                        ),
                                        const Divider(height: 16),
                                        _buildInfoRow(
                                          "Late Payment Fee",
                                          billController
                                                  .getBillResponse
                                                  .value?[0]
                                                  .troAmt
                                                  .toString() ??
                                              "N/A",
                                        ),
                                        const Divider(height: 16),
                                        _buildInfoRow(
                                          "Total Amount",
                                          billController
                                                  .getBillResponse
                                                  .value?[0]
                                                  .cardTAmt
                                                  .toString() ??
                                              "N/A",
                                        ),
                                        const SizedBox(height: 24),
                                        // Pay Button
                                        FractionallyElevatedButton(
                                          widthFactor: 0.6,
                                          buttonBackgroundColor:
                                              AppColors.successColor,
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
                                          child: TitleText(
                                            title: "Proceed to Pay",
                                            color: AppColors.white,
                                            fontSize: 16,
                                            weight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
