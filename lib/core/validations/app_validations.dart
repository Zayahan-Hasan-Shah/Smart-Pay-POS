import 'package:flutter/material.dart';

class AppValidations {
  /// Check valid Consumer No
  String? validateConsumerNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    } else if (value.length == 4) {
      return 'Please enter consumer No';
    }
    return null;
  }

  /// Check valid Reference No
  String? validateReferenceNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  /// Check valid Consumer Detail
  String? validateConsumerDetail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field can\'t be empty';
    }

    final RegExp nameRegExp = RegExp(r'^[a-zA-Z ]+$');

    if (!nameRegExp.hasMatch(value.trim())) {
      return 'Only alphabets and spaces are allowed';
    }
    return null;
  }

  /// Check amount
  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  /// validating expiry and due date
  bool validateBillDates(
      BuildContext context,
      TextEditingController billDueDateController,
      TextEditingController billExpiryDateController) {
    try {
      final dueDate = DateTime.parse(billDueDateController.text);
      final expiryDate = DateTime.parse(billExpiryDateController.text);

      if (expiryDate.isBefore(dueDate) ||
          expiryDate.isAtSameMomentAs(dueDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bill expiry date must be after the due date.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both Due Date and Expiry Date.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  /// Phone number validation check
  String? validatePhoneNumberValidation(String? value) {
    if (value == null) return 'Phone number is required';

    if (value.startsWith('923')) {
      /// exactly 11 digits: 923 + 8 digits
      if (RegExp(r'^923\d{9}$').hasMatch(value)) return null;
    }
    return 'Incorrect phone number';
  }

  String? emailValidation(String? value) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    } else if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }
}
