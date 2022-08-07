import 'package:expensee/models/transaction_record.dart';
import 'package:expensee/services/firestore_service.dart';
import 'package:expensee/widgets/transaction_record_card.dart';
import 'package:expensee/widgets/transfer_record_card.dart';
import 'package:flutter/material.dart';

import '../models/transfer_record.dart';

class AllRecordsScreen extends StatelessWidget {
  const AllRecordsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Records'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirestoreService().fetchRecordsStream(),
              builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                List<dynamic>? records = snapshot.data;

                if (snapshot.hasError) {
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
                  itemCount: records!.length,
                  separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
