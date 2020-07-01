import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  /// Using stateless widget may result in the loss of internal data stored.
  /// But works perfedct even in stateless widget when I tried.
  /// Used stateful widget to follow the course but should explore more.

  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _newTransaction() {
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _amountController.text == '0' ||
        _selectedDate == null) {
      return;
    }

    widget.addTransaction(
      _titleController.text,
      double.parse(
        _amountController.text,
      ),
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _displayDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Title'),
            controller: _titleController,
            onSubmitted: (_) => _newTransaction(),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Amount'),
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
            ),
            onSubmitted: (_) => _newTransaction(),
          ),
          Container(
            height: 70,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No date selected!'
                        : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                  ),
                ),
                FlatButton(
                  onPressed: _displayDatePicker,
                  child: Text(
                    'Choose Date',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: RaisedButton(
              onPressed: _newTransaction,
              child: Text(
                'Add Transaction',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
