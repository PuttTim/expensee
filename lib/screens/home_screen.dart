import 'package:expensee/providers/records_provider.dart';
import 'package:expensee/screens/new_record_screen.dart';
import 'package:expensee/widgets/transaction_record_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_colours.dart';

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
        appBar: AppBar(title: Text('Home')),
        body: Container(
            child: Consumer<RecordsProvider>(
          builder: (context, recordsProvider, child) => ListView.separated(
            itemBuilder: (context, index) => TransactionRecordCard(record: recordsProvider.records[index]),
            itemCount: recordsProvider.records.length,
            separatorBuilder: (context, index) => Container(),
          ),
        )));
  }
}
