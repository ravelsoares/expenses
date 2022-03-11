import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeTextField extends StatelessWidget {
  final String label;
  final Function(String) onSubmitted;
  final TextEditingController textController;
  final TextInputType typeInputBoard;

  const AdaptativeTextField(
      {required this.label,
      required this.onSubmitted,
      required this.textController,
      this.typeInputBoard = TextInputType.text,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CupertinoTextField(
              onSubmitted: (_) => onSubmitted,
              controller: textController,
              keyboardType: typeInputBoard,
              placeholder: label,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 6,
              ),
            ),
          )
        : TextField(
            decoration: InputDecoration(labelText: label),
            onSubmitted: onSubmitted,
            controller: textController,
            keyboardType: typeInputBoard,
          );
  }
}
