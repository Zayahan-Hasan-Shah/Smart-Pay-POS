import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/core/utils/urls.dart';
import 'package:pos/model/bill_model/create_bill_model.dart';

import '../model/bill_model/get_bill_model.dart';
import 'package:http/http.dart' as http;

class BillService {
  Future<List<GetBillsModel>?> getBill(String consumerNumber) async {
    try {
      var bodySent = {"Key": "consumer_Number", "Value": consumerNumber};

      log("calling: ${URLS.getBillUrl}");
      log("body Being sent is $bodySent");

      var response =
          await http.post(Uri.parse(URLS.getBillUrl), body: bodySent);

      if (response.body.isNotEmpty) {
        log("status code ${response.statusCode} || API : ${URLS.getBillUrl} :: Response ${response.body}");
        return getBillsModelFromJson(response.body);
      }
    } catch (e) {
      log('Error Log : ${e.toString()}');
    }
    return null;
  }

  Future<CreateBillModel?> createBill({
    required int amount,
    required int lateFeeAmount,
    required String consumerNumber,
    required String dueDate,
    required String expDate,
    required String billingMonth,
    required String email,
    required String cellNumber,
    String? consumerDetail,
    String? referenceInfo,
    String? reserved,
  }) async {
    try {
      print('Amount in service: $amount');
      print('Late Fee in service: $lateFeeAmount');
      print('Consumer Number in service: ${consumerNumber}');
      print('Due Date in service: $dueDate');

      var bodySent = {
        "consumer_Number": consumerNumber,
        "Consumer_Detail": consumerDetail ?? "",
        "DueDate": dueDate,
        "ExpDate": expDate,
        "Amount": amount,
        "LateFee": lateFeeAmount,
        "Billing_Month": billingMonth,
        "BillStatus": 1,
        "CellNo": cellNumber,
        "EMail": email,
        "ReferenceInfo": referenceInfo ?? "",
        "reserved": reserved ?? "",
        "PStatus":"4",
      };

      log("calling: ${URLS.createBillUrl}");
      log("body Being sent is $bodySent");

      final response = await http.post(
        Uri.parse(URLS.createBillUrl),
        headers: {
          "Content-Type": "application/json",
          "MAPIkey":
              '57236e774a0d95772e63da5e8b3e2c8d81dfbf93f366e4755cfec7dc7db46cc06e6453021bf668f31ef68fc444602610a811d0cd2c0b563973d58689ce082ca9',
        },
        body: jsonEncode(bodySent),
      );

      log("status code: ${response.statusCode}");
      log("response body: '${response.body}'");

      // Handle success
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return createBillModelFromJson(response.body);
        } else {
          log("Empty body received despite 200 OK");
          Get.snackbar("Error", "Empty response from server",
              backgroundColor: Colors.red, colorText: Colors.white);
          return null;
        }
      }

      // Handle failure
      Get.snackbar("Failed", "Server Error: ${response.statusCode}",
          backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    } catch (e) {
      log("Exception in Create Bill: $e");
      Get.snackbar("Exception", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    }
  }
}
