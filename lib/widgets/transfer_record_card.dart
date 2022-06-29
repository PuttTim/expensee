import 'package:expensee/models/app_colours.dart';
import 'package:expensee/providers/accounts_provider.dart';
import 'package:expensee/screens/view_transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transfer_record.dart';
import '../utilities/datetime_to_displayed_time.dart';

class TransferRecordCard extends StatelessWidget {
  TransferRecordCard({Key? key, required this.record, required this.index}) : super(key: key);

  final TransferRecord record;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewTransferScreen(record: record, index: index),
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
                  Icons.sync_alt_rounded,
                  size: 48,
                  color: AppColours.transferTeal,
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        Provider.of<AccountsProvider>(context, listen: false).fetchAccount(record.fromAccountId).name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(color: AppColours.transferTeal, fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '-${record.fromAmount.toString()}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: AppColours.feistyOrange, fontSize: 24),
                      ),
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
              Icon(
                Icons.east_rounded,
                size: 48,
                color: AppColours.transferTeal,
              ),
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            Provider.of<AccountsProvider>(context, listen: false).fetchAccount(record.toAccountId).name,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                color: AppColours.transferTeal, fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '+${record.toAmount.toString()}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: AppColours.splitPurple, fontSize: 24),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '@ 1.0 ${record.fromCurrency} / ${record.conversionRate}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: AppColours.forestryGreen, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
