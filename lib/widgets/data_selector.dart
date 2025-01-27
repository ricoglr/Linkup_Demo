import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final String label;
  final DateTime? initialDate;
  final Function(DateTime?) onDateSelected;

  const DateSelector({
    Key? key,
    required this.label,
    required this.onDateSelected,
    this.initialDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        onDateSelected(selectedDate);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          initialDate != null
              ? "${initialDate!.day}/${initialDate!.month}/${initialDate!.year}"
              : 'Bir tarih seçin',
        ),
      ),
    );
  }
}
