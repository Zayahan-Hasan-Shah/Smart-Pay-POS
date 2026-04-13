import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class BillMonthPicker extends StatelessWidget {
  final DateTime? billMonth;
  final Function(DateTime) onMonthPicked;

  const BillMonthPicker({
    super.key,
    required this.billMonth,
    required this.onMonthPicked,
  });

  Future<void> _selectBillOfMonth(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != billMonth) {
      onMonthPicked(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _selectBillOfMonth(context),
      child: Text(
        billMonth != null
            ? DateFormat('MM/yy').format(billMonth!)
            : 'Select Bill Month',
      ),
    );
  }
}
