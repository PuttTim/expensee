import 'dart:async';

import 'package:currency_picker/currency_picker.dart';
import 'package:expensee/models/AppColours.dart';
import 'package:expensee/utilities/countrycode_to_emoji.dart';
import 'package:flutter/material.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  String time = '';
  Timer? timer;
  String primaryCurrency = 'SGD';

  setPrimaryCurrency(String code) {
    setState(() => {primaryCurrency = code});
  }

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
                padding: const EdgeInsets.only(
                    left: 8, right: 8, top: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        '${countryToEmoji(primaryCurrency)} $primaryCurrency',
                        style: const TextStyle(
                          color: AppColours.forestryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
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
                          onSelect: (Currency currency) =>
                              setPrimaryCurrency(currency.code),
                        )
                      },
                      child: const Text('Select'),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
