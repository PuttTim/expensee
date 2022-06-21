import 'package:expensee/screens/new_transaction_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewTransactionScreen(),
          ),
        ),
      ),
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('asd')),
    );
  }
}
