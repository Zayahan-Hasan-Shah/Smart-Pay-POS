import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/model/bill_model/create_bill_model.dart';
import 'package:pos/service/bill_service.dart';

import '../../model/bill_model/get_bill_model.dart';

class BillController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<List<GetBillsModel>?> getBillResponse = Rx<List<GetBillsModel>?>(null);
  Rx<CreateBillModel?> createBillResponse = Rx<CreateBillModel?>(null);
  Rx<bool> isEmpty = true.obs;
  Rx<bool> billLoader = false.obs;

  Future<List<GetBillsModel>?> getBill(String consumerNumber) async {
    isLoading.value = true;
    var controllerResponse = await BillService().getBill(consumerNumber);
    if (controllerResponse?.isNotEmpty ?? false) {
      print("inside the if of controller");
      getBillResponse.value = controllerResponse;
      if (getBillResponse.value == [] ||
          (getBillResponse.value?.isEmpty ?? false)) {
        Get.snackbar(
          "Invalid Consumer",
          "No Consumer Found",
          colorText: Colors.white,
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
        );
        isEmpty.value = true;
        isLoading.value = false;
        return getBillResponse.value;
      }
      isEmpty.value = false;
      isLoading.value = false;
      return getBillResponse.value;
    }
    isLoading.value = false;
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
    billLoader.value = true;

    print('Amount in controller: $amount');
    print('Late Fee in controller: $lateFeeAmount');
    print('Consumer Number in controller: ${consumerNumber}');
    print('Due Date in controller: $dueDate');

    var response = await BillService().createBill(
        amount: amount,
        lateFeeAmount: lateFeeAmount,
        consumerNumber: consumerNumber,
        dueDate: dueDate,
        expDate: expDate,
        billingMonth: billingMonth,
        email: email,
        cellNumber: cellNumber,
        consumerDetail: consumerDetail ?? "",
        referenceInfo: referenceInfo ?? "",
        reserved: reserved ?? "");

    print('Response in controller : $response');

    if (response != null) {
      createBillResponse.value = response;
      Get.snackbar("Successful", "Bill Created",
          colorText: Colors.white,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM);
      billLoader.value = false;
      return createBillResponse.value;
    }
    Get.snackbar("Invalid", "Something Went Wrong $response",
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM);
    billLoader.value = false;
    return null;
  }
}
