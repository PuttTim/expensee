import 'package:expensee/models/app_colours.dart';
import 'package:flutter/material.dart';

class TransactionRecordCard extends StatelessWidget {
  const TransactionRecordCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: const Icon(
                Icons.attach_money_rounded,
                size: 48,
                color: AppColours.transactionGreen,
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'McDonalds',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: AppColours.transactionGreen, fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Icon(Icons.restaurant, color: AppColours.forestryGreen),
                      Text(
                        'Food',
                        style: TextStyle(fontSize: 16, color: AppColours.forestryGreen),
                      )
                    ],
                  ),
                  Text(
                    '2022-02-02',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, color: AppColours.forestryGreen),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '-20.00 SGD',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: AppColours.feistyOrange, fontSize: 24),
                  ),
                  Text(''),
                  Text(
                    'Cashless',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: AppColours.forestryGreen),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
