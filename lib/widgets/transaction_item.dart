import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.userTransaction,
    @required this.mediaQuery,
    @required this.deleteTransaction,
  }) : super(key: key);

  final Transaction userTransaction;
  final MediaQueryData mediaQuery;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 8,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text(
                '\$${userTransaction.amount.toStringAsFixed(2)}',
              ),
            ),
          ),
        ),
        title: Text(
          userTransaction.name,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          new DateFormat.yMMMd().format(userTransaction.date),
        ),
        trailing: mediaQuery.size.width > 460
            ? FlatButton.icon(
                onPressed: () => deleteTransaction(userTransaction.id),
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                textColor: Theme.of(context).errorColor,
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => deleteTransaction(userTransaction.id),
              ),
      ),
    );
  }
}
