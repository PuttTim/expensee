import 'package:expensee/widgets/exchange_rates_card.dart';
import 'package:flutter/material.dart';

class SplitsScreen extends StatelessWidget {
  const SplitsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Splits')),
        // Temporary placeholder
        body: ListView.separated(
          itemBuilder: (context, index) =>
              ExchangeRatesCard(base: 'USD', currency: 'EUR', rates: 1.1),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
          itemCount: 6,
          separatorBuilder: (context, index) => const Divider(),
        ));
  }
}
