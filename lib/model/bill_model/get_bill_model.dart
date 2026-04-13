// To parse this JSON data, do
//
//     final getBillsModel = getBillsModelFromJson(jsonString);

import 'dart:convert';

List<GetBillsModel> getBillsModelFromJson(String str) => List<GetBillsModel>.from(json.decode(str).map((x) => GetBillsModel.fromJson(x)));

String getBillsModelToJson(List<GetBillsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetBillsModel {
  int? trid;
  String? logo;
  String? hl1;
  String? hl2;
  String? hl3;
  String? hl4;
  int? mid;
  String? tid;
  DateTime? trDate;
  String? trTime;
  String? batchNo;
  String? invoiceNo;
  String? rrn;
  dynamic authNo;
  String? cardNo;
  String? cardExpiry;
  String? scheme;
  String? cardTech;
  String? trModeId;
  String? trTypeId;
  String? trCurrencyCode;
  String? trCurrency;
  dynamic trAmt;
  String? trtip;
  String? troAmt;
  String? trtAmt;
  String? cardCurrencyCode;
  String? cardCurrency;
  String? cardAmt;
  String? cardTip;
  String? cardOAmt;
  String? cardTAmt;
  String? dccExRate;
  int? cvmId;
  String? voucherNo;
  String? voucherSNo;
  String? ref;
  String? infoNo;
  String? otherInfo;
  String? notes;
  String? aid;
  String? tvr;
  String? tc;
  String? posSerialNo;
  String? copyFor;
  String? fl1;
  String? fl2;
  String? fl3;
  String? rfu1;
  dynamic rfu2;
  dynamic rfu3;
  String? rfu4;
  String? rfu5;
  int? rfu6;
  String? signImage;

  GetBillsModel({
    this.trid,
    this.logo,
    this.hl1,
    this.hl2,
    this.hl3,
    this.hl4,
    this.mid,
    this.tid,
    this.trDate,
    this.trTime,
    this.batchNo,
    this.invoiceNo,
    this.rrn,
    this.authNo,
    this.cardNo,
    this.cardExpiry,
    this.scheme,
    this.cardTech,
    this.trModeId,
    this.trTypeId,
    this.trCurrencyCode,
    this.trCurrency,
    this.trAmt,
    this.trtip,
    this.troAmt,
    this.trtAmt,
    this.cardCurrencyCode,
    this.cardCurrency,
    this.cardAmt,
    this.cardTip,
    this.cardOAmt,
    this.cardTAmt,
    this.dccExRate,
    this.cvmId,
    this.voucherNo,
    this.voucherSNo,
    this.ref,
    this.infoNo,
    this.otherInfo,
    this.notes,
    this.aid,
    this.tvr,
    this.tc,
    this.posSerialNo,
    this.copyFor,
    this.fl1,
    this.fl2,
    this.fl3,
    this.rfu1,
    this.rfu2,
    this.rfu3,
    this.rfu4,
    this.rfu5,
    this.rfu6,
    this.signImage,
  });

  factory GetBillsModel.fromJson(Map<String, dynamic> json) => GetBillsModel(
    trid: json["TRID"],
    logo: json["Logo"],
    hl1: json["HL1"],
    hl2: json["HL2"],
    hl3: json["HL3"],
    hl4: json["HL4"],
    mid: json["MID"],
    tid: json["TID"],
    trDate: json["TRDate"] == null ? null : DateTime.parse(json["TRDate"]),
    trTime: json["TRTime"],
    batchNo: json["BatchNo"],
    invoiceNo: json["InvoiceNo"],
    rrn: json["RRN"],
    authNo: json["AuthNo"],
    cardNo: json["CardNo"],
    cardExpiry: json["CardExpiry"],
    scheme: json["Scheme"],
    cardTech: json["CardTech"],
    trModeId: json["TRModeId"],
    trTypeId: json["TRTypeID"],
    trCurrencyCode: json["TRCurrencyCode"],
    trCurrency: json["TRCurrency"],
    trAmt: json["TRAmt"],
    trtip: json["TRTIP"],
    troAmt: json["TROAmt"],
    trtAmt: json["TRTAmt"],
    cardCurrencyCode: json["CardCurrencyCode"],
    cardCurrency: json["CardCurrency"],
    cardAmt: json["CardAmt"],
    cardTip: json["CardTip"],
    cardOAmt: json["CardOAmt"],
    cardTAmt: json["CardTAmt"],
    dccExRate: json["DCCExRate"],
    cvmId: json["CVMId"],
    voucherNo: json["VoucherNo"],
    voucherSNo: json["VoucherSNo"],
    ref: json["Ref"],
    infoNo: json["InfoNo"],
    otherInfo: json["OtherInfo"],
    notes: json["Notes"],
    aid: json["AID"],
    tvr: json["TVR"],
    tc: json["TC"],
    posSerialNo: json["POSSerialNo"],
    copyFor: json["CopyFor"],
    fl1: json["FL1"],
    fl2: json["FL2"],
    fl3: json["FL3"],
    rfu1: json["RFU1"],
    rfu2: json["RFU2"],
    rfu3: json["RFU3"],
    rfu4: json["RFU4"],
    rfu5: json["RFU5"],
    rfu6: json["RFU6"],
    signImage: json["SignImage"],
  );

  Map<String, dynamic> toJson() => {
    "TRID": trid,
    "Logo": logo,
    "HL1": hl1,
    "HL2": hl2,
    "HL3": hl3,
    "HL4": hl4,
    "MID": mid,
    "TID": tid,
    "TRDate": trDate?.toIso8601String(),
    "TRTime": trTime,
    "BatchNo": batchNo,
    "InvoiceNo": invoiceNo,
    "RRN": rrn,
    "AuthNo": authNo,
    "CardNo": cardNo,
    "CardExpiry": cardExpiry,
    "Scheme": scheme,
    "CardTech": cardTech,
    "TRModeId": trModeId,
    "TRTypeID": trTypeId,
    "TRCurrencyCode": trCurrencyCode,
    "TRCurrency": trCurrency,
    "TRAmt": trAmt,
    "TRTIP": trtip,
    "TROAmt": troAmt,
    "TRTAmt": trtAmt,
    "CardCurrencyCode": cardCurrencyCode,
    "CardCurrency": cardCurrency,
    "CardAmt": cardAmt,
    "CardTip": cardTip,
    "CardOAmt": cardOAmt,
    "CardTAmt": cardTAmt,
    "DCCExRate": dccExRate,
    "CVMId": cvmId,
    "VoucherNo": voucherNo,
    "VoucherSNo": voucherSNo,
    "Ref": ref,
    "InfoNo": infoNo,
    "OtherInfo": otherInfo,
    "Notes": notes,
    "AID": aid,
    "TVR": tvr,
    "TC": tc,
    "POSSerialNo": posSerialNo,
    "CopyFor": copyFor,
    "FL1": fl1,
    "FL2": fl2,
    "FL3": fl3,
    "RFU1": rfu1,
    "RFU2": rfu2,
    "RFU3": rfu3,
    "RFU4": rfu4,
    "RFU5": rfu5,
    "RFU6": rfu6,
    "SignImage": signImage,
  };
}
