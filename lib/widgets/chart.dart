import 'package:expense_planner/modals/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  const Chart(this.recentTransaction);

  List<Map<String, Object>> get groupedTransactionValue {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(
        Duration(days: index),
      );
      
      // ignore: unused_local_variable
      var totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].data.day == weekday.day &&
            recentTransaction[i].data.month == weekday.month &&
            recentTransaction[i].data.year == weekday.year) {
          totalSum += recentTransaction[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionValue.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(groupedTransactionValue);
    return Card(
      elevation: 6,
        margin: EdgeInsets.all(10),
        // color: Colors.blue,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValue.map((data) {
              return Flexible(
              fit: FlexFit.tight,
                child: ChartBar(
                  data['day'],
                  data['amount'],
                  maxSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / maxSpending,
                ),
              );
            }).toList(),
          ),
        ));
  }
}
