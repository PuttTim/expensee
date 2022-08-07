import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/transaction_record.dart';
import '../models/transfer_record.dart';

class FirestoreService {
  DocumentReference db = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);

  Stream<List<dynamic>> fetchRecordsStream() {
    dynamic list = db.collection('records').snapshots().map((snapshot) => snapshot.docs.map((doc) {
          {
            doc.data().forEach((key, value) {
              debugPrint('key: $key, value: $value');
            });
            if (doc.data()['recordType'] == 'transaction') {
              return TransactionRecord.fromFirestore(doc);
            } else if (doc.data()['recordType'] == 'transfer') {
              return TransferRecord.fromFirestore(doc);
            }
          }
        }).toList());
    // list.forEach((element) {
    //   debugPrint('hello');
    //   debugPrint(element);
    // });
    // debugPrint(list);

    return list;
  }
}
