import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../providers/bill_provider.dart';
import 'package:pos/core/validations/app_validations.dart';
import 'package:pos/view/components/bill_widgets/bill_date_widget.dart';
import 'package:pos/view/components/common/custom_text_field/custom_text_field.dart';
import 'package:pos/view/components/common/fractionally_elevated_button.dart';
import 'package:pos/view/components/common/title_text.dart';
import 'package:pos/view/components/ocr_widget/ocr_helper.dart';

class AddAndUpdateBillScreen extends ConsumerStatefulWidget {
  const AddAndUpdateBillScreen({super.key});

  @override
  ConsumerState<AddAndUpdateBillScreen> createState() => _AddAndUpdateBillScreenState();
}

class _AddAndUpdateBillScreenState extends ConsumerState<AddAndUpdateBillScreen> {

  final formKey = GlobalKey<FormState>();
  final _appValidations = AppValidations();

  // Controllers
  final consumerNoController = TextEditingController();
  final referenceNoController = TextEditingController();
  final consumerDetailController = TextEditingController();
  final amountPKRController = TextEditingController();
  final lateFeePKRController = TextEditingController();
  final consumerPhoneNoController = TextEditingController();
  final consumerEmailController = TextEditingController();
  final billDueDateController = TextEditingController();
  final billExpiryController = TextEditingController();
  final violateBillMonthController = TextEditingController();
  final serviceController = TextEditingController();

  // Dates
  DateTime? billMonth;
  DateTime? billDueDate;
  DateTime? billExpiry;

  // OCR & image
  final selectedImageNotifier = ValueNotifier<File?>(null);

  final random = Random();

  @override
  void dispose() {
    consumerNoController.dispose();
    referenceNoController.dispose();
    consumerDetailController.dispose();
    amountPKRController.dispose();
    lateFeePKRController.dispose();
    consumerPhoneNoController.dispose();
    consumerEmailController.dispose();
    billDueDateController.dispose();
    billExpiryController.dispose();
    violateBillMonthController.dispose();
    serviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FractionallyElevatedButton(
              onTap: _pickImageAndExtractOCR,
              // widthFactor: 1,
              // buttonBackgroundColor: Colors.blueGrey.shade400,
              title: 'SCAN FROM IMAGE (OCR)',
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder<File?>(
              valueListenable: selectedImageNotifier,
              builder: (context, imageFile, child) {
                if (imageFile == null) return const SizedBox(height: 2);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.file(imageFile, height: 200),
                );
              },
            ),
            const SizedBox(height: 10),
            TitleText(title: 'Consumer Number'),
            CustomTextField(
              controller: consumerNoController,
              validator: _appValidations.validateConsumerNo,
              keyboardType: TextInputType.phone,
              hintText: 'Consumer Number',
            ),
            // buildInputWidget(
            //   controller: consumerNoController,
            //   hint: 'Enter Consumer Number',

            //   validator: _appValidations.validateConsumerNo,
            //   keyboardType: TextInputType.phone,
            // ),
            TitleText(title: 'Reference Number'),
            CustomTextField(
              controller: referenceNoController,
              hintText: 'Reference Number',
              validator: _appValidations.validateReferenceNo,
            ),
            // buildInputWidget(
            //   controller: referenceNoController,
            //   hintText: 'Reference Number',
            //   validator: _appValidations.validateReferenceNo,
            // ),
            TitleText(title: 'Consumer Details'),
            CustomTextField(
              controller: consumerDetailController,
              hintText: 'Consumer Detail',
              validator: _appValidations.validateConsumerDetail,
            ),
            // buildInputWidget(
            //   controller: consumerDetailController,
            //   hint: 'Enter Consumer Detail',
            //   validator: _appValidations.validateConsumerDetail,
            // ),
            TitleText(
              title: 'Violation',
              fontSize: 14,
              weight: FontWeight.w500,
            ),
            GestureDetector(
              onTap: () => _selectServiceAndGenerateFees(context),
              child: AbsorbPointer(
                child:
                // TextFormField(
                //   controller: serviceController,
                //   decoration: inputDecoration('Select Service'),
                // ),
                CustomTextField(
                  controller: serviceController,
                  hintText: 'Select Service',
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: amountPKRController,
              hintText: 'Violation Fee',
              validator: _appValidations.validateAmount,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            // buildInputWidget(
            //   controller: amountPKRController,
            //   hint: 'Violation Fee',
            //   validator: _appValidations.validateAmount,
            //   keyboardType: TextInputType.phone,
            // ),
            CustomTextField(
              controller: lateFeePKRController,
              hintText: 'Violation Late Fee',
              validator: _appValidations.validateAmount,
              keyboardType: TextInputType.phone,
            ),
            // buildInputWidget(
            //   controller: lateFeePKRController,
            //   hint: 'Violation Late Fee',
            //   validator: _appValidations.validateAmount,
            //   keyboardType: TextInputType.phone,
            // ),
            BillDateWidget(
              controller: billDueDateController,
              hint: 'Bill Due Date',
              context: context,
              onDateSelected: (date) => billDueDate = date,
            ),
            const SizedBox(height: 10),
            BillDateWidget(
              controller: billExpiryController,
              hint: 'Bill Expiry Date',
              context: context,
              onDateSelected: (date) => billExpiry = date,
            ),
            SizedBox(height: 5),
            TitleText(title: 'Mobile Number'),
            CustomTextField(
              controller: consumerPhoneNoController,
              hintText: 'Enter Consumer Phone Number',
              validator: _appValidations.validatePhoneNumberValidation,
              keyboardType: TextInputType.phone,
            ),
            // buildInputWidget(
            //   controller: consumerPhoneNoController,
            //   hint: 'Enter Consumer Phone Number',
            //   validator: _appValidations.validatePhoneNumberValidation,
            //   keyboardType: TextInputType.phone,
            // ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: sendButton()),
                const SizedBox(width: 12),
                Expanded(child: addBill()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // InputDecoration inputDecoration(String hint) => InputDecoration(
  //   hintText: hint,
  //   hintStyle: TextStyle(
  //     fontSize: 13,
  //     fontWeight: FontWeight.bold,
  //     color: Colors.black26,
  //   ),
  //   border: UnderlineInputBorder(
  //     borderRadius: BorderRadius.circular(8),
  //     borderSide: const BorderSide(color: Colors.grey),
  //   ),
  //   enabledBorder: UnderlineInputBorder(
  //     borderRadius: BorderRadius.circular(8),
  //     borderSide: const BorderSide(color: Colors.grey),
  //   ),
  //   focusedBorder: UnderlineInputBorder(
  //     borderRadius: BorderRadius.circular(8),
  //     borderSide: const BorderSide(color: AppColors.appGreen),
  //   ),
  //   contentPadding: const EdgeInsets.only(left: 16),
  // );

  // Widget buildInputWidget({
  //   required TextEditingController controller,
  //   required String hint,
  //   required String? Function(String?) validator,
  //   TextInputType? keyboardType,
  //   bool readOnly = false,
  //   bool obsText = false,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 10),
  //     child: CustomTextField(
  //       controller: controller,
  //       hintText: hint,
  //       // value: readOnly,
  //       validator: validator,
  //       keyboardType: keyboardType,
  //       obscureText: obsText,
  //     ),
  //   );
  // }

  Future<void> _selectServiceAndGenerateFees(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) {
        final violations = [
          'Violation 1',
          'Violation 2',
          'Violation 3',
          'Violation 4',
        ];
        return AlertDialog(
          title: const Text('Select Violation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                violations
                    .map(
                      (v) => ListTile(
                        title: Text(v),
                        onTap: () => Navigator.pop(context, v),
                      ),
                    )
                    .toList(),
          ),
        );
      },
    );

    if (result != null) {
      serviceController.text = result;
      final now = DateTime.now();
      billMonth = DateTime(now.year, now.month, 1);
      billDueDate = now.add(const Duration(days: 2));
      billExpiry = now.add(const Duration(days: 4));

      amountPKRController.text = (random.nextInt(5000) + 1000).toString();
      lateFeePKRController.text = (random.nextInt(500) + 100).toString();

      final df = DateFormat('dd-MM-yyyy');
      billDueDateController.text = df.format(billDueDate!);
      billExpiryController.text = df.format(billExpiry!);
    }
  }

  Future<void> _pickImageAndExtractOCR() async {
    if (await Permission.camera.request().isGranted) {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.camera);

      if (pickedImage != null) {
        final file = File(pickedImage.path);
        selectedImageNotifier.value = file;
        final extracted = await OCRHelper.extractFieldsFromImage(file);

        final consumerNo = extracted['consumerNo'];
        final referenceNo = extracted['referenceNo'];
        final detail = extracted['consumerDetail'];

        if (consumerNo != null && referenceNo != null && detail != null) {
          setState(() {
            consumerNoController.text = '6005$consumerNo';
            referenceNoController.text = referenceNo;
            consumerDetailController.text = detail;
          });
          showSnack('OCR data loaded successfully');
        } else {
          showSnack('Incomplete OCR data', Colors.orange);
        }
      }
    } else {
      showSnack('Camera permission denied', Colors.red);
    }
  }

  Widget sendButton() {
    return FractionallyElevatedButton(
      buttonBackgroundColor: Colors.white70,
      onTap: _handleSubmit('Send Challan'),
      // widthFactor: 1,
      // buttonBackgroundColor: Colors.amber,
      title: 'Send Challan',
      //  const Text(
      //   'Send Challan',
      //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      // ),
    );
  }

  Widget addBill() => FractionallyElevatedButton(
    onTap: _handleSubmit('Add Challan'),
    // widthFactor: 1,
    title: 'Add Challan',
    //  const Text(
    //   'Add Challan',
    //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    // ),
  );

  VoidCallback _handleSubmit(String action) => () async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final amount = int.tryParse(amountPKRController.text.trim());
    final lateFee = int.tryParse(lateFeePKRController.text.trim());

    if (billDueDate == null || billExpiry == null || billMonth == null) {
      showSnack(
        'Please select a violation to generate bill dates first.',
        Colors.red,
      );
      return;
    }

    if (amount == null || lateFee == null) {
      showSnack('Amount or late fee is not valid', Colors.red);
      return;
    }

    try {
      print('Amount: $amount');
      print('Late Fee: $lateFee');
      print('Consumer Number: ${consumerNoController.text.trim()}');
      print('Due Date: ${DateFormat('yyyyMMdd').format(billDueDate!)}');

      await ref.read(billProvider.notifier).createBill(
        amount: amount,
        lateFeeAmount: lateFee,
        consumerNumber: consumerNoController.text.trim(),
        dueDate: DateFormat('yyyyMMdd').format(billDueDate!),
        expDate: DateFormat('yyyyMMdd').format(billExpiry!),
        billingMonth: DateFormat('yyMM').format(billMonth!),
        email: "xyz@email.com",
        cellNumber: consumerPhoneNoController.text.trim(),
        consumerDetail: consumerDetailController.text.trim(),
        referenceInfo: referenceNoController.text.trim(),
        reserved: serviceController.text.trim(),
      );

      if (action == 'Send Challan') {
        consumerNoController.clear();
        referenceNoController.clear();
        consumerDetailController.clear();
        amountPKRController.clear();
        lateFeePKRController.clear();
        consumerPhoneNoController.clear();
        consumerEmailController.clear();
        serviceController.clear();

        setState(() {
          billDueDate = null;
          billExpiry = null;
          billMonth = null;
          billDueDateController.clear();
          billExpiryController.clear();
        });

        showSnack('Challan successfully added.', Colors.green);
      }
    } catch (e) {
      showSnack('Error: $e', Colors.red);
    }
  };

  void showSnack(String msg, [Color color = Colors.black]) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}




  // bill type
  // String? actionType;
  // bool _isActionDropdownExpanded = false;

  // Widget buildActionTypeDropdown() {
  //   final List<String> actionOptions = ['Add', 'Update'];
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       TitleText(
  //           title: 'Select Action', fontSize: 14, weight: FontWeight.bold),
  //       const SizedBox(height: 6),
  //       GestureDetector(
  //         onTap: () {
  //           setState(() {
  //             _isActionDropdownExpanded = !_isActionDropdownExpanded;
  //           });
  //         },
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
  //           decoration: BoxDecoration(
  //               border: Border.all(color: Colors.grey),
  //               borderRadius: BorderRadius.circular(8)),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               TitleText(title: actionType ?? 'Select Action', fontSize: 16),
  //               Icon(_isActionDropdownExpanded
  //                   ? Icons.arrow_drop_up
  //                   : Icons.arrow_drop_down)
  //             ],
  //           ),
  //         ),
  //       ),
  //       if (_isActionDropdownExpanded)
  //         Column(
  //           children: actionOptions.map((option) {
  //             return ListTile(
  //               title: Text(option),
  //               onTap: () {
  //                 setState(() {
  //                   actionType = option;
  //                   _isActionDropdownExpanded = false;
  //                 });
  //               },
  //             );
  //           }).toList(),
  //         ),
  //       const SizedBox(height: 16),
  //     ],
  //   );
  // }



  // bool validateBillDates(BuildContext context) {
  //   try {
  //     final dateFormat = DateFormat('dd-MM-yyyy');
  //     final dueDate = dateFormat.parse(billDueDateController.text);
  //     final expiryDate = dateFormat.parse(billExpiryController.text);

  //     if (expiryDate.isBefore(dueDate) ||
  //         expiryDate.isAtSameMomentAs(dueDate)) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Bill expiry date must be after the due date.'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //       return false;
  //     }
  //     return true;
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please enter both Due Date and Expiry Date.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return false;
  //   }
  // }