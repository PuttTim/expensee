import 'package:expensee/models/transfer_record.dart';
import 'package:flutter/material.dart';

import '../models/transfer_type_enum.dart';
import '../widgets/transfer_record_card.dart';

class SplitsScreen extends StatelessWidget {
  const SplitsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Splits')),
      // Temporary placeholder
      body: TransferRecordCard(
        record: TransferRecord(
          fromAccountId: '3',
          toAccountId: '1',
          fromCurrency: 'THB',
          toCurrency: 'SGD',
          fromAmount: 250,
          toAmount: 10,
          type: TransferType.transfer,
          time: DateTime(2020, 1, 1),
          conversionRate: 25,
          note: '',
        ),
        index: 0,
      ),
    );
  }
}
