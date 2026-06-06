class URLS{
  // static const String baseUrl = "http://207.180.248.203:9091/";
  // static const String baseUrl = "http://85.245.83.2:6065/";
  static const String baseUrl = "http://192.168.100.197:6065/";
  // static const String baseUrl = "http://182.180.187.115:6065/";
  // static const String CreateBillBaseUrl = 'http://85.245.173.173:6065/';

  static const String getBillUrl = "${baseUrl}Bill/LatestBill";
  static const String createBillUrl = "${baseUrl}Bill/Push";
  static const String paymentUrl = '${baseUrl}Bill/Payment';
} 