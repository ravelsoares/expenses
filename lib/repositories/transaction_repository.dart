import 'dart:convert';

import 'package:expenses/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionRespository {
  late SharedPreferences prefs;

  Future<List<Transaction>> getTransactions() async {
    prefs = await SharedPreferences.getInstance();
    final String jsonString = prefs.getString('transactions') ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    List<Transaction> transactions =
        jsonDecoded.map((e) => Transaction.fromJson(e)).toList();
    return transactions;
  }

  void saveTransactions(List<Transaction> transactions) {
    final jsonString = json.encode(transactions);
    prefs.setString('transactions', jsonString);
  }
}
