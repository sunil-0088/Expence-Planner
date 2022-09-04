import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _allTransactions;
  final Function _deleteTransaction;

  const TransactionList(this._allTransactions, this._deleteTransaction,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return _allTransactions.isEmpty
          // No Transactions
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: constraints.maxHeight * 0.1,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "It's lonely out here!",
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 22.0,
                        fontFamily: "Quicksand",
                      ),
                    ),
                  ),
                ),
              ],
            )
          // Transactions Present
          : ListView.builder(
              itemCount: _allTransactions.length,
              itemBuilder: (context, index) {
                Transaction txn = _allTransactions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 3.0, vertical: 3.0),
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                      vertical: 1.0,
                      horizontal: 5.0,
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: ListTile(
                        leading: Container(
                          width: 70.0,
                          height: 50.0,
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: Theme.of(context).backgroundColor,
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              '₹${txn.txnAmount}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                // color: Col,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          txn.txnTitle,
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        subtitle: Text(
                          DateFormat('MMMM d, y   ')
                              .add_jm()
                              .format(txn.txnDateTime),
                          // DateFormat.yMMMMd().format(txn.txnDateTime),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline),
                          color: Theme.of(context).errorColor,
                          onPressed: () => _deleteTransaction(txn.txnId),
                          tooltip: "Delete Transaction",
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
    });
  }
}
