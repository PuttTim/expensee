import 'package:expensee/models/AppColours.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expensee',
      theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: AppColours.wittyWhite,
          colorScheme: const ColorScheme.light(
              background: AppColours.wittyWhite,
              primary: AppColours.forestryGreen,
              secondary: AppColours.moodyPurple)),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('HALLO'),
      ),
    );
  }
}
