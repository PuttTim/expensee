import 'dart:async';

import 'package:expensee/models/account.dart';
import 'package:expensee/screens/new_record_screen.dart';
import 'package:expensee/services/auth_service.dart';
import 'package:expensee/services/firestore_service.dart';
import 'package:expensee/widgets/account_card.dart';
import 'package:expensee/widgets/account_dialog_form.dart';
import 'package:expensee/widgets/transaction_record_card.dart';
import 'package:expensee/widgets/transfer_record_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_colours.dart';
import '../models/transaction_record.dart';
import '../models/transfer_record.dart';
import '../providers/navigation_provider.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void logout() {
    Timer(Duration(milliseconds: 500), () {
      AuthService().logoutUser();
    });
  }

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
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
                logout();
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Accounts',
                    style: TextStyle(color: AppColours.forestryGreen, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline_rounded,
                      color: AppColours.moodyPurple,
                      size: 32,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AccountDialogForm();
                        },
                      );
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 80,
                child: StreamBuilder(
                    stream: FirestoreService().fetchAccountsStream(),
                    builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
                      List<Account>? accounts = snapshot.data;

                      if (snapshot.hasError) {
                        return const Text('Something went wrong, please connect to the internet');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }

                      debugPrint('length: ${accounts!.length.toString()}');
                      accounts.forEach((element) {
                        debugPrint('hello');
                        debugPrint(element.toString());
                      });

                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: accounts.length,
                        itemBuilder: (context, index) {
                          return AccountCard(
                            account: accounts[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10),
                      );
                    }),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              child: const Text(
                'Recent Records',
                style: TextStyle(color: AppColours.forestryGreen, fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder(
              stream: FirestoreService().fetchRecordsStream(),
              builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                List<dynamic>? records = snapshot.data;

                if (snapshot.hasError) {
                  debugPrint('Error: ${snapshot.error}');
                  return const Text('Something went wrong, please connect to the internet');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }

                // debugPrint('length: ${records!.length.toString()}');
                //
                // debugPrint('records: $records');
                // records.forEach((element) {
                //   debugPrint('hello');
                //   debugPrint(element.toString());
                // });

                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    /// If/else statement to check whether or not the record type is a TransactionRecord or a TransferRecord.
                    /// and then returns the appropriate widget for that record type.
                    if (records![index].runtimeType == TransactionRecord) {
                      return TransactionRecordCard(
                        record: records[index],
                        index: index,
                      );
                    } else if (records[index].runtimeType == TransferRecord) {
                      return TransferRecordCard(
                        record: records[index],
                        index: index,
                      );
                    } else {
                      return Container();
                    }
                  },
                  separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () {
                Provider.of<NavigationProvider>(context, listen: false).setCurrentScreenIndex(1);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                primary: AppColours.moodyPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('View All Records', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
