import 'package:expensee/screens/transaction_form_screen.dart';
import 'package:expensee/screens/transfer_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../models/app_colours.dart';

class NewRecordScreen extends StatelessWidget {
  const NewRecordScreen({Key? key}) : super(key: key);

  /// This screen has the two tabs which will show either Transaction Form or Transfer Form depending on the selected tab.
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Create New Record'),
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
                    Tab(text: 'Transaction'),
                    Tab(text: 'Transfer'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    TransactionFormScreen(),
                    TransferFormScreen(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
