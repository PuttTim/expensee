import 'package:expensee/screens/transfer_form_screen.dart';
import 'package:expensee/utilities/capitaliseString.dart';
import 'package:flutter/material.dart';

import '../models/account.dart';
import '../models/app_colours.dart';
import '../models/transfer_record.dart';
import '../services/firestore_service.dart';
import '../utilities/datetime_to_displayed_time.dart';

class ViewTransferScreen extends StatelessWidget {
  const ViewTransferScreen({Key? key, required this.record, required this.index}) : super(key: key);

  final TransferRecord record;
  final int index;

  /// TextStyles for the title and subtitle Texts within the View Screen
  final TextStyle titleStyle = const TextStyle(
    color: AppColours.forestryGreen,
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  final TextStyle subtitleStyle = const TextStyle(
    color: AppColours.forestryGreen,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Record'),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_rounded, color: AppColours.wittyWhite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransferFormScreen(isEditing: true, record: record, index: index),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('From', style: titleStyle),
                  Text('To', style: titleStyle),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      return Text(
                        account!.name,
                        style: subtitleStyle,
                      );
                    },
                  ),
                  const Icon(
                    Icons.east,
                    color: AppColours.forestryGreen,
                    size: 24,
                  ),
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
                      return Text(
                        account!.name,
                        style: subtitleStyle,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('-',
                    style: TextStyle(color: AppColours.feistyOrange, fontSize: 48, fontWeight: FontWeight.w600)),
                Text(
                  record.fromAmount.toString(),
                  style: const TextStyle(
                    color: AppColours.feistyOrange,
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(record.fromCurrency,
                    style: const TextStyle(color: AppColours.forestryGreen, fontSize: 32, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('+',
                    style: TextStyle(color: AppColours.emeraldGreen, fontSize: 48, fontWeight: FontWeight.w600)),
                Text(
                  record.toAmount.toString(),
                  style: const TextStyle(
                    color: AppColours.emeraldGreen,
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(record.toCurrency,
                    style: const TextStyle(color: AppColours.forestryGreen, fontSize: 32, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 16),
              Text('Conversion Rate', style: titleStyle),
              const SizedBox(height: 8),
              Text(
                '1.0 ${record.fromCurrency} = ${record.conversionRate} ${record.toCurrency}',
                style: subtitleStyle,
              ),
              const SizedBox(height: 16),
              Text('Transfer Type', style: titleStyle),
              const SizedBox(height: 8),
              Text(
                record.type.name.capitalize(),
                style: subtitleStyle,
              ),
              const SizedBox(height: 16),
              Text('Time of Transfer', style: titleStyle),
              const SizedBox(height: 8),
              Text(
                dateTimeToDisplayedTime(record.time),
                style: subtitleStyle,
              ),
              const SizedBox(height: 16),
              Text("Note", style: titleStyle),
              const SizedBox(height: 8),
              Text(
                record.note ?? '',
                style: subtitleStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
