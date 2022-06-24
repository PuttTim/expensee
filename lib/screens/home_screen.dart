import 'package:expensee/screens/new_record_screen.dart';
import 'package:flutter/material.dart';

import '../models/app_colours.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('asd')),
    );
  }
}
