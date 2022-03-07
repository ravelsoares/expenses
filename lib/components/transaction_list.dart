import 'package:expenses/components/without_transactions.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                        'R\$ ${transactions[index].value.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    DateFormat('d MMM y', 'pt_br')
                        .format(transactions[index].date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 480
                      ? TextButton.icon(
                          onPressed: () =>
                              _deleteTransaction(transactions[index].id),
                          icon: Icon(Icons.delete,
                              color: Theme.of(context).errorColor),
                          label: Text(
                            'Excluir',
                            style:
                                TextStyle(color: Theme.of(context).errorColor),
                          ),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete,
                              color: Theme.of(context).errorColor),
                          onPressed: () =>
                              _deleteTransaction(transactions[index].id)),
                ),
              );
            });
  }
}
