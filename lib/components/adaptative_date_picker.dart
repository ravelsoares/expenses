import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdaptativeDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const AdaptativeDatePicker(
      {required this.selectedDate, required this.onDateChanged, Key? key})
      : super(key: key);

  _showDatePicker(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;

      onDateChanged(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? SizedBox(
            height: 180,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: onDateChanged,
              initialDateTime: selectedDate,
              minimumDate: DateTime(DateTime.now().year),
              maximumDate: DateTime(DateTime.now().year),
            ),
          )
        : Row(
            children: [
              TextButton(
                onPressed: () => _showDatePicker(context),
                child: const Icon(Icons.calendar_today),
              ),
              Text(DateFormat('dd/MM/y').format(selectedDate)),
            ],
          );
  }
}
