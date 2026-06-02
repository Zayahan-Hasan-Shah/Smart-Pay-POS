import 'dart:convert';

CreateBillModel createBillModelFromJson(String str) => CreateBillModel.fromJson(json.decode(str));

String createBillModelToJson(CreateBillModel data) => json.encode(data.toJson());

class CreateBillModel {
  int responseCode;
  String responseMsg;

  CreateBillModel({
    required this.responseCode,
    required this.responseMsg,
  });

  factory CreateBillModel.fromJson(Map<String, dynamic> json) => CreateBillModel(
        responseCode: json["ResponseCode"],
        responseMsg: json["ResponseMsg"],
      );

  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "ResponseMsg": responseMsg,
      };
}