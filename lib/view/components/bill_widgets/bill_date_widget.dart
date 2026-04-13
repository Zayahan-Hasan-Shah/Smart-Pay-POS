import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillDateWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final BuildContext context;
  final Function(DateTime) onDateSelected;
  const BillDateWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.context,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          onDateSelected(pickedDate);
        }
      },
    );
  }
}
