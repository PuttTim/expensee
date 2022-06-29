import 'package:expensee/screens/bill_form_screen.dart';
import 'package:expensee/screens/transaction_form_screen.dart';
import 'package:expensee/screens/transfer_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../models/app_colours.dart';

class NewRecordScreen extends StatelessWidget {
  const NewRecordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Create New Transaction'),
          ),
          body: Column(
            children: [
              Material(
                color: AppColours.wittyWhite,
                child: TabBar(
                  indicator: MaterialIndicator(color: AppColours.moodyPurple),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 4,
                  labelColor: AppColours.moodyPurple,
                  indicatorColor: AppColours.moodyPurple,
                  tabs: const [
                    Tab(text: 'Transfer'),
                    Tab(text: 'Transaction'),
                    Tab(text: 'Split'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    TransferFormScreen(),
                    TransactionFormScreen(),
                    BillFormScreen(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
