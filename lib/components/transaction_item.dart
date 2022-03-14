import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final Function(String) deleteTransaction;
  const TransactionItem({required this.transaction, required this.deleteTransaction, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
                child: Text(
              'R\$ ${transaction.value.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white),
            )),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat('d MMM y', 'pt_br').format(transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 480
            ? TextButton.icon(
                onPressed: () => deleteTransaction(transaction.id),
                icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
                label: Text(
                  'Excluir',
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              )
            : IconButton(
                icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
                onPressed: () => deleteTransaction(transaction.id)),
      ),
    );
  }
}
