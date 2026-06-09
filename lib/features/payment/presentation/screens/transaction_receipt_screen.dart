import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/custom_http_client.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/snackbar_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/urls.dart';
import '../../../../view/components/common/custom_appbar.dart';
import '../../../../view/components/common/fractionally_elevated_button.dart';

class TransactionReceiptScreen extends StatefulWidget {
  final Map<String, dynamic> payload;

  const TransactionReceiptScreen({Key? key, required this.payload})
      : super(key: key);

  @override
  State<TransactionReceiptScreen> createState() =>
      _TransactionReceiptScreenState();
}

class _TransactionReceiptScreenState extends State<TransactionReceiptScreen> {
  bool _isApiLoading = true;
  bool _apiSuccess = false;
  String _apiMessage = "Syncing transaction...";

  @override
  void initState() {
    super.initState();
    _notifyPaymentSuccess();
  }

  Future<void> _notifyPaymentSuccess() async {
    try {
      final paymentData = widget.payload["paymentData"];
      final posData = widget.payload["posData"] as Map<String, String>;

      String amount = "0";
      String billId = "";
      String consumerNumber = "";

      if (paymentData is Map) {
        amount = paymentData["amount"]?.toString() ?? "0";
        billId = paymentData["billId"]?.toString() ?? "";
        consumerNumber = paymentData["consumerNumber"]?.toString() ?? "";
      } else {
        amount = paymentData?.toString() ?? "0";
      }

      String merchantXid =
          consumerNumber.length >= 4
              ? consumerNumber.substring(0, 4)
              : consumerNumber;
      String invoice = posData["INVOICENO"] ?? "unknown";
      String card = (posData["CARDNO"] ?? "unknown").replaceAll("*", "");

      String transactionId = "${invoice}-${card}";
      if (transactionId.length > 20) {
        transactionId = transactionId.substring(0, 20);
      }

      final payload = {
        "amount": amount,
        "billnumber": billId,
        "merchantXid": merchantXid,
        "timestamp": DateTime.now().toIso8601String().substring(0, 19),
        "transactionId": transactionId,
        "Bank_Mnemonic": "POS",
      };

      AppLogger.info(
        'Sending Payment Success payload: $payload',
        tag: 'API_PAYMENT_SUCCESS',
      );

      final client = await CustomHttpClient.getClient();
      final response = await client.post(
        Uri.parse(URLS.paymentUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      client.close();

      AppLogger.info(
        'Payment Success API called. Code: ${response.statusCode}',
        tag: 'API_PAYMENT_SUCCESS',
      );

      if (mounted) {
        setState(() {
          _isApiLoading = false;
          _apiSuccess = true;
          _apiMessage = "Payment successfully logged.";
        });
        SnackbarService.showSuccess(
          "Transaction Successful",
          "Payment logged and accepted.",
        );
      }
    } catch (e) {
      AppLogger.error(
        'Failed to notify payment success: $e',
        tag: 'API_PAYMENT_SUCCESS',
      );
      if (mounted) {
        setState(() {
          _isApiLoading = false;
          _apiSuccess = false;
          _apiMessage = "Transaction successful but failed to notify server.";
        });
        SnackbarService.showError("API Error", _apiMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final posData = widget.payload["posData"] as Map<String, String>? ?? {};

    return PopScope(
      canPop: !_isApiLoading,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: const CustomAppBar(
          text: 'Transaction Receipt',
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 15.w,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                "APPROVED",
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 4.h,
                          thickness: 1.5,
                          color: Colors.grey[300],
                        ),
                        ...posData.entries
                            .map(
                              (entry) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.8.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        entry.key,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        entry.value,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        Divider(
                          height: 4.h,
                          thickness: 1.5,
                          color: Colors.grey[300],
                        ),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isApiLoading) ...[
                                SizedBox(
                                  width: 4.w,
                                  height: 4.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                              ],
                              Icon(
                                _isApiLoading
                                    ? Icons.sync
                                    : (_apiSuccess
                                        ? Icons.cloud_done
                                        : Icons.cloud_off),
                                color: _isApiLoading
                                    ? Colors.blue
                                    : (_apiSuccess
                                        ? Colors.green
                                        : Colors.red),
                                size: 5.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                _apiMessage,
                                style: TextStyle(
                                  color: _isApiLoading
                                      ? Colors.blue
                                      : (_apiSuccess
                                          ? Colors.green
                                          : Colors.red),
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14.sp,
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
              Padding(
                padding: EdgeInsets.all(4.w),
                child: FractionallyElevatedButton(
                  onTap: (_isApiLoading || !_apiSuccess)
    ? null
    : () {
                          context.go(RouteNames.homeScreen);
                        },
                  title: 'DONE',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
