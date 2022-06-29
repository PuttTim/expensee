import 'package:expensee/models/app_colours.dart';
import 'package:expensee/models/category.dart';
import 'package:expensee/screens/view_transaction_screen.dart';
import 'package:expensee/utilities/capitaliseString.dart';
import 'package:expensee/utilities/datetime_to_displayed_time.dart';
import 'package:flutter/material.dart';

import '../models/transaction_record.dart';

class TransactionRecordCard extends StatelessWidget {
  const TransactionRecordCard({Key? key, required this.record, required this.index}) : super(key: key);

  final TransactionRecord record;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewTransactionScreen(record: record, index: index),
          ),
        ),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                flex: 1,
                child: Icon(
                  Icons.attach_money_rounded,
                  size: 48,
                  color: AppColours.transactionGreen,
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.payee,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: AppColours.transactionGreen, fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          Icon(categoryToIcon(record.category), color: AppColours.transactionGreen),
                          Text(
                            // Capitalises the first letter of the Category's name.
                            // As changing the enum's value (i.e shopping) to 'Shopping' would be against naming conventions.
                            record.category.name.capitalize(),
                            style: const TextStyle(color: AppColours.forestryGreen, fontSize: 16),
                          )
                        ],
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          dateTimeToDisplayedTime(record.time),
                          textAlign: TextAlign.left,
                          style: const TextStyle(color: AppColours.forestryGreen, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${record.amount} ${record.currency}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: record.isPositive ? AppColours.splitPurple : AppColours.feistyOrange,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Text(''),
                      Text(
                        record.type.name.capitalize(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: AppColours.forestryGreen, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
