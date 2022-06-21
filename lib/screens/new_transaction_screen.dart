import 'package:flutter/material.dart';

class NewTransactionScreen extends StatelessWidget {
  const NewTransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Transaction')),
      body: Center(
        child: Text("hello"),
      ),
    );
  }
}
