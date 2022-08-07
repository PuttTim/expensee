import 'package:flutter/material.dart';

import '../models/account.dart';
import '../models/app_colours.dart';
import '../services/firestore_service.dart';

class AccountCard extends StatelessWidget {
  AccountCard({Key? key, required this.account}) : super(key: key);

  final Account account;
  @override
  Widget build(BuildContext context) {
    bool isCurrentAccount = account.isCurrentAccount;

    return Container(
      width: 128,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),

      /// GestureDetector allows for tapping on the card to select it.
      child: GestureDetector(
        onTap: () => FirestoreService().updateCurrentAccount(account),
        child: Material(
          elevation: isCurrentAccount ? 4 : 0,
          color: isCurrentAccount ? AppColours.forestryGreen : AppColours.wittyWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColours.forestryGreen),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  account.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: isCurrentAccount ? AppColours.wittyWhite : AppColours.forestryGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '${account.primaryCurrency} ${account.value}',
                  style: TextStyle(
                      color: isCurrentAccount ? AppColours.wittyWhite : AppColours.forestryGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
