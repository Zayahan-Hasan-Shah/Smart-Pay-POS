import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos/core/utils/app_colors.dart';

class BillDateWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final BuildContext context;
  final Function(DateTime) onDateSelected;
  const BillDateWidget({
    super.key,
    required this.controller,
    required this.hint,
    required this.context,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: UnderlineInputBorder(),
        enabledBorder: UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(),

        focusColor: Colors.green.shade600,
        suffixIcon: Icon(Icons.calendar_today, color: Colors.green.shade600),
        hintStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.black26,
        ),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          confirmText: 'CONFIRM',
          cancelText: 'CANCEL',
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                datePickerTheme: DatePickerThemeData(
                  // Dialog style
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  dividerColor: Colors.green.shade600,

                  // 1) Selected date background reen.shade600
                  dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.green.shade600;
                    }
                    return null; // unselected pe koi bg color nahi
                  }),

                  // selected date text
                  dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.white;
                    }
                    return null;
                  }),

                  // Optional: today ko sirf border se show karna ho
                  todayBorder: BorderSide(color: Colors.green.shade600),
                  todayForegroundColor: WidgetStatePropertyAll(
                    Colors.green.shade600,
                  ),
                  todayBackgroundColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),

                  // 3) Selected year background reen.shade600
                  yearBackgroundColor: WidgetStateProperty.resolveWith((
                    states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.green.shade600;
                    }
                    return null; // unselected year pe koi color nahi
                  }),
                  yearForegroundColor: WidgetStateProperty.resolveWith((
                    states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.white;
                    }
                    return null;
                  }),

                  // 4) Cancel/Confirm text color
                  cancelButtonStyle: TextButton.styleFrom(
                    foregroundColor: Colors.green.shade600,
                  ),
                  confirmButtonStyle: TextButton.styleFrom(
                    foregroundColor: Colors.green.shade600,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          onDateSelected(pickedDate);
        }
      },
    );
  }
}
