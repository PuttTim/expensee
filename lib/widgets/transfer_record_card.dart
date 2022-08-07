import 'package:expensee/models/app_colours.dart';
import 'package:expensee/screens/view_transfer_screen.dart';
import 'package:expensee/services/firestore_service.dart';
import 'package:flutter/material.dart';

import '../models/account.dart';
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
          elevation: 4,
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder(
                        stream: FirestoreService().getAccountById(record.fromAccountId),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text("Loading");
                          }

                          Account? account = snapshot.data;
                          return FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              account?.name ?? '',
                              style: const TextStyle(
                                color: AppColours.transferTeal,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
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
              ),
              const Icon(
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
                      StreamBuilder(
                        stream: FirestoreService().getAccountById(record.toAccountId),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text("Loading");
                          }

                          Account? account = snapshot.data;
                          return FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              account?.name ?? '',
                              style: const TextStyle(
                                color: AppColours.transferTeal,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
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
                          '@ 1.0 ${record.fromCurrency} = ${record.conversionRate}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: AppColours.forestryGreen, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
