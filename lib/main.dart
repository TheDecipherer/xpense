import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Xpense',
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 'id1',
    //   name: 'Groceries',
    //   amount: 39.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 'id2',
    //   name: 'Food',
    //   amount: 29.99,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final _newTransaction = Transaction(
      id: DateTime.now().toString(),
      name: title,
      amount: amount,
      date: chosenDate,
    );

    setState(() {
      _userTransactions.add(_newTransaction);
    });
  }

  void _openAddTransactionBottomSheet(BuildContext buildContext) {
    showModalBottomSheet(
      context: buildContext,
      builder: (_) {
        /// Gesture detector not needed nowadays.
        /// Check before implementing.
        /// Needed if bottomSheet is dismissed onTap.

        return GestureDetector(
          child: NewTransaction(_addNewTransaction),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xpense'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _openAddTransactionBottomSheet(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Chart(_recentTransactions),
            TransactionList(_userTransactions, _deleteTransaction),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTransactionBottomSheet(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
