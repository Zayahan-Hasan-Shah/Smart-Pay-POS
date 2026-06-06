import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import '../utils/urls.dart';

class CustomHttpClient {
  static Future<http.Client> getClient() async {
    final baseUrl = URLS.baseUrl;
    
    // If the base URL starts with https, configure the SecurityContext
    if (baseUrl.startsWith('https://')) {
      try {
        final certBytes = await rootBundle.load('assets/certs/Root_CA.pem');
        
        SecurityContext context = SecurityContext(withTrustedRoots: true);
        context.setTrustedCertificatesBytes(certBytes.buffer.asUint8List());
        
        HttpClient httpClient = HttpClient(context: context);
        return IOClient(httpClient);
      } catch (e) {
        // Fallback or error logging
        log("Error loading Root CA certificate: $e");
        return http.Client();
      }
    } else {
      // For standard http:// return normal client without strict SSL pinning
      return http.Client();
    }
  }
}
