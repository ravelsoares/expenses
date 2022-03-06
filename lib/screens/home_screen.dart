import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:expenses/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transaction> _transactions = [
    /*Transaction(
      id: 't1',
      title: 'Conta 1',
      value: 100,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Conta 2',
      value: 100,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'Conta 3',
      value: 100,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'Conta 4',
      value: 100,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't5',
      title: 'Conta 5',
      value: 100,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't6',
      title: 'Conta 6',
      value: 100,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't7',
      title: 'Conta 7',
      value: 100,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't8',
      title: 'Conta 8',
      value: 100,
      date: DateTime.now(),
    ),*/
  ];
  final TransactionRespository _transactionRespository =
      TransactionRespository();

  bool _showChart = false;

  List<Transaction> get _recentTransaction {
    return _transactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );
    setState(() {
      _transactions.add(newTransaction);
    });
    Navigator.of(context).pop();
    _transactionRespository.saveTransactions(_transactions);
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((transaction) {
        return transaction.id == id;
      });
    });
    _transactionRespository.saveTransactions(_transactions);
  }

  @override
  void initState() {
    super.initState();
    _transactionRespository.getTransactions().then((value) {
      setState(() {
        _transactions = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        'Despesas Pessoais',
        style: TextStyle(fontSize: 20 * MediaQuery.of(context).textScaleFactor),
      ),
      actions: [
        if (MediaQuery.of(context).orientation == Orientation.landscape)
          IconButton(
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              });
            },
            icon: Icon(_showChart ? Icons.bar_chart : Icons.list),
          ),
        IconButton(
          onPressed: () => _openTransactionFormModal(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );

    final availableheight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showChart || !isLandscape)
              SizedBox(
                height: isLandscape
                    ? availableheight * 0.7
                    : availableheight * 0.25,
                child: Chart(_recentTransaction),
              ),
            if (!_showChart || !isLandscape)
              SizedBox(
                  height: availableheight * 0.75,
                  child: TransactionList(_transactions, _deleteTransaction)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
