import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/utils/urls.dart';
import '../../../../core/network/custom_http_client.dart';
import '../models/get_bill_model.dart';
import '../models/create_bill_model.dart';
import 'bill_remote_datasource.dart';
import '../../../../core/utils/app_logger.dart';

class BillRemoteDataSourceImpl implements BillRemoteDataSource {
  @override
  Future<List<GetBillsModel>> getBill(String consumerNumber) async {
    final bodySent = {"Key": "consumer_Number", "Value": consumerNumber};
    AppLogger.info('Fetching bill for consumer: $consumerNumber', tag: 'API_GET_BILL');
    AppLogger.info('Request URL: ${URLS.getBillUrl} | Body: $bodySent', tag: 'API_GET_BILL');
    
    final url = Uri.parse('${URLS.getBillUrl}?ConsumerNo=$consumerNumber');
    final client = await CustomHttpClient.getClient();
    final response = await client.get(url);
    client.close();
    
    AppLogger.info('Response Status: ${response.statusCode} | Body: ${response.body}', tag: 'API_GET_BILL');
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return getBillsModelFromJson(response.body);
    } else {
      AppLogger.error('Failed to fetch bills. Status: ${response.statusCode}', tag: 'API_GET_BILL');
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

    AppLogger.info('Creating bill for consumer: $consumerNumber', tag: 'API_CREATE_BILL');
    AppLogger.info('Request URL: ${URLS.createBillUrl} | Body: ${jsonEncode(bodySent)}', tag: 'API_CREATE_BILL');
    
    final client = await CustomHttpClient.getClient();
    final response = await client.post(
      Uri.parse(URLS.createBillUrl),
      headers: {
        "Content-Type": "application/json",
        "MAPIkey": '57236e774a0d95772e63da5e8b3e2c8d81dfbf93f366e4755cfec7dc7db46cc06e6453021bf668f31ef68fc444602610a811d0cd2c0b563973d58689ce082ca9',
      },
      body: jsonEncode(bodySent),
    );
    client.close();

    AppLogger.info('Response Status: ${response.statusCode} | Body: ${response.body}', tag: 'API_CREATE_BILL');

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return createBillModelFromJson(response.body);
    } else {
      AppLogger.error('Server Error while creating bill: ${response.statusCode}', tag: 'API_CREATE_BILL');
      throw Exception('Server Error: ${response.statusCode}');
    }
  }
}
