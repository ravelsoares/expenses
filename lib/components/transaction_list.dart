import 'package:expenses/components/transaction_item.dart';
import 'package:expenses/components/without_transactions.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(this.transactions, this._deleteTransaction, {Key? key})
      : super(key: key);

  final List<Transaction> transactions;
  final Function(String) _deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? const WithoutTransactions()
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return TransactionItem(
                  transaction: transactions[index],
                  deleteTransaction: _deleteTransaction);
            },
          );
  }
}
