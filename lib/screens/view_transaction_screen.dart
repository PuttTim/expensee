import 'package:expensee/models/transaction_record.dart';
import 'package:expensee/screens/transaction_form_screen.dart';
import 'package:expensee/utilities/capitaliseString.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_colours.dart';
import '../models/category.dart';
import '../providers/accounts_provider.dart';
import '../utilities/datetime_to_displayed_time.dart';

class ViewTransactionScreen extends StatelessWidget {
  const ViewTransactionScreen({Key? key, required this.record, required this.index}) : super(key: key);

  final TransactionRecord record;
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
          title: const Text('Transaction Record'),
          actions: [
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_rounded, color: AppColours.wittyWhite),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionFormScreen(isEditing: true, record: record, index: index),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                elevation: 2,
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          record.amount.toString(),
                          style: TextStyle(
                            color: record.isPositive ? AppColours.emeraldGreen : AppColours.feistyOrange,
                            fontSize: 48,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColours.forestryGreen, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          record.currency,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColours.forestryGreen,
                            fontSize: 48,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('Account', style: titleStyle),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  Provider.of<AccountsProvider>(context, listen: false).fetchAccount(record.accountId).name,
                  style: subtitleStyle,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('Paid to', style: titleStyle),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  record.payee,
                  style: subtitleStyle,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('Category', style: titleStyle),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Icon(categoryToIcon(record.category), color: AppColours.transactionGreen),
                    Text(
                      /// Capitalises the first letter of the Category's name.
                      /// As changing the enum's value (i.e shopping) to 'Shopping' would be against naming conventions.
                      record.category.name.capitalize(),
                      style: subtitleStyle,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('Transaction Type', style: titleStyle),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  record.type.name.capitalize(),
                  style: subtitleStyle,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('Time of Transaction', style: titleStyle),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  dateTimeToDisplayedTime(record.time),
                  style: subtitleStyle,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),

                /// Ternary to ensure there is a Note before displaying the title.
                child: Text(record.note!.isNotEmpty ? "Note" : "", style: titleStyle),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  record.note ?? '',
                  style: subtitleStyle,
                ),
              ),
            ],
          ),
        ));
  }
}
