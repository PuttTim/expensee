import 'package:currency_picker/currency_picker.dart';
import 'package:expensee/models/app_colours.dart';
import 'package:expensee/providers/currency_provider.dart';
import 'package:expensee/widgets/exchange_rates_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/currency_rates.dart';
import '../providers/currency_provider.dart';
import '../utilities/countrycode_to_emoji.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currencies'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Primary Currency',
                style: TextStyle(
                  color: AppColours.forestryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Consumer<Currencies>(
                        builder: (context, currencies, child) => Text(
                          '${countryToEmoji(currencies.primaryCurrency)} ${currencies.primaryCurrency}',
                          style: const TextStyle(
                            color: AppColours.moodyPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => {
                        showCurrencyPicker(
                          context: context,
                          currencyFilter: <String>['EUR', 'SGD', 'THB', 'USD'],
                          theme: CurrencyPickerThemeData(
                            flagSize: 25,
                            titleTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: AppColours.moodyPurple,
                            ),
                            bottomSheetHeight:
                                MediaQuery.of(context).size.height / 2,
                            subtitleTextStyle: const TextStyle(
                              fontSize: 15,
                              color: AppColours.paleMoodyPurple,
                            ),
                          ),
                          onSelect: (Currency currency) => context
                              .read<Currencies>()
                              .setPrimary(currency.code),
                        )
                      },
                      child: const Text('Select'),
                    )
                  ],
                ),
              ),
            ),
            Consumer<Currencies>(
              builder: (context, currencies, child) =>
                  FutureBuilder<CurrencyRates>(
                future: currencies.getCurrencyRate(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    CurrencyRates data = snapshot.data!;
                    return ListView.separated(
                      padding: const EdgeInsets.only(top: 16, bottom: 32),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ExchangeRatesCard(
                        base: currencies.primaryCurrency,
                        rates: data.rates.values.toList()[index],
                        currency: data.rates.keys.toList()[index],
                      ),
                      itemCount: data.rates.length,
                      separatorBuilder: (context, index) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    );
                  } else {
                    return Text('waiting..');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
