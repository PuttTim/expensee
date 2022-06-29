import 'package:currency_picker/currency_picker.dart';
import 'package:expensee/models/app_colours.dart';
import 'package:expensee/providers/accounts_provider.dart';
import 'package:expensee/providers/currencies_provider.dart';
import 'package:expensee/widgets/exchange_rates_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/currency_rates.dart';
import '../providers/currencies_provider.dart';
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
              padding: const EdgeInsets.only(left: 4, bottom: 16, top: 8),
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
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Consumer<CurrenciesProvider>(
                        builder: (context, currenciesProvider, child) => Text(
                          '${countryToEmoji(currenciesProvider.primaryCurrency)} ${currenciesProvider.primaryCurrency}',
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
                            bottomSheetHeight: MediaQuery.of(context).size.height / 2,
                            subtitleTextStyle: const TextStyle(
                              fontSize: 15,
                              color: AppColours.paleMoodyPurple,
                            ),
                          ),
                          onSelect: (Currency currency) => context.read<CurrenciesProvider>().setPrimary(currency.code),
                        )
                      },
                      child: const Text('Select'),
                    )
                  ],
                ),
              ),
            ),
            Consumer<CurrenciesProvider>(
              builder: (context, currenciesProvider, child) => FutureBuilder<CurrencyRates>(
                future: currenciesProvider.getCurrencyRate(
                    Provider.of<AccountsProvider>(context, listen: true).currentAccount.primaryCurrency),
                builder: (context, snapshot) {
                  debugPrint(snapshot.data?.toString());
                  if (snapshot.connectionState == ConnectionState.done) {
                    DateFormat format = DateFormat('yyyy-MM-dd');
                    CurrencyRates data = snapshot.data ??
                        CurrencyRates(
                          base: 'SGD',
                          date: format.format(DateTime.now()),
                          rates: {'EUR': 0.68, 'THB': 25.25, 'USD': 0.72},
                        );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 4.0),
                          child: Text(
                            'Last updated at',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: AppColours.forestryGreen,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            data.date,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColours.forestryGreen,
                            ),
                          ),
                        ),
                        ListView.separated(
                          padding: const EdgeInsets.only(top: 16, bottom: 32),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => ExchangeRatesCard(
                            base: data.base,
                            rates: data.rates.values.toList()[index],
                            currency: data.rates.keys.toList()[index],
                          ),
                          itemCount: data.rates.length,
                          separatorBuilder: (context, index) => Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.only(top: 16),
                      child: const CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            const ElevatedButton(
              // Placeholder for a future feature as this requires Firestore usage.
              onPressed: null,
              child: Text(
                'Add secondary currency',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
