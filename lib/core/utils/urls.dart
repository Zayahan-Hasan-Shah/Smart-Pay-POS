import 'package:shared_preferences/shared_preferences.dart';

class URLS {
  static String baseUrl = "http://192.168.100.197:6065/";

  static String get getBillUrl => "${baseUrl}Bill/LatestBill";
  static String get paymentUrl => "${baseUrl}Bill/Payment";
  static String get createBillUrl => "${baseUrl}Bill/Push";
  // static String get paymentSuccessUrl => "${baseUrl}Bill/PaymentSuccess";

  static Future<void> initBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString('saved_base_url');
    if (savedUrl != null && savedUrl.isNotEmpty) {
      baseUrl = savedUrl;
    }
  }

  static Future<void> updateBaseUrl(String newUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_base_url', newUrl);
    baseUrl = newUrl;
  }
}