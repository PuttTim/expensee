import 'package:expensee/utilities/countrycode_to_emoji.dart';
import 'package:flutter/material.dart';

import '../models/app_colours.dart';

class ExchangeRatesCard extends StatelessWidget {
  const ExchangeRatesCard(
      {Key? key,
      required this.base,
      required this.rates,
      required this.currency})
      : super(key: key);

  final String currency;
  final String base;
  final double rates;

  static const textStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 24,
      color: AppColours.forestryGreen);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      height: 60,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        elevation: 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "${countryToEmoji(currency)} $currency $rates",
              style: textStyle,
            ),
            const Text('=', style: textStyle),
            Text(
              "${1} $base ${countryToEmoji(base)}",
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
