import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRHelper {
  /// Extracts consumerNo (CNIC), reference number, and name from the image
  static Future<Map<String, String>> extractFieldsFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final recognizedText = await textRecognizer.processImage(inputImage);
    final text = recognizedText.text;

    // Extract CNIC
    final RegExp cnicRegex = RegExp(r'\b\d{5}-\d{7}-\d{1}\b');
    String? formattedCnic = cnicRegex.firstMatch(text)?.group(0);
    String cleanedCnic = formattedCnic?.replaceAll('-', '') ?? '';

    // Extract Reference Number
    final RegExp refNoRegex = RegExp(r'Ref(?:erence)?\s*[:\-]?\s*([A-Za-z0-9\-]+)', caseSensitive: false);
    String? referenceNo = refNoRegex.firstMatch(text)?.group(1) ?? '';

    // Extract Name
    final RegExp nameRegex = RegExp(r'Name\s*[:\-]?\s*(.+)', caseSensitive: false);
    String? name = nameRegex.firstMatch(text)?.group(1)?.trim() ?? '';

    await textRecognizer.close();

    return {
      'consumerNo': cleanedCnic,
      'referenceNo': referenceNo,
      'consumerDetail': name,
    };
  }
}
