import 'package:expensee/providers/records_provider.dart';
import 'package:expensee/screens/new_record_screen.dart';
import 'package:expensee/widgets/account_card.dart';
import 'package:expensee/widgets/transaction_record_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_colours.dart';
import '../providers/accounts_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewRecordScreen(),
          ),
        ),
        child: const Icon(Icons.add, color: AppColours.wittyWhite),
      ),
      appBar: AppBar(title: Text('Home'), actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => Provider.of<AccountsProvider>(context, listen: false).refresh(),
        ),
      ]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Consumer<AccountsProvider>(builder: (context, accountsProvider, _) {
              return SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: accountsProvider.accounts.length,
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10),
                  itemBuilder: (BuildContext context, int index) => AccountCard(
                    account: accountsProvider.accounts[index],
                  ),
                ),
              );
            }),
          ),
          Consumer<RecordsProvider>(
            builder: (context, recordsProvider, child) {
              List<dynamic> records = recordsProvider.records;
              // Sorts the transactions by DateTime, newest record first.
              records.sort((a, b) {
                return b.time.compareTo(a.time);
              });
              return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => TransactionRecordCard(record: records[index], index: index),
                itemCount: recordsProvider.records.length,
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
