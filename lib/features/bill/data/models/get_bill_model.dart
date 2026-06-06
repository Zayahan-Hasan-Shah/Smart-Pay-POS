// To parse this JSON data, do
//
//     final getBillsModel = getBillsModelFromJson(jsonString);

import 'dart:convert';

List<GetBillsModel> getBillsModelFromJson(String str) =>
    List<GetBillsModel>.from(
      json.decode(str).map((x) => GetBillsModel.fromJson(x)),
    );

String getBillsModelToJson(List<GetBillsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetBillsModel {
  dynamic BillId;
  dynamic ConsumerNumber;
  dynamic ConsumerDetail;
  dynamic ReferenceInfo;
  dynamic Institution;
  dynamic Address;
  dynamic BillingMonth;
  dynamic DueDate1;
  dynamic DueDate2;
  dynamic ExpDate;
  dynamic EffectiveDueDate;
  dynamic Currency;
  dynamic BillAmount;
  dynamic LateFee;
  dynamic PaymentStatus;
  dynamic AmountPaid;
  dynamic PaymentDateTime;
  dynamic AuthNo;
  dynamic AdcFee;
  dynamic QrFeeFix;
  dynamic QrFeePer;
  dynamic CardFeePer;
  dynamic QrFeeAmount;
  dynamic CardFeeAmount;
  dynamic Email;
  dynamic CellNo;
  dynamic Features;
  dynamic PfMerchantId;
  dynamic PfSecureKey;
  dynamic BillGenerateOn;
  dynamic OnProd;

  GetBillsModel({
    this.BillId,
    this.ConsumerNumber,
    this.ConsumerDetail,
    this.ReferenceInfo,
    this.Institution,
    this.Address,
    this.BillingMonth,
    this.DueDate1,
    this.DueDate2,
    this.ExpDate,
    this.EffectiveDueDate,
    this.Currency,
    this.BillAmount,
    this.LateFee,
    this.PaymentStatus,
    this.AmountPaid,
    this.PaymentDateTime,
    this.AuthNo,
    this.AdcFee,
    this.QrFeeFix,
    this.QrFeePer,
    this.CardFeePer,
    this.QrFeeAmount,
    this.CardFeeAmount,
    this.Email,
    this.CellNo,
    this.Features,
    this.PfMerchantId,
    this.PfSecureKey,
    this.BillGenerateOn,
    this.OnProd,
  });

  factory GetBillsModel.fromJson(Map<String, dynamic> json) => GetBillsModel(
    BillId: json["BillId"],
    ConsumerNumber: json["ConsumerNumber"] ?? json["Consumer_Number"]?.toString() ?? "",
    ConsumerDetail: json["ConsumerDetail"] ?? json["Consumer_Detail"]?.toString() ?? "",
    ReferenceInfo: json["ReferenceInfo"] ?? json["Reference_Info"]?.toString() ?? "",
    Institution: json["Institution"]?.toString() ?? "",
    Address: json["Address"]?.toString() ?? "",
    BillingMonth: json["BillingMonth"]?.toString() ?? "",
    DueDate1: json["DueDate1"]?.toString() ?? "",
    DueDate2: json["DueDate2"]?.toString() ?? "",
    ExpDate: json["ExpDate"]?.toString() ?? "",
    EffectiveDueDate: json["EffectiveDueDate"]?.toString() ?? "",
    Currency: json["Currency"]?.toString() ?? "",
    BillAmount: json["BillAmount"]?.toString() ?? "",
    LateFee: json["LateFee"]?.toString() ?? "",
    PaymentStatus: json["PaymentStatus"]?.toString() ?? "",
    AmountPaid: json["AmountPaid"] ?? json["Amount_Paid"],
    PaymentDateTime: json["PaymentDateTime"],
    AuthNo: json["AuthNo"],
    AdcFee: json["AdcFee"] ?? json["ADC_FEE"],
    QrFeeFix: json["QrFeeFix"] ?? json["QR_Fee_Fix"],
    QrFeePer: json["QrFeePer"] ?? json["QR_Fee_Per"],
    CardFeePer: json["CardFeePer"] ?? json["Card_Fee_Per"],
    QrFeeAmount: json["QrFeeAmount"] ?? json["QR_Fee_Amount"],
    CardFeeAmount: json["CardFeeAmount"] ?? json["Card_Fee_Amount"],
    Email: json["Email"]?.toString() ?? "",
    CellNo: json["CellNo"],
    Features: json["Features"]?.toString() ?? "",
    PfMerchantId: json["PfMerchantId"],
    PfSecureKey: json["PfSecureKey"],
    BillGenerateOn: json["BillGenerateOn"]?.toString() ?? "",
    OnProd: json["OnProd"],
  );

  Map<String, dynamic> toJson() => {
    "BillId": BillId,
    "ConsumerNumber": ConsumerNumber,
    "ConsumerDetail": ConsumerDetail,
    "ReferenceInfo": ReferenceInfo,
    "Institution": Institution,
    "Address": Address,
    "BillingMonth": BillingMonth,
    "DueDate1": DueDate1,
    "DueDate2": DueDate2,
    "ExpDate": ExpDate,
    "EffectiveDueDate": EffectiveDueDate,
    "Currency": Currency,
    "BillAmount": BillAmount,
    "LateFee": LateFee,
    "PaymentStatus": PaymentStatus,
    "AmountPaid": AmountPaid,
    "PaymentDateTime": PaymentDateTime,
    "AuthNo": AuthNo,
    "AdcFee": AdcFee,
    "QrFeeFix": QrFeeFix,
    "QrFeePer": QrFeePer,
    "CardFeePer": CardFeePer,
    "QrFeeAmount": QrFeeAmount,
    "CardFeeAmount": CardFeeAmount,
    "Email": Email,
    "CellNo": CellNo,
    "Features": Features,
    "PfMerchantId": PfMerchantId,
    "PfSecureKey": PfSecureKey,
    "BillGenerateOn": BillGenerateOn,
    "OnProd": OnProd,
  };
}
// class GetBillsModel {
//   int? trid;
//   String? logo;
//   String? hl1;
//   String? hl2;
//   String? hl3;
//   String? hl4;
//   int? mid;
//   String? tid;
//   DateTime? trDate;
//   String? trTime;
//   String? batchNo;
//   String? invoiceNo;
//   String? rrn;
//   dynamic authNo;
//   String? cardNo;
//   String? cardExpiry;
//   String? scheme;
//   String? cardTech;
//   String? trModeId;
//   String? trTypeId;
//   String? trCurrencyCode;
//   String? trCurrency;
//   dynamic trAmt;
//   String? trtip;
//   String? troAmt;
//   String? trtAmt;
//   String? cardCurrencyCode;
//   String? cardCurrency;
//   String? cardAmt;
//   String? cardTip;
//   String? cardOAmt;
//   String? cardTAmt;
//   String? dccExRate;
//   int? cvmId;
//   String? voucherNo;
//   String? voucherSNo;
//   String? ref;
//   String? infoNo;
//   String? otherInfo;
//   String? notes;
//   String? aid;
//   String? tvr;
//   String? tc;
//   String? posSerialNo;
//   String? copyFor;
//   String? fl1;
//   String? fl2;
//   String? fl3;
//   String? rfu1;
//   dynamic rfu2;
//   dynamic rfu3;
//   String? rfu4;
//   String? rfu5;
//   int? rfu6;
//   String? signImage;

//   GetBillsModel({
//     this.trid,
//     this.logo,
//     this.hl1,
//     this.hl2,
//     this.hl3,
//     this.hl4,
//     this.mid,
//     this.tid,
//     this.trDate,
//     this.trTime,
//     this.batchNo,
//     this.invoiceNo,
//     this.rrn,
//     this.authNo,
//     this.cardNo,
//     this.cardExpiry,
//     this.scheme,
//     this.cardTech,
//     this.trModeId,
//     this.trTypeId,
//     this.trCurrencyCode,
//     this.trCurrency,
//     this.trAmt,
//     this.trtip,
//     this.troAmt,
//     this.trtAmt,
//     this.cardCurrencyCode,
//     this.cardCurrency,
//     this.cardAmt,
//     this.cardTip,
//     this.cardOAmt,
//     this.cardTAmt,
//     this.dccExRate,
//     this.cvmId,
//     this.voucherNo,
//     this.voucherSNo,
//     this.ref,
//     this.infoNo,
//     this.otherInfo,
//     this.notes,
//     this.aid,
//     this.tvr,
//     this.tc,
//     this.posSerialNo,
//     this.copyFor,
//     this.fl1,
//     this.fl2,
//     this.fl3,
//     this.rfu1,
//     this.rfu2,
//     this.rfu3,
//     this.rfu4,
//     this.rfu5,
//     this.rfu6,
//     this.signImage,
//   });

//   factory GetBillsModel.fromJson(Map<String, dynamic> json) => GetBillsModel(
//     trid: json["TRID"],
//     logo: json["Logo"],
//     hl1: json["HL1"],
//     hl2: json["HL2"],
//     hl3: json["HL3"],
//     hl4: json["HL4"],
//     mid: json["MID"],
//     tid: json["TID"],
//     trDate: json["TRDate"] == null ? null : DateTime.parse(json["TRDate"]),
//     trTime: json["TRTime"],
//     batchNo: json["BatchNo"],
//     invoiceNo: json["InvoiceNo"],
//     rrn: json["RRN"],
//     authNo: json["AuthNo"],
//     cardNo: json["CardNo"],
//     cardExpiry: json["CardExpiry"],
//     scheme: json["Scheme"],
//     cardTech: json["CardTech"],
//     trModeId: json["TRModeId"]?.toString(),
//     trTypeId: json["TRTypeID"]?.toString(),
//     trCurrencyCode: json["TRCurrencyCode"],
//     trCurrency: json["TRCurrency"],
//     trAmt: json["TRAmt"],
//     trtip: json["TRTIP"],
//     troAmt: json["TROAmt"],
//     trtAmt: json["TRTAmt"],
//     cardCurrencyCode: json["CardCurrencyCode"],
//     cardCurrency: json["CardCurrency"],
//     cardAmt: json["CardAmt"],
//     cardTip: json["CardTip"],
//     cardOAmt: json["CardOAmt"],
//     cardTAmt: json["CardTAmt"],
//     dccExRate: json["DCCExRate"],
//     cvmId: json["CVMId"],
//     voucherNo: json["VoucherNo"],
//     voucherSNo: json["VoucherSNo"],
//     ref: json["Ref"],
//     infoNo: json["InfoNo"],
//     otherInfo: json["OtherInfo"],
//     notes: json["Notes"],
//     aid: json["AID"],
//     tvr: json["TVR"],
//     tc: json["TC"],
//     posSerialNo: json["POSSerialNo"],
//     copyFor: json["CopyFor"],
//     fl1: json["FL1"],
//     fl2: json["FL2"],
//     fl3: json["FL3"],
//     rfu1: json["RFU1"],
//     rfu2: json["RFU2"],
//     rfu3: json["RFU3"],
//     rfu4: json["RFU4"],
//     rfu5: json["RFU5"],
//     rfu6: json["RFU6"],
//     signImage: json["SignImage"],
//   );

//   Map<String, dynamic> toJson() => {
//     "TRID": trid,
//     "Logo": logo,
//     "HL1": hl1,
//     "HL2": hl2,
//     "HL3": hl3,
//     "HL4": hl4,
//     "MID": mid,
//     "TID": tid,
//     "TRDate": trDate?.toIso8601String(),
//     "TRTime": trTime,
//     "BatchNo": batchNo,
//     "InvoiceNo": invoiceNo,
//     "RRN": rrn,
//     "AuthNo": authNo,
//     "CardNo": cardNo,
//     "CardExpiry": cardExpiry,
//     "Scheme": scheme,
//     "CardTech": cardTech,
//     "TRModeId": trModeId,
//     "TRTypeID": trTypeId,
//     "TRCurrencyCode": trCurrencyCode,
//     "TRCurrency": trCurrency,
//     "TRAmt": trAmt,
//     "TRTIP": trtip,
//     "TROAmt": troAmt,
//     "TRTAmt": trtAmt,
//     "CardCurrencyCode": cardCurrencyCode,
//     "CardCurrency": cardCurrency,
//     "CardAmt": cardAmt,
//     "CardTip": cardTip,
//     "CardOAmt": cardOAmt,
//     "CardTAmt": cardTAmt,
//     "DCCExRate": dccExRate,
//     "CVMId": cvmId,
//     "VoucherNo": voucherNo,
//     "VoucherSNo": voucherSNo,
//     "Ref": ref,
//     "InfoNo": infoNo,
//     "OtherInfo": otherInfo,
//     "Notes": notes,
//     "AID": aid,
//     "TVR": tvr,
//     "TC": tc,
//     "POSSerialNo": posSerialNo,
//     "CopyFor": copyFor,
//     "FL1": fl1,
//     "FL2": fl2,
//     "FL3": fl3,
//     "RFU1": rfu1,
//     "RFU2": rfu2,
//     "RFU3": rfu3,
//     "RFU4": rfu4,
//     "RFU5": rfu5,
//     "RFU6": rfu6,
//     "SignImage": signImage,
//   };
// }
