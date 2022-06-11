import 'package:flutter/material.dart';
import '../modals/transaction.dart';
// import './user_trasaction.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TransactionList extends StatefulWidget {
  final List<Transaction> transaction;
  Function deletetx;

  TransactionList(this.transaction, this.deletetx);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.transaction.isEmpty
        ? LayoutBuilder(
            builder: (context, constrain) {
              return Column(
                children: <Widget>[
                  Container(
                      height: constrain.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/images/3.png',
                        fit: BoxFit.cover,
                      )),
                  // ignore: deprecated_member_use
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'no transaction',
                    // ignore: deprecated_member_use
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(
                          child: Text('\₹${widget.transaction[index].amount}')),
                    ),
                  ),
                  title: Text(
                    widget.transaction[index].title,
                    // ignore: deprecated_member_use
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(DateFormat.yMMMd().format(
                    widget.transaction[index].data,
                  )),
                  trailing: MediaQuery.of(context).size.width > 360
                      ? FlatButton.icon(
                          icon: Icon(Icons.delete),
                          label: Text('Delete'),
                          color: Theme.of(context).errorColor,
                          onPressed: () =>
                              widget.deletetx(widget.transaction[index].id),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () =>
                              widget.deletetx(widget.transaction[index].id),
                        ),
                ),
              );
            },
            itemCount: widget.transaction.length,
          );
  }
}
