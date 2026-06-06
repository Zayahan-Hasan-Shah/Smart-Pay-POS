import 'dart:io';
import 'dart:convert';

void main() {
  final file = File('assets/certs/Root_CA.crt');
  if (!file.existsSync()) {
    print("Error: assets/certs/Root_CA.crt does not exist.");
    exit(1);
  }
  
  final bytes = file.readAsBytesSync();
  final base64Str = base64.encode(bytes);
  
  final lines = <String>[];
  for (var i = 0; i < base64Str.length; i += 64) {
    lines.add(base64Str.substring(i, i + 64 > base64Str.length ? base64Str.length : i + 64));
  }
  
  final pemStr = '-----BEGIN CERTIFICATE-----\n${lines.join('\n')}\n-----END CERTIFICATE-----\n';
  
  final outFile = File('assets/certs/Root_CA.pem');
  outFile.writeAsStringSync(pemStr);
  print("Successfully converted Root_CA.crt to Root_CA.pem!");
}
