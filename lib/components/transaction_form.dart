import 'package:expenses/components/adaptative_button.dart';
import 'package:expenses/components/adaptative_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm(this.addTransaction, {Key? key}) : super(key: key);

  final void Function(String, double, DateTime) addTransaction;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();

  var _selectedDate = DateTime.now();

  void _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;
    if (title.isEmpty || value <= 0) {
      return;
    }
    widget.addTransaction(title, value, _selectedDate);
  }

  _showDatePicker() async {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10.0,
            left: 10,
            right: 10,
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              AdaptativeTextField(
                label: 'Título',
                onSubmitted: (_) => _submitForm(),
                textController: _titleController,
              ),
              AdaptativeTextField(
                label: 'Valor (R\$)',
                onSubmitted: (_) => _submitForm(),
                textController: _valueController,
                typeInputBoard: const TextInputType.numberWithOptions(),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: _showDatePicker,
                    child: const Icon(Icons.calendar_today),
                  ),
                  Text(DateFormat('dd/MM/y').format(_selectedDate)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AdaptativeButton(
                      label: "Nova Transação", onPressed: _submitForm),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
