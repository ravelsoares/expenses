import 'dart:io';
import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:expenses/repositories/transaction_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transaction> _transactions = [];
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
      isScrollControlled: true,
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

  Widget _getIconButton(Function() function, IconData icon) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: function,
            child: Icon(icon),
          )
        : IconButton(onPressed: function, icon: Icon(icon));
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
        )
      ],
    );

    final availableheight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
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
                  height:
                      isLandscape ? availableheight : availableheight * 0.75,
                  child: TransactionList(_transactions, _deleteTransaction)),
          ],
        ),
      ),
    );

    final iconList = Platform.isIOS ? CupertinoIcons.list_bullet : Icons.list;
    final iconChart =
        Platform.isIOS ? CupertinoIcons.chart_bar_alt_fill : Icons.bar_chart;

    final actions = [
      if (MediaQuery.of(context).orientation == Orientation.landscape)
        _getIconButton(
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
          _showChart ? iconChart : iconList,
        ),
      _getIconButton(
        () => _openTransactionFormModal(context),
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
      ),
    ];

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('Despesas Pessoais'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _openTransactionFormModal(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
