import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/utils/urls.dart';
import '../models/get_bill_model.dart';
import '../models/create_bill_model.dart';
import 'bill_remote_datasource.dart';

class BillRemoteDataSourceImpl implements BillRemoteDataSource {
  @override
  Future<List<GetBillsModel>> getBill(String consumerNumber) async {
    final bodySent = {"Key": "consumer_Number", "Value": consumerNumber};
    final response = await http.post(Uri.parse(URLS.getBillUrl), body: bodySent);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return getBillsModelFromJson(response.body);
    } else {
      throw Exception('Failed to fetch bills');
    }
  }

  @override
  Future<CreateBillModel> createBill({
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
    final bodySent = {
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
      "PStatus": "4",
    };

    final response = await http.post(
      Uri.parse(URLS.createBillUrl),
      headers: {
        "Content-Type": "application/json",
        "MAPIkey": '57236e774a0d95772e63da5e8b3e2c8d81dfbf93f366e4755cfec7dc7db46cc06e6453021bf668f31ef68fc444602610a811d0cd2c0b563973d58689ce082ca9',
      },
      body: jsonEncode(bodySent),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return createBillModelFromJson(response.body);
    } else {
      throw Exception('Server Error: ${response.statusCode}');
    }
  }
}
