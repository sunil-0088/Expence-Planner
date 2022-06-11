import 'dart:io';

import 'package:expense_planner/widgets/new_trasaction.dart';
import 'package:expense_planner/widgets/transaction_list.dart';
// ignore: unused_import
import 'package:flutter/services.dart';
// import 'package:expense/widgets/transaction_list.dart';
// import 'package:expense/widgets/user_trasaction.dart';
import 'package:flutter/material.dart';
import './modals/transaction.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.yellow,
          errorColor: Colors.red,
          fontFamily: 'WLRoyalFlutter',   
          textTheme: ThemeData.light().textTheme.copyWith(
              // ignore: deprecated_member_use
              titleMedium: TextStyle(
                  fontFamily: 'WLRoyalFlutter',
                  fontSize : 20,
                  fontWeight: FontWeight.bold)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  // ignore: deprecated_member_use
                  titleMedium: TextStyle(
                      fontFamily: 'WLRoyalFlutter',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))),
      title: 'Personal Expenses',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  final List<Transaction> _userTransaction = [];

  void _addNewTrasaction(String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        data: chosenDate);

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTrasaction),
            // behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  // ignore: unused_field
  bool _showChart = false;

  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tx) {
      return tx.data.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final isLandscap = mediaquery.orientation == Orientation.landscape;
    final appbar = AppBar(
      title: Text(
        'Personal Expenses',
        style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.normal),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
          ),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
    final txListWidget = Container(
        height: (mediaquery.size.height -
                appbar.preferredSize.height -
                mediaquery.padding.top) *
            0.7,
        child: TransactionList(_userTransaction, _deleteTransaction));
    return SafeArea(
      child: Scaffold(
        appBar: appbar,
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isLandscap)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Show Chart'),
                    Switch.adaptive(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      },
                    ),
                  ],
                ),
              if (!isLandscap)
                Container(
                    height: (mediaquery.size.height -
                            appbar.preferredSize.height -
                            mediaquery.padding.top) *
                        0.3,
                    child: Chart(_recentTransaction)),
              if (!isLandscap) txListWidget,
              if (isLandscap)
                _showChart
                    ? Container(
                        height: (mediaquery.size.height -
                                appbar.preferredSize.height -
                                mediaquery.padding.top) *
                            0.7,
                        child: Chart(_recentTransaction))
                    : txListWidget
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Platform.isIOS
            ? Container()
            : FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
      ),
    );
  }
}
