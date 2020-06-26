import 'package:flutter/material.dart';

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
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void newTransaction() {
    if(titleController.text.isEmpty || amountController.text.isEmpty || amountController.text == '0') {
      return;
    }
    
    widget.addTransaction(
      titleController.text,
      double.parse(
        amountController.text,
      ),
    );

    Navigator.of(context).pop();
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
            controller: titleController,
            onSubmitted: (_) => newTransaction(),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Amount'),
            controller: amountController,
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
            ),
            onSubmitted: (_) => newTransaction(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: FlatButton(
              onPressed: newTransaction,
              child: Text(
                'Add Transaction',
                style: TextStyle(fontSize: 16),
              ),
              textColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
