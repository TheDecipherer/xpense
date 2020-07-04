import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Xpense',
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(
                color: Colors.white,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
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

  bool _showChart = false;

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

  Widget _chartWidget(
      double sizeValue, PreferredSizeWidget appBar, MediaQueryData mediaQuery) {
    return Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          sizeValue,
      child: Chart(_recentTransactions),
    );
  }

  List<Widget> _buildLandscape(PreferredSizeWidget appBar,
      MediaQueryData mediaQuery, Widget transactionListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show chart',
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).primaryColor,
              value: _showChart,
              onChanged: (value) {
                setState(() {
                  _showChart = value;
                });
              }),
        ],
      ),
      _showChart
          ? _chartWidget(0.7, appBar, mediaQuery)
          : transactionListWidget,
    ];
  }

  List<Widget> _buildPortrait(PreferredSizeWidget appBar,
      MediaQueryData mediaQuery, Widget transactionListWidget) {
    return [
      _chartWidget(0.3, appBar, mediaQuery),
      transactionListWidget,
    ];
  }

  PreferredSizeWidget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Xpense'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _openAddTransactionBottomSheet(context),
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text('Xpense'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _openAddTransactionBottomSheet(context),
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = _buildAppBar();

    final transactionListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscape(
                appBar,
                mediaQuery,
                transactionListWidget,
              ),
            if (!isLandscape)
              ..._buildPortrait(
                appBar,
                mediaQuery,
                transactionListWidget,
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _openAddTransactionBottomSheet(context),
                    child: Icon(Icons.add),
                  ),
          );
  }
}
