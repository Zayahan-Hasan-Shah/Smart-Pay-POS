import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/snackbar_service.dart';
import '../../../../core/utils/urls.dart';
import '../../../../view/components/common/custom_button/custom_button.dart';

class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  int _tapCount = 0;
  bool _showUrlInput = false;
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _urlController.text = URLS.baseUrl;
  }

  void _handleSecretTap() {
    setState(() {
      _tapCount++;
      if (_tapCount >= 10 && !_showUrlInput) {
        _showUrlInput = true;
        SnackbarService.showSuccess("Developer Mode", "Base URL configuration unlocked.");
      }
    });
  }

  Future<void> _saveUrl() async {
    final newUrl = _urlController.text.trim();
    if (newUrl.isEmpty) {
      SnackbarService.showError("Error", "URL cannot be empty");
      return;
    }

    // Ensure it ends with /
    final formattedUrl = newUrl.endsWith('/') ? newUrl : '$newUrl/';

    await URLS.updateBaseUrl(formattedUrl);
    
    if (mounted) {
      SnackbarService.showSuccess("Success", "Base URL updated successfully");
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("System Settings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Center(
              child: Icon(Icons.settings_system_daydream, size: 80, color: AppColors.primaryColor.withOpacity(0.5)),
            ),
            const SizedBox(height: 20),
            const Text(
              "SmartPay POS Config",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _handleSecretTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "App Version: 1.0.0",
                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            if (_showUrlInput) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("API Base URL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  hintText: "http://192.168.1.1:8080/",
                ),
              ),
              const SizedBox(height: 30),
              loginButton(
                context: context,
                title: "Save Configuration",
                onTap: _saveUrl,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
