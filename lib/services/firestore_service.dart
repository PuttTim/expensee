import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensee/models/account.dart';
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

    return list;
  }

  Future<void> insertRecord(dynamic record) async {
    if (record.runtimeType == TransactionRecord) {
      await db.collection('records').add(record.toJson());
    } else if (record.runtimeType == TransferRecord) {
      await db.collection('records').add(record.toJson());
    }
  }

  Future<void> updateRecord(dynamic record) async {
    // debugPrint(record.docId);
    if (record.runtimeType == TransactionRecord) {
      await db
          .collection('records')
          .doc(record.docId)
          .update(record.toJson())
          .onError((error, stackTrace) => debugPrint('error: $error, stackTrace: $stackTrace'));
    } else if (record.runtimeType == TransferRecord) {
      await db.collection('records').doc(record.docId).update(record.toJson());
    }
  }

  Stream<List<Account>> fetchAccountsStream() {
    Stream<List<Account>> list = db.collection('accounts').snapshots().map((snapshot) => snapshot.docs.map((doc) {
          return Account.fromFirestore(doc);
        }).toList());

    return list;
  }

  Stream<Account> getAccountById(String docId) {
    Stream<Account> stream = db.collection('accounts').doc(docId).get().then((doc) {
      return Account.fromFirestore(doc);
    }).asStream();
    // debugPrint('stream: ${stream.toString()}');
    return stream;
  }

  Future<void> addAccount(Account account) {
    return db.collection('accounts').add(account.toJson());
  }

  Future<void> updateCurrentAccount(Account account) async {
    db.collection('accounts').where('isCurrentAccount', isEqualTo: true).get().then((QuerySnapshot snapshot) {
      return db.collection('accounts').doc(snapshot.docs.first.id).update({'isCurrentAccount': false});
    });

    // When Firestore updates too fast:
    Timer(const Duration(milliseconds: 250), () {
      db.collection('accounts').doc(account.id).update({'isCurrentAccount': true});
    });
  }

  Future<void> modifyAccountValue(String accountId, double value) async {
    db.collection('accounts').doc(accountId).update({'value': value});
  }
}
